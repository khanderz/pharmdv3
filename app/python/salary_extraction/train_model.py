# app/python/salary_extraction/train_model.py
import os
import json
import tensorflow as tf
from transformers import AutoTokenizer, TFAutoModelForTokenClassification, create_optimizer
from datasets import Dataset
from app.python.salary_extraction.label_mapping import get_label_to_id, get_id_to_label, get_label_list

script_dir = os.path.dirname(os.path.abspath(__file__))
train_data_path = os.path.join(script_dir, "data", "train_data.json")
model_save_path = "app/python/salary_extraction/model/salary_ner_model"

with open(train_data_path, "r") as f:
    TRAIN_DATA = json.load(f)

# Initialize tokenizer and model
model_name = "bert-base-cased"
tokenizer = AutoTokenizer.from_pretrained(model_name)

# Check if a saved model exists to continue training
if os.path.exists(model_save_path):
    print("-------------Loading model from checkpoint...")
    model = TFAutoModelForTokenClassification.from_pretrained(model_save_path)
else:
    print("-------------Initializing a new model...")
    model = TFAutoModelForTokenClassification.from_pretrained(
        model_name, num_labels=len(get_label_list())
    )

label_to_id = get_label_to_id()
id_to_label = get_id_to_label()

texts = [item["text"] for item in TRAIN_DATA]
labels = [item["labels"] for item in TRAIN_DATA]
dataset = Dataset.from_dict({"text": texts, "labels": labels})

# Tokenize and align labels with tokens
def tokenize_and_align_labels(examples):
    tokenized_inputs = tokenizer(examples["text"], padding=True, truncation=True)
    all_labels = []
    for i, label in enumerate(examples["labels"]):
        word_ids = tokenized_inputs.word_ids(batch_index=i)
        label_ids = []
        previous_word_idx = None
        for word_idx in word_ids:
            if word_idx is None:
                label_ids.append(-100)
            elif word_idx != previous_word_idx:
                if word_idx < len(label):
                    label_ids.append(label_to_id.get(label[word_idx], -100))
                else:
                    label_ids.append(-100)
            else:
                label_ids.append(-100)
            previous_word_idx = word_idx
        all_labels.append(label_ids)

    tokenized_inputs["labels"] = all_labels
    return tokenized_inputs

# Apply tokenization and alignment
tokenized_dataset = dataset.map(tokenize_and_align_labels, batched=True)

for example in TRAIN_DATA:
    text = example["text"]
    labels = example["labels"]
    
    # Tokenize the text
    tokenized = tokenizer(text, padding=True, truncation=True)
    tokens = tokenized.tokens()
    token_count = len(tokens)
    label_count = len(labels)
    
    # Output results
    print(f"Text: {text}")
    print(f"-----------Token Count: {token_count}")
    print(f"---------------Label Count: {label_count}")
    print(f"Tokens: {tokens}")
    print(f"Labels: {labels}")
    print("-" * 50)

# Convert dataset to TensorFlow Dataset
def encode_example(example):
    return {
        "input_ids": example["input_ids"],
        "attention_mask": example["attention_mask"],
        "labels": example["labels"],
    }

train_dataset = tokenized_dataset.map(encode_example)
train_dataset = train_dataset.to_tf_dataset(
    columns=["input_ids", "attention_mask"],
    label_cols=["labels"],
    shuffle=True,
    batch_size=8,
)

# Define training parameters
batch_size = 8
num_epochs = 5
num_train_steps = len(train_dataset) * num_epochs
num_warmup_steps = int(0.1 * num_train_steps)
init_lr = 1e-5 

# Define optimizer and loss
optimizer, schedule = create_optimizer(
    init_lr=init_lr,
    num_train_steps=num_train_steps,
    num_warmup_steps=num_warmup_steps,
    weight_decay_rate=0.01,
)

# Custom loss function to ignore -100 labels
def masked_sparse_categorical_crossentropy(y_true, y_pred):
    mask = tf.not_equal(y_true, -100)
    y_true = tf.boolean_mask(y_true, mask)
    y_pred = tf.boolean_mask(y_pred, mask)
    return tf.keras.losses.sparse_categorical_crossentropy(y_true, y_pred, from_logits=True)

# Compile model
model.compile(optimizer=optimizer, loss=masked_sparse_categorical_crossentropy)

# Train model
model.fit(train_dataset, epochs=num_epochs)

# Save the model after training
model.save_pretrained(model_save_path)
print("Model saved successfully.")

# Function to verify token and label alignment
def check_token_label_alignment(train_data, tokenizer):
    for example in train_data:
        text = example["text"]
        labels = example["labels"]
        tokenized_inputs = tokenizer(
            text, truncation=True, padding=True, return_offsets_mapping=True
        )
        tokens = tokenizer.convert_ids_to_tokens(tokenized_inputs["input_ids"])
        word_ids = tokenized_inputs.word_ids()
        aligned_labels = []

        for word_idx in word_ids:
            if word_idx is None:
                aligned_labels.append("PAD")
            elif word_idx < len(labels):
                aligned_labels.append(labels[word_idx])
            else:
                aligned_labels.append("O")

        print(f"Text: {text}")
        print(f"Tokens: {tokens}")
        print(f"Labels: {aligned_labels}")
        print("-" * 50)

        

# Test function for single example
def test_model():
    test_text = "The salary is $100,000 annually."
    tokens = tokenizer(test_text, return_tensors="tf", padding=True, truncation=True)
    outputs = model(tokens)
    logits = outputs.logits
    softmax = tf.nn.softmax(logits, axis=-1)
    predictions = tf.argmax(logits, axis=-1)

    predicted_labels = [id_to_label.get(pred, "O") for pred in predictions[0].numpy()]
    confidences = [softmax[0, i, pred].numpy() for i, pred in enumerate(predictions[0].numpy())]
    
    print("Tokens:", tokenizer.tokenize(test_text))
    print("Predicted Labels:", predicted_labels)
    print("Confidences:", confidences)
    

if __name__ == "__main__":
    test_model()

    # check_token_label_alignment(TRAIN_DATA, tokenizer)
