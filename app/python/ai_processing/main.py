#  app/python/ai_processing/main.py

import base64
import json
import sys
import warnings
from app.python.ai_processing.utils.trainer import train_spacy_model
from app.python.ai_processing.utils.utils import calculate_entity_indices, print_data_with_entities
from app.python.ai_processing.utils.validation_utils import validate_entities
from spacy.training import iob_to_biluo
from transformers import LongformerTokenizer, LongformerModel
from app.python.ai_processing.job_qualifications.train_job_qualifications  import qualifications_converted_data, qualifications_nlp, QUALIFICATIONS_MODEL_SAVE_PATH, qualification_examples
from app.python.ai_processing.job_description_extraction.train_job_description_extraction import description_converted_data, description_nlp, DESCRIPTION_MODEL_SAVE_PATH, description_examples
from app.python.ai_processing.job_benefits.train_job_benefits import benefits_converted_data, benefits_nlp, BENEFITS_MODEL_SAVE_PATH, benefits_examples
from app.python.ai_processing.salary_extraction.train_salary_extraction import salary_converted_data, salary_nlp, SALARY_MODEL_SAVE_PATH, salary_examples

def return_paths(attribute_type):
    if attribute_type == "job_qualifications":
        tokenizer = LongformerTokenizer.from_pretrained("allenai/longformer-base-4096")
        transformer = LongformerModel.from_pretrained("allenai/longformer-base-4096")
        MAX_SEQ_LENGTH = 4096

        return qualifications_converted_data, qualifications_nlp, tokenizer, transformer, MAX_SEQ_LENGTH, QUALIFICATIONS_MODEL_SAVE_PATH, qualification_examples
    elif attribute_type == 'job_description':
        tokenizer = LongformerTokenizer.from_pretrained("allenai/longformer-base-4096")
        transformer = LongformerModel.from_pretrained("allenai/longformer-base-4096")
        MAX_SEQ_LENGTH = 4096

        return description_converted_data, description_nlp, tokenizer, transformer, MAX_SEQ_LENGTH, DESCRIPTION_MODEL_SAVE_PATH, description_examples
    elif attribute_type == 'job_benefits':
        tokenizer = LongformerTokenizer.from_pretrained("allenai/longformer-base-4096")
        transformer = LongformerModel.from_pretrained("allenai/longformer-base-4096")

        MAX_SEQ_LENGTH = 4096
        return benefits_converted_data, benefits_nlp, tokenizer, transformer, MAX_SEQ_LENGTH, BENEFITS_MODEL_SAVE_PATH, benefits_examples
    elif attribute_type == 'salary':
        return salary_converted_data, salary_nlp, None, None, None, SALARY_MODEL_SAVE_PATH, salary_examples
    else:
        raise ValueError("Invalid attribute type provided.")
    
def convert_example_to_biluo(text, nlp, tokenizer, transformer, MAX_SEQ_LENGTH):
    """Convert model predictions for the given text to BILUO format."""
    if tokenizer and transformer and MAX_SEQ_LENGTH:
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
    else:
        doc = nlp(text)

        iob_tags = [
            token.ent_iob_ + "-" + token.ent_type_ if token.ent_type_ else "O"
            for token in doc
        ]
        biluo_tags = iob_to_biluo(iob_tags)

    return doc, biluo_tags


def inspect_job_post_predictions(text, nlp, tokenizer, transformer, MAX_SEQ_LENGTH):
    """Inspect model predictions for job post text."""
    doc, biluo_tags = convert_example_to_biluo(text, nlp, tokenizer, transformer, MAX_SEQ_LENGTH)

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

def main(encoded_data, validate_flag, train_flag, converted_data, nlp, tokenizer, transformer, MAX_SEQ_LENGTH, MODEL_SAVE_PATH, examples, data=None):
    if data:
        if isinstance(data, str):
            data = json.loads(data)

        updated_data = calculate_entity_indices([data])
        print_data_with_entities(updated_data, file=sys.stderr)
        return

    if validate_flag:
        print("\nValidating entities of the converted data only...", file=sys.stderr)
        result = validate_entities(converted_data, nlp)
        if result == "Validation passed for all entities.":

            result = {
                "status": "success",
                "message": "Validation passed for all entities",
            }
        sys.stdout.write(json.dumps(result) + "\n")

        return
    
    if train_flag:
        train_spacy_model(MODEL_SAVE_PATH, nlp, examples, resume=True)
        return

    input_data = json.loads(base64.b64decode(encoded_data).decode("utf-8"))
    text = input_data.get("text", "")
    print(f"\nText: {text}", file=sys.stderr)

    print("\nRunning job post main extraction model inspection...", file=sys.stderr)
    predictions = inspect_job_post_predictions(text, nlp, tokenizer, transformer, MAX_SEQ_LENGTH)

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
        validate_flag = sys.argv[3].lower() == "true" if len(sys.argv) > 3 else False
        train_flag = sys.argv[4].lower() == "true" if len(sys.argv) > 4 else False
        data = sys.argv[5] if len(sys.argv) > 5 else None

        converted_data, nlp, tokenizer, transformer, MAX_SEQ_LENGTH, MODEL_SAVE_PATH, examples = return_paths(attribute_type)
        main(encoded_data, validate_flag, converted_data, nlp, tokenizer, transformer, MAX_SEQ_LENGTH, MODEL_SAVE_PATH, examples, data)
    except Exception as e:
        error_response = {"status": "error", "message": str(e)}
        sys.stdout.write(json.dumps(error_response) + "\n")
        sys.exit(1)
