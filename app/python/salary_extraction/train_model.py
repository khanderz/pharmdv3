#  app/python/salary_extraction/train_model.py
# import os
# import sys
import tensorflow as tf
from transformers import (
    AutoTokenizer,
    TFAutoModelForTokenClassification,
    DataCollatorForTokenClassification,
    create_optimizer,
)
from datasets import Dataset

# project_root = os.path.abspath(os.path.join(os.path.dirname(__file__), '../../../..'))
# sys.path.append(project_root)
from app.python.salary_extraction.label_mapping import (
    get_label_to_id,
    get_id_to_label,
    get_label_list,
)


model_name = "bert-base-cased"  # Going to use this model for now
tokenizer = AutoTokenizer.from_pretrained(model_name)
model = TFAutoModelForTokenClassification.from_pretrained(
    model_name, num_labels=len(get_label_list())
)

label_to_id = get_label_to_id()
id_to_label = get_id_to_label()
# print("Label to ID mapping:", label_to_id)
# print("ID to Label mapping:", id_to_label)
# ENTITY_LABELS = ["SALARY_MIN", "SALARY_MAX", "SALARY_SINGLE", "CURRENCY", "INTERVAL", "COMMITMENT", "JOB_COUNTRY"]


TRAIN_DATA = [
    {
        "text": "The salary is $100,000 - $120,000 per year",
        "labels": [
            "O",
            "O",
            "O",
            "B-CURRENCY",
            "B-SALARY_MIN",
            "I-SALARY_MIN",
            "I-SALARY_MIN",
            "O",
            "B-CURRENCY",
            "B-SALARY_MAX",
            "I-SALARY_MAX",
            "I-SALARY_MAX",
            "O",
            "I-INTERVAL",
        ],
    },
    {
        "text": "The United States guaranteed base salary for this position is $80,000 + equity + benefits",
        "labels": [
            "O",
            "B-JOB_COUNTRY",
            "I-JOB_COUNTRY",
            "O",
            "O",
            "O",
            "O",
            "O",
            "O",
            "O",
            "B-CURRENCY",
            "B-SALARY_SINGLE",
            "I-SALARY_SINGLE",
            "I-SALARY_SINGLE",
            "O",
            "O",
            "O",
        ],
    },
    {
        "text": "The expected total target compensation annually is $102,960",
        "labels": [
            "O",
            "O",
            "O",
            "O",
            "O",
            "B-INTERVAL",
            "O",
            "B-CURRENCY",
            "B-SALARY_SINGLE",
            "I-SALARY_SINGLE",
            "I-SALARY_SINGLE",
        ],
    },
    {
        "text": "The United States compensation for this independent contractor position is $60 per visit hour",
        "labels": [
            "O",
            "B-JOB_COUNTRY",
            "I-JOB_COUNTRY",
            "O",
            "O",
            "B-COMMITMENT",
            "I-COMMITMENT",
            "B-CURRENCY",
            "B-SALARY_SINGLE",
            "O",
            "O",
            "O",
            "I-INTERVAL",
        ],
    },
    {
        "text": "The United States new hire base salary target ranges for this full-time position are: Zone A: $94,070-$122,290 + equity + benefits Zone B: $108,181-$140,634 + equity + benefits Zone C: $117,588-$152,863 + equity + benefits Zone D: $122,291 - $158,977 + equity + benefits",
        "labels": [
            "O",
            "B-JOB_COUNTRY",
            "I-JOB_COUNTRY",
            "O",
            "O",
            "O",
            "O",
            "O",
            "O",
            "O",
            "O",
            "B-COMMITMENT",
            "I-COMMITMENT",
            "O",
            "O",
            "O",
            "O",
            "O",
            "O",
            "B-CURRENCY",
            "B-SALARY_MIN",
            "I-SALARY_MIN",
            "I-SALARY_MIN",
            "O",
            "O",
            "O",
            "O",
            "O",
            "O",
            "O",
            "O",
            "O",
            "B-CURRENCY",
            "O",
            "O",
            "O",
            "O",
            "O",
            "O",
            "O",
            "O",
            "O",
            "O",
            "O",
            "O",
            "O",
            "O",
            "O",
            "O",
            "O",
            "O",
            "O",
            "O",
            "O",
            "O",
            "O",
            "O",
            "O",
            "O",
            "O",
            "O",
            "O",
            "B-CURRENCY",
            "B-SALARY_MAX",
            "I-SALARY_MAX",
            "I-SALARY_MAX",
            "O",
            "O",
            "O",
        ],
    },
    {
        "text": "Zone A: 161,410 - 228,000 + equity + benefits Zone B: 185,622 - 262,200 + equity + benefits Zone C: 201,763 - 285,000 + equity + benefits Zone D: 209,833 - 296,400 + equity + benefits",
        "labels": [
            "O",
            "O",
            "O",
            "B-SALARY_MIN",
            "I-SALARY_MIN",
            "I-SALARY_MIN",
            "O",
            "B-SALARY_MAX",
            "I-SALARY_MAX",
            "I-SALARY_MAX",
            "O",
            "O",
            "O",
            "O",
            "O",
            "B-SALARY_MIN",
            "I-SALARY_MIN",
            "I-SALARY_MIN",
            "O",
            "B-SALARY_MAX",
            "I-SALARY_MAX",
            "I-SALARY_MAX",
            "O",
            "O",
            "O",
            "O",
            "O",
            "B-SALARY_MIN",
            "I-SALARY_MIN",
            "I-SALARY_MIN",
            "O",
            "B-SALARY_MAX",
            "I-SALARY_MAX",
            "I-SALARY_MAX",
            "O",
            "O",
            "O",
            "O",
            "O",
            "B-SALARY_MIN",
            "I-SALARY_MIN",
            "I-SALARY_MIN",
            "O",
            "B-SALARY_MAX",
            "I-SALARY_MAX",
            "I-SALARY_MAX",
            "O",
            "O",
            "O",
        ],
    },
]


