# app/python/ai_processing/salary_extraction/train_salary_extraction.py

import base64
import warnings
import spacy
import os
import json
import sys
from spacy.training import iob_to_biluo
from app.python.ai_processing.utils.label_mapping import get_label_list
from app.python.ai_processing.utils.data_handler import load_data, load_spacy_model
from app.python.ai_processing.utils.logger import (
    GREEN,
    RED,
    RESET,
    configure_logging,
    configure_warnings,
)
from app.python.ai_processing.utils.spacy_utils import handle_spacy_data
from app.python.ai_processing.utils.trainer import train_spacy_model
from app.python.ai_processing.utils.utils import (
    calculate_entity_indices,
    print_data_with_entities,
)
from app.python.ai_processing.utils.validation_utils import (
    evaluate_model,
    validate_entities,
)
from app.python.ai_processing.utils.data_handler import project_root

configure_warnings()
configure_logging()

FOLDER = "salary"
BASE_DIR = os.path.join(project_root, FOLDER)

CONVERTED_FILE = "train_data_spacy.json"
CONVERTED_FILE_PATH = os.path.join(BASE_DIR, "data", CONVERTED_FILE)
SALARY_MODEL_SAVE_PATH = os.path.join(BASE_DIR, "model", "spacy_salary_ner_model")
SPACY_DATA_PATH = os.path.join(BASE_DIR, "data", "train.spacy")

# TRAIN_DATA_FILE = "train_data.json"
# train_data = load_data(TRAIN_DATA_FILE, FOLDER)
# updated_data = calculate_entity_indices(train_data)
# print_data_with_entities(updated_data)

salary_converted_data = load_data(CONVERTED_FILE, FOLDER)
salary_nlp = load_spacy_model(SALARY_MODEL_SAVE_PATH)

salary_examples = []

if "ner" not in salary_nlp.pipe_names:
    ner = salary_nlp.add_pipe("ner")
    print(f"{RED}Added NER pipe to blank model: {salary_nlp.pipe_names}{RESET}")

    for label in get_label_list(entity_type="salary"):
        ner.add_label(label)

    spacy.tokens.Doc.set_extension("index", default=None, force=True)
    doc_bin, examples = handle_spacy_data(
        SPACY_DATA_PATH, CONVERTED_FILE, FOLDER, salary_nlp
    )

    salary_examples = examples

    salary_nlp.initialize(get_examples=lambda: examples)

    os.makedirs(SALARY_MODEL_SAVE_PATH, exist_ok=True)
    salary_nlp.to_disk(SALARY_MODEL_SAVE_PATH)
    print(
        f"{GREEN}Model saved to {SALARY_MODEL_SAVE_PATH} with NER component added.{RESET}"
    )
else:
    ner = salary_nlp.get_pipe("ner")
    print(
        f"{GREEN}NER pipe already exists in blank model: {salary_nlp.pipe_names}{RESET}"
    )

    doc_bin, examples = handle_spacy_data(
        SPACY_DATA_PATH, CONVERTED_FILE, FOLDER, salary_nlp
    )

    salary_examples = examples

# if examples:
#     for example in examples:
#         print(f"\nText: '{example.reference.text}'")
#         print("Entities after initialization:")
#         for ent in example.reference.ents:
#             print(
#                 f"  - Text: '{ent.text}', Start: {ent.start_char}, End: {ent.end_char}, Label: {ent.label_}"
#             )

# ------------------- TRAIN MODEL -------------------
# train_spacy_model(SALARY_MODEL_SAVE_PATH, salary_nlp, examples, resume=True)


# ------------------- VALIDATE TRAINER -------------------
# evaluate_model(salary_nlp, converted_data)
# validate_entities(converted_data, salary_nlp)


# ------------------- TEST EXAMPLES -------------------
# def convert_example_to_biluo(text):
#     """Convert model predictions for the given text to BILUO format."""
#     doc = salary_nlp(text)

#     iob_tags = [
#         token.ent_iob_ + "-" + token.ent_type_ if token.ent_type_ else "O"
#         for token in doc
#     ]
#     biluo_tags = iob_to_biluo(iob_tags)

#     return doc, biluo_tags


# def inspect_salary_model_predictions(text):
#     """Inspect model predictions for the given text."""
#     doc, biluo_tags = convert_example_to_biluo(text)

#     entity_data = {}
#     current_entity = None
#     current_tokens = []

#     for token, biluo_tag in zip(doc, biluo_tags):
#         if biluo_tag != "O":
#             entity_label = biluo_tag.split("-")[-1]
#             # print(f"Token: {token.text}, Predicted Label: {entity_label}, BILUO Tag: {biluo_tag}", file=sys.stderr)

#             if biluo_tag.startswith("B-"):
#                 if current_entity:
#                     if current_entity not in entity_data:
#                         entity_data[current_entity] = []
#                     entity_data[current_entity].append(" ".join(current_tokens))

#                 current_entity = entity_label
#                 current_tokens = [token.text]

#             elif biluo_tag.startswith("I-"):
#                 current_tokens.append(token.text)

#             elif biluo_tag.startswith("L-"):
#                 current_tokens.append(token.text)
#                 if current_entity:
#                     if current_entity not in entity_data:
#                         entity_data[current_entity] = []
#                     entity_data[current_entity].append(" ".join(current_tokens))
#                 current_entity = None
#                 current_tokens = []

#             elif biluo_tag.startswith("U-"):
#                 if entity_label not in entity_data:
#                     entity_data[entity_label] = []
#                 entity_data[entity_label].append(token.text)
#         else:
#             if current_entity:
#                 if current_entity not in entity_data:
#                     entity_data[current_entity] = []
#                 entity_data[current_entity].append(" ".join(current_tokens))
#                 current_entity = None
#                 current_tokens = []

#     if current_entity:
#         if current_entity not in entity_data:
#             entity_data[current_entity] = []
#         entity_data[current_entity].append(" ".join(current_tokens))

#     return entity_data


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
#     inspect_salary_model_predictions(text)
