# app/python/salary_extraction/train_model.py
import os
import tensorflow as tf
import logging
import warnings
from transformers import create_optimizer

from app.python.salary_extraction.data_loader import load_data, create_tokenized_dataset
from app.python.salary_extraction.utils.model_utils import load_model, save_model
from app.python.salary_extraction.utils.tokenizer_utils import tokenizer, align_labels_with_tokens_fast
from app.python.salary_extraction.utils.label_mapping import get_id_to_label, get_label_list
from app.python.salary_extraction.utils.validation_utils import check_token_label_length, check_token_label_alignment

warnings.filterwarnings("ignore", category=FutureWarning)

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

script_dir = os.path.dirname(os.path.abspath(__file__))
train_data_path = os.path.join(script_dir, "data", "train_data.json")
model_save_path = "app/python/salary_extraction/model/salary_ner_model"

logger.info("Loading training data...")
TRAIN_DATA = load_data(train_data_path)
tokenized_dataset = create_tokenized_dataset(TRAIN_DATA)

# Load model
num_labels = len(get_label_list())
model = load_model(model_save_path, model_name="bert-base-cased", num_labels=num_labels)
id_to_label = get_id_to_label()

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
num_epochs = 1
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

# Compile
model.compile(optimizer=optimizer, loss=masked_sparse_categorical_crossentropy)

# Train / save model
try:
    logger.info("----------------------Starting model training...")
    model.fit(train_dataset, epochs=num_epochs)
    logger.info("---------------------------Model training complete.")
    save_model(model, model_save_path)
except Exception as e:
    logger.error("An error occurred during training: %s", e)

def test_model():
    test_text = "The salary is $100,000 annually."
    # tokenized =  [The] [salary] [is] [$] [100,000] [annually] [.] 
    expected_labels = ["O", "O", "O", "B-CURRENCY", "B-SALARY_SINGLE", "B-INTERVAL", "O"]

    tokenized_inputs = tokenizer(test_text, return_tensors="tf", padding=True, truncation=True)
    word_ids = tokenized_inputs.word_ids()
    outputs = model(tokenized_inputs)
    logits = outputs.logits
    softmax = tf.nn.softmax(logits, axis=-1)
    predictions = tf.argmax(logits, axis=-1)

    raw_predictions = predictions[0].numpy()
    predicted_labels = [id_to_label.get(pred, "O") for pred in raw_predictions]
    aligned_predicted_labels = align_labels_with_tokens_fast(predicted_labels, word_ids)

    confidences = [softmax[0, idx, pred].numpy() for idx, pred in enumerate(raw_predictions)]
    filtered_confidences = [conf for i, conf in enumerate(confidences) if word_ids[i] is not None]
    
    # Filter out [CLS] and [SEP] from tokens, labels, and confidences
    tokens = tokenizer.convert_ids_to_tokens(tokenized_inputs["input_ids"][0])
    filtered_tokens = [t for i, t in enumerate(tokens) if word_ids[i] is not None]
    filtered_expected_labels = [expected_labels[i] if i < len(expected_labels) else "N/A" for i in range(len(filtered_tokens))]
    filtered_aligned_predicted_labels = [aligned_predicted_labels[i] for i in range(len(filtered_tokens))]


    print(f"{'Token':<15}{'Expected':<20}{'Aligned Predicted':<20}{'Confidence':<20}")
    print("-" * 75)
    for i, token in enumerate(filtered_tokens):
        expected_label = filtered_expected_labels[i] if i < len(filtered_expected_labels) else "N/A"
        predicted_label = filtered_aligned_predicted_labels[i] if i < len(filtered_aligned_predicted_labels) else "N/A"
        confidence = filtered_confidences[i] if i < len(filtered_confidences) else "N/A"
        print(f"{token:<15}{expected_label:<20}{predicted_label:<20}{confidence:<20}")

        
if __name__ == "__main__":
    #  test_model()

    # check_token_label_length(TRAIN_DATA, tokenized_dataset, id_to_label)

    check_token_label_alignment(TRAIN_DATA, id_to_label)
