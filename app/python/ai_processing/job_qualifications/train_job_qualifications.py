#  app/python/ai_processing/job_qualifications/train_job_qualifications.py.py

import base64
import json
import os
import sys
import warnings
import spacy
from spacy.training import iob_to_biluo
from app.python.ai_processing.utils.description_splitter import recursive_html_decode
from app.python.ai_processing.utils.label_mapping import get_label_list
from app.python.ai_processing.utils.logger import (
    GREEN,
    RED,
    RESET,
    configure_logging,
    configure_warnings,
)
from app.python.ai_processing.utils.data_handler import (
    load_data,
    load_spacy_model,
    project_root,
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
from transformers import LongformerTokenizer, LongformerModel

configure_warnings()
configure_logging()

FOLDER = "job_qualifications"
BASE_DIR = os.path.join(project_root, FOLDER)

CONVERTED_FILE = "train_data_spacy.json"
CONVERTED_FILE_PATH = os.path.join(BASE_DIR, "data", CONVERTED_FILE)
QUALIFICATIONS_MODEL_SAVE_PATH = os.path.join(
    BASE_DIR, "model", "spacy_job_qualification_ner_model"
)
SPACY_DATA_PATH = os.path.join(BASE_DIR, "data", "train.spacy")

tokenizer = LongformerTokenizer.from_pretrained("allenai/longformer-base-4096")
transformer = LongformerModel.from_pretrained("allenai/longformer-base-4096")

MAX_SEQ_LENGTH = 4096

qualifications_converted_data = load_data(CONVERTED_FILE, FOLDER)
qualifications_nlp = load_spacy_model(
    QUALIFICATIONS_MODEL_SAVE_PATH,
    MAX_SEQ_LENGTH,
    model_name="allenai/longformer-base-4096",
)

qualification_examples = []

if "ner" not in qualifications_nlp.pipe_names:
    ner = qualifications_nlp.add_pipe("ner")
    print(f"{RED}Added NER pipe to blank model: {qualifications_nlp.pipe_names}{RESET}")

    for label in get_label_list(entity_type="job_qualifications"):
        ner.add_label(label)

    spacy.tokens.Doc.set_extension("index", default=None, force=True)
    doc_bin, examples = handle_spacy_data(
        SPACY_DATA_PATH,
        CONVERTED_FILE,
        FOLDER,
        qualifications_nlp,
        tokenizer,
        MAX_SEQ_LENGTH,
        transformer,
    )
    qualification_examples = examples

    qualifications_nlp.initialize(get_examples=lambda: examples)

    os.makedirs(QUALIFICATIONS_MODEL_SAVE_PATH, exist_ok=True)
    qualifications_nlp.to_disk(QUALIFICATIONS_MODEL_SAVE_PATH)
    print(
        f"{GREEN}Model saved to {QUALIFICATIONS_MODEL_SAVE_PATH} with NER component added.{RESET}"
    )
else:
    ner = qualifications_nlp.get_pipe("ner")
    # print(
    #     f"{GREEN}NER pipe already exists in blank model: {qualifications_nlp.pipe_names}{RESET}"
    # )

    doc_bin, examples = handle_spacy_data(
        SPACY_DATA_PATH,
        CONVERTED_FILE,
        FOLDER,
        qualifications_nlp,
        tokenizer,
        MAX_SEQ_LENGTH,
        transformer,
    )

    qualification_examples = examples

# ------------------- TRAIN MODEL -------------------
# train_spacy_model(QUALIFICATIONS_MODEL_SAVE_PATH, qualifications_nlp, examples, resume=True)

# ------------------- VALIDATE TRAINER -------------------
# evaluate_model(qualifications_nlp, converted_data)
# validate_entities(converted_data, qualifications_nlp)


# ------------------- TEST EXAMPLES -------------------
# def convert_example_to_biluo(text):
#     """Convert model predictions for the given text to BILUO format."""
#     tokens = tokenizer(
#         text,
#         max_length=MAX_SEQ_LENGTH,
#         truncation=True,
#         padding="max_length",
#         return_tensors="pt",
#     )

#     decoded_text = tokenizer.decode(tokens["input_ids"][0], skip_special_tokens=True)

#     doc = qualifications_nlp(decoded_text)

#     iob_tags = [
#         token.ent_iob_ + "-" + token.ent_type_ if token.ent_type_ else "O"
#         for token in doc
#     ]
#     biluo_tags = iob_to_biluo(iob_tags)

#     return doc, biluo_tags


# def inspect_job_qualification_predictions(text):
#     """Inspect model predictions for job qualification text."""
#     doc, biluo_tags = convert_example_to_biluo(text)

#     entity_data = {}
#     current_entity = None
#     current_tokens = []

#     for token, biluo_tag in zip(doc, biluo_tags):
#         if biluo_tag != "O":
#             entity_label = biluo_tag.split("-")[-1]

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

# def main(encoded_data, validate_flag, data=None):
#     if data:
#         if isinstance(data, str):
#             data = json.loads(data)

#         updated_data = calculate_entity_indices([data])
#         print_data_with_entities(updated_data, file=sys.stderr)
#         return

#     if validate_flag:
#         print("\nValidating entities of the converted data only...", file=sys.stderr)
#         result = validate_entities(converted_data, qualifications_nlp)
#         if result == "Validation passed for all entities.":

#             result = {
#                 "status": "success",
#                 "message": "Validation passed for all entities",
#             }
#         sys.stdout.write(json.dumps(result) + "\n")

#         return

#     input_data = json.loads(base64.b64decode(encoded_data).decode("utf-8"))
#     text = input_data.get("text", "")
#     print(f"\nText: {text}", file=sys.stderr)

#     print("\nRunning qualifications extraction model inspection...", file=sys.stderr)
#     predictions = inspect_job_qualification_predictions(text)

#     output = {
#         "status": "success" if predictions else "failure",
#         "entities": predictions,
#     }

#     sys.stdout.write(json.dumps(output) + "\n")


# if __name__ == "__main__":
#     warnings.filterwarnings("ignore")
#     print(
#         "\nRunning job qualifications extraction model inspection script...", file=sys.stderr
#     )
#     try:
#         encoded_data = sys.argv[1]
#         validate_flag = sys.argv[2].lower() == "true" if len(sys.argv) > 2 else False
#         data = sys.argv[3] if len(sys.argv) > 3 else None

#         main(encoded_data, validate_flag, data)
#     except Exception as e:
#         error_response = {"status": "error", "message": str(e)}
#         sys.stdout.write(json.dumps(error_response) + "\n")
#         sys.exit(1)
