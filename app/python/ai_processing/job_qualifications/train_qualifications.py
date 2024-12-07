#  app/python/ai_processing/job_qualifications/train_qualifications.py

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
from app.python.ai_processing.utils.validation_utils import evaluate_model
from transformers import LongformerTokenizer, LongformerModel

configure_warnings()
configure_logging()

FOLDER = "job_qualifications"
BASE_DIR = os.path.join(project_root, FOLDER)

CONVERTED_FILE = "train_data_spacy.json"
CONVERTED_FILE_PATH = os.path.join(BASE_DIR, "data", CONVERTED_FILE)
MODEL_SAVE_PATH = os.path.join(BASE_DIR, "model", "spacy_job_qualification_ner_model")
SPACY_DATA_PATH = os.path.join(BASE_DIR, "data", "train.spacy")

tokenizer = LongformerTokenizer.from_pretrained("allenai/longformer-base-4096")
transformer = LongformerModel.from_pretrained("allenai/longformer-base-4096")

MAX_SEQ_LENGTH = 4096

converted_data = load_data(CONVERTED_FILE, FOLDER)
nlp = load_spacy_model(
    MODEL_SAVE_PATH, MAX_SEQ_LENGTH, model_name="allenai/longformer-base-4096"
)

if "ner" not in nlp.pipe_names:
    ner = nlp.add_pipe("ner")
    print(f"{RED}Added NER pipe to blank model: {nlp.pipe_names}{RESET}")

    for label in get_label_list(entity_type="job_qualification"):
        ner.add_label(label)

    spacy.tokens.Doc.set_extension("index", default=None, force=True)
    doc_bin, examples = handle_spacy_data(
        SPACY_DATA_PATH,
        CONVERTED_FILE,
        FOLDER,
        nlp,
        tokenizer,
        MAX_SEQ_LENGTH,
        transformer,
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
        tokenizer,
        MAX_SEQ_LENGTH,
        transformer,
    )

# ------------------- TRAIN MODEL -------------------
# train_spacy_model(MODEL_SAVE_PATH, nlp, examples, resume=True)

# ------------------- VALIDATE TRAINER -------------------
# evaluate_model(nlp, converted_data)
# validate_entities(converted_data, nlp)


# ------------------- TEST EXAMPLES -------------------
def convert_example_to_biluo(text):
    """Convert model predictions for the given text to BILUO format."""
    tokens = tokenizer(
        text,
        max_length=MAX_SEQ_LENGTH,
        truncation=True,
        padding="max_length",
        return_tensors="pt",
    )

    decoded_text = tokenizer.decode(tokens["input_ids"][0], skip_special_tokens=True)

    doc = nlp(decoded_text)

    iob_tags = [
        token.ent_iob_ + "-" + token.ent_type_ if token.ent_type_ else "O"
        for token in doc
    ]
    biluo_tags = iob_to_biluo(iob_tags)

    return doc, biluo_tags


def inspect_job_qualification_predictions(text):
    """Inspect model predictions for job qualification text."""

    doc, biluo_tags = convert_example_to_biluo(text)

    print("Token Predictions:")
    print(f"{'Token':<15}{'Predicted Label':<20}{'BILUO Tag':<20}")
    print("-" * 50)

    entity_data = {}
    current_entity = None
    current_tokens = []

    for token, biluo_tag in zip(doc, biluo_tags):
        if biluo_tag != "O":
            entity_label = biluo_tag.split("-")[-1]

            if biluo_tag.startswith("B-"):
                if current_entity:
                    if current_entity not in entity_data:
                        entity_data[current_entity] = []
                    entity_data[current_entity].append(" ".join(current_tokens))

                current_entity = entity_label
                current_tokens = [token.text]

            elif biluo_tag.startswith("I-"):
                current_tokens.append(token.text)

            elif biluo_tag.startswith("L-"):
                current_tokens.append(token.text)
                if current_entity:
                    if current_entity not in entity_data:
                        entity_data[current_entity] = []
                    entity_data[current_entity].append(" ".join(current_tokens))
                current_entity = None
                current_tokens = []
        else:
            if current_entity:
                if current_entity not in entity_data:
                    entity_data[current_entity] = []
                entity_data[current_entity].append(" ".join(current_tokens))
                current_entity = None
                current_tokens = []

        print(
            f"{token.text:<15}{token.ent_type_ if token.ent_type_ else 'O':<20}{biluo_tag:<20}"
        )
    if current_entity:
        if current_entity not in entity_data:
            entity_data[current_entity] = []
        entity_data[current_entity].append(" ".join(current_tokens))

    return entity_data

if __name__ == "__main__":
    warnings.filterwarnings("ignore")
    print("\nRunning job qualifications extraction model inspection script...", file=sys.stderr)
    try:
        encoded_input = sys.argv[1]
        input_data = json.loads(base64.b64decode(encoded_input).decode("utf-8"))
        text = input_data.get("text", "")


        entity_data = inspect_job_qualification_predictions(text)

        output = {
            "status": "success" if entity_data else "failure",
            "entities": entity_data,
        }

        print(json.dumps(output))
    except Exception as e:
        error_response = {"status": "error", "message": str(e)}
        print(json.dumps(error_response))
        sys.exit(1)