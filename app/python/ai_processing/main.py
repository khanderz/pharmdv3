#  app/python/ai_processing/main.py

import base64
import json
import sys
import warnings
import threading
import logging
import spacy
from app.python.ai_processing.utils.logger import BLUE, RESET
from app.python.ai_processing.utils.trainer import train_spacy_model
from app.python.ai_processing.utils.utils import (
    calculate_entity_indices,
    print_data_with_entities,
)
from app.python.ai_processing.utils.validation_utils import validate_entities
from spacy.training import iob_to_biluo
from transformers import LongformerTokenizer

tokenizer = LongformerTokenizer.from_pretrained("allenai/longformer-base-4096")
MAX_SEQ_LENGTH = 4096

# logging.basicConfig(
#     filename="training.log",
#     filemode="a",
#     level=logging.INFO,
#     format="%(asctime)s - %(levelname)s - %(message)s",
# )

# logging.info("Logging setup completed. Testing log output.")

class DualLoggingHandler(logging.Handler):
    def __init__(self, file_handler, stdout_handler):
        super().__init__()
        self.file_handler = file_handler
        self.stdout_handler = stdout_handler

    def emit(self, record):
        log_entry = self.format(record)
        self.file_handler.emit(record)
        if record.levelno != logging.INFO or not log_entry.startswith("{"):
            self.stdout_handler.emit(record)

file_handler = logging.FileHandler("training.log")
file_handler.setFormatter(logging.Formatter("%(asctime)s - %(levelname)s - %(message)s"))

stdout_handler = logging.StreamHandler(sys.stdout)
stdout_handler.setFormatter(logging.Formatter("%(message)s"))

logger = logging.getLogger()
logger.setLevel(logging.INFO)  
logger.handlers = []  
logger.addHandler(DualLoggingHandler(file_handler, stdout_handler))

logging.info("Logging setup completed. Starting script.")


def return_paths(attribute_type):
    if attribute_type == "job_qualifications":
        from app.python.ai_processing.job_qualifications.train_job_qualifications import (
            qualifications_nlp,
            QUALIFICATIONS_MODEL_SAVE_PATH,
            qualification_examples,
        )
        return (
            qualifications_nlp,
            QUALIFICATIONS_MODEL_SAVE_PATH,
            qualification_examples,
        )
    elif attribute_type == "job_description":
        from app.python.ai_processing.job_description.train_job_description import (
            description_nlp,
            DESCRIPTION_MODEL_SAVE_PATH,
            description_examples,
        )
        return (
            description_nlp,
            DESCRIPTION_MODEL_SAVE_PATH,
            description_examples,
        )
    elif attribute_type == "job_responsibilities":
        from app.python.ai_processing.job_responsibilities.train_responsibilities import (
            responsibilities_nlp,
            RESPONSIBILITIES_MODEL_SAVE_PATH,
            responsibilities_examples,
        )
        return (
            responsibilities_nlp,
            RESPONSIBILITIES_MODEL_SAVE_PATH,
            responsibilities_examples,
        )
    elif attribute_type == "job_benefits":
        from app.python.ai_processing.job_benefits.train_job_benefits import (
            benefits_nlp,
            BENEFITS_MODEL_SAVE_PATH,
            benefits_examples,
        )
        return (
            benefits_nlp,
            BENEFITS_MODEL_SAVE_PATH,
            benefits_examples,
        )
    elif attribute_type == "salary":
        from app.python.ai_processing.salary.train_salary import (
            salary_nlp,
            SALARY_MODEL_SAVE_PATH,
            salary_examples,
        )
        return (
            salary_nlp,
            SALARY_MODEL_SAVE_PATH,
            salary_examples,
        )
    else:
        raise ValueError("Invalid attribute type provided.")

def convert_example_to_biluo(text, nlp, attribute_type):
    """Convert model predictions for the given text to BILUO format."""
    # print(f" attribute_type: {attribute_type}", file=sys.stderr)
    if attribute_type != "salary":
        tokens = tokenizer(
            text,
            max_length=MAX_SEQ_LENGTH,
            truncation=True,
            padding="max_length",
            return_tensors="pt",
        )

        decoded_text = tokenizer.decode(
            tokens["input_ids"][0], skip_special_tokens=True
        )

        doc = nlp(decoded_text)

        iob_tags = [
            token.ent_iob_ + "-" + token.ent_type_ if token.ent_type_ else "O"
            for token in doc
        ]
        biluo_tags = iob_to_biluo(iob_tags)
    else:
        doc = nlp(text)

        iob_tags = [
            token.ent_iob_ + "-" + token.ent_type_ if token.ent_type_ else "O"
            for token in doc
        ]
        biluo_tags = iob_to_biluo(iob_tags)

    return doc, biluo_tags


