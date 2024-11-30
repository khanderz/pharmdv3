#  app/python/ai_processing/utils/validation_utils.py
from app.python.ai_processing.utils.logger import BLUE, RED, GREEN, RESET
from app.python.ai_processing.utils.utils import print_token_characters
from spacy.scorer import Scorer
from spacy.training import Example


def print_tokenization(doc):
    print("\nTokenization Debugging:")
    for token in doc:
        print(
            f"Token: '{token.text}', Start: {token.idx}, End: {token.idx + len(token.text)}"
        )


def verify_data_consistency(validation_data):
    for entry in validation_data:
        # print(f"entry : {entry}")
        text = entry["text"]
        for entity in entry["entities"]:
            start = entity["start"]
            end = entity["end"]

            if "token" not in entity:
                print(
                    f"Warning: Missing 'token' key in entity {entity}. Skipping consistency check for this entity."
                )
                continue

            assert (
                text[start:end] == entity["token"]
            ), f"{RED}{print_token_characters(text)}{RESET}"


def validate_entities(data, nlp):
    fails = []

    for idx, item in enumerate(data):
        doc = nlp(item["text"])

        for entity in item["entities"]:
            start, end, label, expected_token = (
                entity["start"],
                entity["end"],
                entity["label"],
                entity["token"],
            )
            spacy_token = doc.char_span(start, end)

            if spacy_token is None or expected_token != spacy_token.text:
                fails.append(entity)
                print(
                    f"Mismatch found in object {idx + 1}:\n"
                    f"  Label: {label}\n"
                    f"  Expected: '{expected_token}' got: (start={start}, end={end})\n"
                    f"  Actual: '{spacy_token.text if spacy_token else None}'\n"
                )
    if fails:
        # print(f"{BLUE}failed entities: {fails}{RESET}")
        print(f"{RED}Validation failed for {len(fails)} entities.{RESET}")
    else:
        print(f"{GREEN}Validation passed for all entities.{RESET}")


def fuzzy_match(true_entities, pred_entities, tolerance=1):
    matched = []
    print(f"True Entities: {true_entities}")
    print(f"Predicted Entities: {pred_entities}")
    for start, end, label in pred_entities:
        for entity in true_entities:
            t_start = entity["start"]
            t_end = entity["end"]
            t_label = entity["label"]

            if (
                label == t_label
                and abs(start - t_start) <= tolerance
                and abs(end - t_end) <= tolerance
            ):
                matched.append((start, end, label))
                break
    return matched


def evaluate_model(nlp, validation_data):
    """Evaluate the model on the validation dataset and print metrics."""
    scorer = Scorer()
    examples = []

    for entry in validation_data:
        example = Example.from_dict(
            nlp.make_doc(entry["text"]),
            {
                "entities": [
                    (ent["start"], ent["end"], ent["label"])
                    for ent in entry["entities"]
                ]
            },
        )

        nlp_pred = nlp(example.reference.text)
        example.predicted = nlp_pred
        examples.append(example)

        # print(f"\nText: {entry['text']}")
        # print("Ground Truth:", [(ent["start"], ent["end"], ent["label"]) for ent in entry["entities"]])
        # print("Predictions:", [(ent.start_char, ent.end_char, ent.label_) for ent in nlp_pred.ents])

    results = scorer.score(examples)

    print("Entity Precision: {:.2f}%".format(results["ents_p"] * 100))
    print("Entity Recall: {:.2f}%".format(results["ents_r"] * 100))
    print("Entity F1-score: {:.2f}%".format(results["ents_f"] * 100))
    return results


def print_label_token_pairs(data):
    """Prints label and associated token for each entity in the data."""
    print(f"{'Label':<15} {'Token'}")
    print("-" * 30)
    # print(f"data : {data}")
    for entry in data:
        # print(f"entry : {entry}")
        text = entry["text"]
        for entity in entry["entities"]:
            label = entity["label"]
            token = text[entity["start"] : entity["end"]]
            print(f"{label:<15} {token}")


# ------------------- IDENTIFY INCORRECT ENTITIES IN TRAIN_DATA_SPACY.JSON -------------------
def validate_ner_data(data):
    """
    Validate the consistency of keys in a Named Entity Recognition (NER) dataset.

    Args:
        data (list): A list of NER examples, each containing a 'text' key and an 'entities' key.

    Returns:
        dict: A dictionary with the validation results, including errors and overall status.
    """
    required_keys = {"start", "end", "label", "token"}
    errors = []

    for i, example in enumerate(data):
        if "text" not in example or "entities" not in example:
            errors.append(
                {
                    "example_index": i,
                    "error": "Missing 'text' or 'entities' key in example.",
                }
            )
            continue

        for j, entity in enumerate(example["entities"]):
            missing_keys = required_keys - entity.keys()
            if missing_keys:
                errors.append(
                    {
                        "example_index": i,
                        "entity_index": j,
                        "missing_keys": list(missing_keys),
                    }
                )

    return {"is_valid": not errors, "errors": errors}


def find_problematic_entry(data, example_index, entity_index):
    """
    Locate and return the problematic example and entity in the dataset.

    Args:
        data (list): The dataset to search through.
        example_index (int): The index of the problematic example.
        entity_index (int): The index of the problematic entity within the example.

    Returns:
        dict: The problematic example and entity, if found.
    """
    try:
        example = data[example_index]
        entity = example["entities"][entity_index]
        return {"example": example, "entity": entity}
    except IndexError:
        return {"error": "Index out of bounds. Please check the indices and dataset."}


#  ------------------EXAMPLE USAGE------------------
# if not error["is_valid"]:
#     for error in error["errors"]:
#         if "example_index" in error and "entity_index" in error:
#             example_index = error["example_index"]
#             entity_index = error["entity_index"]

#             problematic_entry = find_problematic_entry(converted_data, example_index, entity_index)
#             print(f"Problematic Entry:\n{problematic_entry}")
#         else:
#             print(f"Error: {error}")
# else:
#     print("No validation errors found!")