texts = [item["text"] for item in TRAIN_DATA]
labels = [item["labels"] for item in TRAIN_DATA]
dataset = Dataset.from_dict({"text": texts, "labels": labels})


# Tokenize and align labels with tokens
#  token example : Tokens: ['[CLS]', 'The', 'salary', 'is', '$', '100', ',', '000', '-', '$', '120', ',', '000', 'per', 'year', '[SEP]']
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
num_epochs = 3
num_train_steps = len(train_dataset) * num_epochs
num_warmup_steps = int(0.1 * num_train_steps)

# Define optimizer and loss
optimizer, schedule = create_optimizer(
    init_lr=2e-5,
    num_train_steps=num_train_steps,
    num_warmup_steps=num_warmup_steps,
    weight_decay_rate=0.01,
)

loss = tf.keras.losses.SparseCategoricalCrossentropy(from_logits=True)


# Define custom loss function to ignore -100 labels
def masked_sparse_categorical_crossentropy(y_true, y_pred):
    # Create a mask for valid labels (those that are not -100)
    mask = tf.not_equal(y_true, -100)

    # Apply mask to y_true and y_pred
    y_true = tf.boolean_mask(y_true, mask)
    y_pred = tf.boolean_mask(y_pred, mask)

    # Calculate sparse categorical crossentropy
    return tf.keras.losses.sparse_categorical_crossentropy(
        y_true, y_pred, from_logits=True
    )


# Compile model
model.compile(optimizer=optimizer, loss=masked_sparse_categorical_crossentropy)

# Train model
model.fit(train_dataset, epochs=num_epochs)

# Save  model
model.save_pretrained("app/python/salary_extraction/model/salary_ner_model")


# Function to verify token and label alignment
def check_token_label_alignment(train_data, tokenizer):
    for example in train_data:
        text = example["text"]
        labels = example["labels"]

        # Tokenize the text
        tokenized_inputs = tokenizer(
            text, truncation=True, padding=True, return_offsets_mapping=True
        )
        tokens = tokenizer.convert_ids_to_tokens(tokenized_inputs["input_ids"])

        # Get the word_ids for alignment and map labels
        word_ids = tokenized_inputs.word_ids()
        aligned_labels = []

        for word_idx in word_ids:
            if word_idx is None:
                # Padding tokens
                aligned_labels.append("PAD")
            elif word_idx < len(labels):
                # Map each token to the label
                aligned_labels.append(labels[word_idx])
            else:
                aligned_labels.append("O")  # Default to "O" if label is missing

        print(f"Text: {text}")
        print(f"Tokens: {tokens}")
        print(f"Labels: {aligned_labels}")
        print("-" * 50)


def test_model():
    test_text = "The salary is $100,000 annually."
    tokens = tokenizer(test_text, return_tensors="tf")
    outputs = model(tokens)
    logits = outputs.logits
    predictions = tf.argmax(logits, axis=-1)
    predicted_labels = [model.config.id2label[pred] for pred in predictions[0].numpy()]
    print(
        "Test Output for single value:",
        list(zip(tokenizer.tokenize(test_text), predicted_labels)),
    )


if __name__ == "__main__":
    # test_model()

    check_token_label_alignment(TRAIN_DATA, tokenizer)
