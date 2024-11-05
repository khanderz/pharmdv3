# app/python/salary_extraction/train_model.py
import os
import tensorflow as tf
import logging
import warnings
from transformers import create_optimizer
from app.python.salary_extraction.data_loader import load_data, create_tokenized_dataset
from app.python.salary_extraction.utils.model_utils import load_model, save_model
from app.python.salary_extraction.utils.tokenizer_utils import tokenizer
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

# Train and save model with logging
try:
    logger.info("----------------------Starting model training...")
    model.fit(train_dataset, epochs=num_epochs)
    logger.info("---------------------------Model training complete.")
    save_model(model, model_save_path)
except Exception as e:
    logger.error("An error occurred during training: %s", e)

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
    check_token_label_length(TRAIN_DATA, tokenized_dataset, id_to_label)
 
     # test_model()
    # check_token_label_alignment(TRAIN_DATA, tokenizer)
