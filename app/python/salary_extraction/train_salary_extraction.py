# app/python/salary_extraction/train_model.py

import spacy
import spacy_transformers
import os
from spacy.tokens import DocBin
from spacy.training import Example
from spacy.training import iob_to_biluo
from app.python.utils.label_mapping import get_label_list
from app.python.utils.data_handler import generate_path, load_data, hash_train_data, load_spacy_model
from app.python.utils.logger import configure_logging, configure_warnings
from app.python.utils.spacy_utils import (
    convert_bio_to_spacy_format,
    convert_to_spacy_format,
    handle_convert_to_spacy,
)
from app.python.utils.trainer import train_spacy_model
from app.python.utils.validation_utils import evaluate_model, print_label_token_pairs

FOLDER = "salary_extraction"
BASE_DIR = os.path.join("app", "python", FOLDER)

TRAIN_DATA_FILE = "train_data.json"
CONVERTED_FILE = "train_data_spacy.json"
CONVERTED_FILE_PATH = os.path.join(BASE_DIR, "data", CONVERTED_FILE)
MODEL_SAVE_PATH = os.path.join(BASE_DIR, "model", "spacy_salary_ner_model")
SPACY_DATA_PATH = os.path.join(BASE_DIR, "data", "train.spacy")

VALIDATION_DATA_FILE = "validation_data.json"
validation_data = load_data(VALIDATION_DATA_FILE, FOLDER)

configure_warnings()
configure_logging()

nlp = load_spacy_model(MODEL_SAVE_PATH)

ner = nlp.add_pipe("ner")

for label in get_label_list():
    ner.add_label(label)

if not os.path.exists(generate_path(CONVERTED_FILE, FOLDER)):
    convert_bio_to_spacy_format(TRAIN_DATA_FILE, FOLDER, nlp, CONVERTED_FILE_PATH)

# Register extension for Doc to store indices
spacy.tokens.Doc.set_extension("index", default=None)
handle_convert_to_spacy(SPACY_DATA_PATH, CONVERTED_FILE, FOLDER, TRAIN_DATA_FILE)

converted_data = load_data(CONVERTED_FILE, FOLDER)
# print_label_token_pairs(converted_data)

doc_bin, examples = convert_to_spacy_format(converted_data)
doc_bin.to_disk("app/python/salary_extraction/data/train.spacy")

# ------------------- TRAIN MODEL -------------------
train_spacy_model(MODEL_SAVE_PATH, nlp, examples)


# ------------------- VALIDATE TRAINER -------------------

# evaluate_model(nlp, validation_data)
evaluate_model(nlp, converted_data)


# ------------------- TEST EXAMPLES -------------------

# def convert_example_to_biluo(text):
#     """Convert model predictions for the given text to BILUO format."""
#     doc = nlp(text)
    
#     iob_tags = [token.ent_iob_ + '-' + token.ent_type_ if token.ent_type_ else 'O' for token in doc]
#     biluo_tags = iob_to_biluo(iob_tags)
    
#     return doc, biluo_tags

# def inspect_model_predictions(text):
#     """Inspect model predictions for the given text."""
#     doc, biluo_tags = convert_example_to_biluo(text)

#     print("\nOriginal Text:")
#     print(f"'{text}'\n")
#     print("Token Predictions:")
#     print(f"{'Token':<15}{'Predicted Label':<20}{'BILUO Tag':<20}")
#     print("-" * 50)
#     for token, biluo_tag in zip(doc, biluo_tags):
#         predicted_label = token.ent_type_ if token.ent_type_ else 'O'
#         print(f"{token.text:<15}{predicted_label:<20}{biluo_tag:<20}")

# print("\nExample Prediction:")
# inspect_model_predictions("The salary is expected to be $100,000 annually in USD.")

# test_texts = [
#     "The annual salary is expected to be $120,000 USD.",
#     "Compensation ranges from €50,000 to €70,000 annually.",
#     "Base pay in Canada is CAD 60,000 per year.",
#     "This position offers a minimum salary of £45,000.",
#     "Contractor role with hourly rate of 25 AUD.",
#     "Full-time position with a salary of 80,000 GBP.",
# ]

# for text in test_texts:
#     print(f"\nTesting text: '{text}'")
#     inspect_model_predictions(text)
