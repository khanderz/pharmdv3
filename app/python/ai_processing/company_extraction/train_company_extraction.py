# app/python/ai_processing/company_extraction/train_company_extraction.py

import spacy
import os
from spacy.training import iob_to_biluo
from app.python.ai_processing.utils.data_handler import load_data, load_spacy_model
from app.python.ai_processing.company_extraction.label_mapping import get_label_list
from app.python.ai_processing.utils.logger import (
    GREEN,
    RED,
    RESET,
    configure_logging,
    configure_warnings,
)
from app.python.ai_processing.utils.spacy_utils import handle_spacy_data
from app.python.ai_processing.utils.trainer import train_spacy_model
from app.python.ai_processing.utils.utils import calculate_entity_indices, print_data_with_entities
from app.python.ai_processing.utils.validation_utils import evaluate_model, validate_entities
from app.python.ai_processing.utils.data_handler import project_root

configure_warnings()
configure_logging()

FOLDER = "company_extraction"
BASE_DIR = os.path.join(project_root, FOLDER)

CONVERTED_FILE = "train_data_spacy.json"
CONVERTED_FILE_PATH = os.path.join(BASE_DIR, "data", CONVERTED_FILE)
MODEL_SAVE_PATH = os.path.join(BASE_DIR, "model", "spacy_company_ner_model")
SPACY_DATA_PATH = os.path.join(BASE_DIR, "data", "train.spacy")

# updated_data = calculate_entity_indices(train_data)
# print_data_with_entities(updated_data)

converted_data = load_data(CONVERTED_FILE, FOLDER)
nlp = load_spacy_model(MODEL_SAVE_PATH)

if "ner" not in nlp.pipe_names:
    ner = nlp.add_pipe("ner")
    print(f"{RED}Added NER pipe to blank model: {nlp.pipe_names}{RESET}")

    for label in get_label_list(entity_type="healthcare_domain"):
        ner.add_label(label)

    spacy.tokens.Doc.set_extension("index", default=None, force=True)
    doc_bin, examples = handle_spacy_data(
        SPACY_DATA_PATH,
        CONVERTED_FILE,
        FOLDER,
        nlp,
    )

    nlp.initialize(get_examples=lambda: examples)

    os.makedirs(MODEL_SAVE_PATH, exist_ok=True)
    nlp.to_disk(MODEL_SAVE_PATH)
    print(f"{GREEN}Model saved to {MODEL_SAVE_PATH} with NER component added.{RESET}")

else:
    ner = nlp.get_pipe("ner")
    print(f"{GREEN}NER pipe already exists in blank model: {nlp.pipe_names}{RESET}")

    doc_bin, examples = handle_spacy_data(
        SPACY_DATA_PATH,
        CONVERTED_FILE,
        FOLDER,
        nlp,
    )

# if examples:
#     for example in examples:
#         print(f"\nText: '{example.reference.text}'")
#         print("Entities after initialization:")
#         for ent in example.reference.ents:
#        

# ------------------- TRAIN MODEL -------------------
train_spacy_model(MODEL_SAVE_PATH, nlp, examples)


# ------------------- VALIDATE TRAINER -------------------
evaluate_model(nlp, converted_data)
# validate_entities(converted_data, nlp)

# ------------------- TEST EXAMPLES -------------------
# def convert_example_to_biluo(text):
#     """Convert model predictions for the given text to BILUO format."""
#     doc = nlp(text)

#     iob_tags = [
#         token.ent_iob_ + "-" + token.ent_type_ if token.ent_type_ else "O"
#         for token in doc
#     ]
#     biluo_tags = iob_to_biluo(iob_tags)

#     return doc, biluo_tags


# def inspect_company_predictions(text):
#     """Inspect model predictions for companies text."""
#     doc, biluo_tags = convert_example_to_biluo(text)

#     print("\nOriginal Text:")
#     print(f"'{text}'\n")
#     print("Token Predictions:")
#     print(f"{'Token':<15}{'Predicted Label':<20}{'BILUO Tag':<20}")
#     print("-" * 50)

#     for token, biluo_tag in zip(doc, biluo_tags):
#         predicted_label = token.ent_type_ if token.ent_type_ else "O"
#         print(f"{token.text:<15}{predicted_label:<20}{biluo_tag:<20}")


# test_texts = [

# ]

# for text in test_texts:
#     inspect_company_predictions(text)