def inspect_job_post_predictions(text, nlp, attribute_type):
    """Inspect model predictions for job post text."""
    doc, biluo_tags = convert_example_to_biluo(text, nlp, attribute_type)

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

            elif biluo_tag.startswith("U-"):
                if entity_label not in entity_data:
                    entity_data[entity_label] = []
                entity_data[entity_label].append(token.text)
        else:
            if current_entity:
                if current_entity not in entity_data:
                    entity_data[current_entity] = []
                entity_data[current_entity].append(" ".join(current_tokens))
                current_entity = None
                current_tokens = []

    if current_entity:
        if current_entity not in entity_data:
            entity_data[current_entity] = []
        entity_data[current_entity].append(" ".join(current_tokens))

    return entity_data


def train_model_in_thread(MODEL_SAVE_PATH, nlp, examples):
    try:
        # print("\nTraining model in the background...")
        logging.info("Training model in the background...")

        train_spacy_model(MODEL_SAVE_PATH, nlp, examples, resume=True)
        logging.info("Training model completed successfully.")
    except Exception as e:
        logging.error(f"Training failed: {e}")


def main(
    encoded_data,
    train_flag,
    predict_flag,
    nlp,
    MODEL_SAVE_PATH,
    examples,
    attribute_type,
    validate_data=None,
    data=None,
):
    if data:
        # print(
        #     f"{BLUE}Calculating entity indices for the provided data...{RESET}",
        #     file=sys.stderr,
        # )
        if isinstance(data, str):
            data = json.loads(data)

        updated_data = calculate_entity_indices([data])
        print_data_with_entities(updated_data, file=sys.stdout)
        return

    if validate_data not in [None, "None", "", "null"]:
        # print(
        #     f"{BLUE}Validating entities of the converted data only...{RESET}",
        #     file=sys.stderr,
        # )

        decoded = json.loads(base64.b64decode(validate_data).decode("utf-8"))
        validation_result = validate_entities(decoded, nlp, file=sys.stdout)

        if validation_result["status"] == "success":
            result = {
                "status": "success",
                "message": "Validation passed for all entities",
            }
        else:
            result = {
                "status": "failure",
                "message": validation_result["message"],
            }

        sys.stdout.write(json.dumps(result) + "\n")
        return

    if train_flag == "true":
        # print(
        #     f"{BLUE}Isolating process to train the main extraction model...{RESET}",
        #     file=sys.stderr,
        # )
        logging.info(f"Training model started for {attribute_type}...")
        training_thread = threading.Thread(
            target=train_model_in_thread, args=(MODEL_SAVE_PATH, nlp, examples)
        )
        training_thread.start()
        return

    if predict_flag:
        input_data = json.loads(base64.b64decode(encoded_data).decode("utf-8"))
        text = input_data.get("text", "")

        print(f"{BLUE}Running job post main predictions...{RESET}", file=sys.stderr)
        predictions = inspect_job_post_predictions(text, nlp, attribute_type)
        output = {
            "status": "success",
            "entities": predictions if predictions else [],
        }


        sys.stdout.write(json.dumps(output) + "\n")


if __name__ == "__main__":
    warnings.filterwarnings("ignore")
    # print(
    #     f"{BLUE}Running job post main extraction model inspection script...{RESET}",
    #     file=sys.stderr,
    # )
    try:
        attribute_type = sys.argv[1]
        encoded_data = sys.argv[2]
        validate_data = sys.argv[3] if len(sys.argv) > 3 else None
        predict_flag = sys.argv[4].lower() == "true" if len(sys.argv) > 4 else False
        train_flag = sys.argv[5].lower() == "true" if len(sys.argv) > 5 else False
        data = sys.argv[6] if len(sys.argv) > 6 else None

        (
            nlp,
            MODEL_SAVE_PATH,
            examples,
        ) = return_paths(attribute_type)
        # print(f"attribiute_type: {attribute_type}", file=sys.stderr)
        # print(f"encoded_data: {encoded_data}", file=sys.stderr)

        # print(f"train_flag: {train_flag}", file=sys.stderr)
        # print(f"data: {data}", file=sys.stderr)
        # print(f"predict_flag: {predict_flag}", file=sys.stderr)
        main(
            encoded_data,
            train_flag,
            predict_flag,
            nlp,
            MODEL_SAVE_PATH,
            examples,
            attribute_type,
            validate_data,
            data,
        )
    except Exception as e:
        error_response = {"status": "error", "message": str(e)}
        print(json.dumps(error_response))  
        logging.error(f"Error in main script: {e}")
        sys.exit(1)
