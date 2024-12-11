#  app/python/ai_processing/main.py

import base64
import json
import sys
import warnings
import spacy
from app.python.ai_processing.utils.trainer import train_spacy_model
from app.python.ai_processing.utils.utils import (
    calculate_entity_indices,
    print_data_with_entities,
)
from app.python.ai_processing.utils.validation_utils import validate_entities
from spacy.training import iob_to_biluo
from transformers import LongformerTokenizer
from app.python.ai_processing.job_qualifications.train_job_qualifications import (
    qualifications_nlp,
    QUALIFICATIONS_MODEL_SAVE_PATH,
    qualification_examples,
)
from app.python.ai_processing.job_description.train_job_description import (
    description_nlp,
    DESCRIPTION_MODEL_SAVE_PATH,
    description_examples,
)
from app.python.ai_processing.job_benefits.train_job_benefits import (
    benefits_nlp,
    BENEFITS_MODEL_SAVE_PATH,
    benefits_examples,
)
from app.python.ai_processing.salary.train_salary import (
    salary_nlp,
    SALARY_MODEL_SAVE_PATH,
    salary_examples,
)

tokenizer = LongformerTokenizer.from_pretrained("allenai/longformer-base-4096")
MAX_SEQ_LENGTH = 4096

def return_paths(attribute_type):
    if attribute_type == "job_qualifications":
        return (
            qualifications_nlp,
            QUALIFICATIONS_MODEL_SAVE_PATH,
            qualification_examples,
        )
    elif attribute_type == "job_description":
        return (
            description_nlp,
            DESCRIPTION_MODEL_SAVE_PATH,
            description_examples,
        )
    elif attribute_type == "job_benefits":
        return (
            benefits_nlp,
            BENEFITS_MODEL_SAVE_PATH,
            benefits_examples,
        )
    elif attribute_type == "salary":
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
    if attribute_type != 'salary':
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
    doc, biluo_tags = convert_example_to_biluo(
        text, nlp, attribute_type
    )

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


def main(
    encoded_data,
    train_flag,
    nlp,
    MODEL_SAVE_PATH,
    examples,
    attribute_type,
    validate_data=None,
    data=None,
):
    if data:
        print("\nCalculating entity indices for the provided data...", file=sys.stderr)
        if isinstance(data, str):
            data = json.loads(data)

        updated_data = calculate_entity_indices([data])
        print_data_with_entities(updated_data, file=sys.stdout)
        return

    if validate_data not in [None, "None", "", "null"]:
        print("\nValidating entities of the converted data only...", file=sys.stderr)
        # print(f"validate_data: {validate_data}", file=sys.stderr)
        result = validate_entities(validate_data, nlp)
        if result == "Validation passed for all entities.":

            result = {
                "status": "success",
                "message": "Validation passed for all entities",
            }
        sys.stdout.write(json.dumps(result) + "\n")

        return

    if train_flag == "true":
        print("\nTraining the main extraction model...", file=sys.stderr)
        train_spacy_model(MODEL_SAVE_PATH, nlp, examples, resume=True)
        return

    input_data = json.loads(base64.b64decode(encoded_data).decode("utf-8"))
    text = input_data.get("text", "")
    # print(f"\nText: {text}", file=sys.stderr)

    print("\nRunning job post main extraction model inspection...", file=sys.stderr)
    predictions = inspect_job_post_predictions(
        text, nlp, attribute_type
    )
    # print(f"\nPredictions: {predictions}", file=sys.stderr)

    output = {
        "status": "success" if predictions else "failure",
        "entities": predictions,
    }

    sys.stdout.write(json.dumps(output) + "\n")


if __name__ == "__main__":
    warnings.filterwarnings("ignore")
    print(
        "\nRunning job post main extraction model inspection script...", file=sys.stderr
    )
    try:
        attribute_type = sys.argv[1]
        encoded_data = sys.argv[2]
        validate_data = sys.argv[3] if len(sys.argv) > 3 else None
        train_flag = sys.argv[4].lower() == "true" if len(sys.argv) > 4 else False
        data = sys.argv[5] if len(sys.argv) > 5 else None

        (
            nlp,
            MODEL_SAVE_PATH,
            examples,
        ) = return_paths(attribute_type)
        # print(f"attribiute_type: {attribute_type}", file=sys.stderr)
        # print(f"encoded_data: {encoded_data}", file=sys.stderr)
        # print(f"validate_data after: {validate_data}", file=sys.stderr)
        # print(f"train_flag: {train_flag}", file=sys.stderr)
        # print(f"data: {data}", file=sys.stderr)
        main(
            encoded_data,
            train_flag,
            nlp,
            MODEL_SAVE_PATH,
            examples,
            attribute_type,
            validate_data,
            data,
        )
    except Exception as e:
        error_response = {"status": "error", "message": str(e)}
        sys.stdout.write(json.dumps(error_response) + "\n")
        sys.exit(1)
