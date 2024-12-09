# app/python/ai_processing/utils/utils.py
import re
import sys
import spacy
import html
from bs4 import BeautifulSoup


# Preprocess text to decode HTML entities
# ex: &lt;p&gt;&lt;strong&gt;What You&#39;ll Achieve (Performance Outcomes)&lt;/strong&gt;&lt;/p&gt;
# returns: <p><strong>What You'll Achieve (Performance Outcomes)</strong></p>
def preprocess_text(text):
    return html.unescape(text)


# Clean HTML tags from text
# ex: <p><strong>What You'll Achieve (Performance Outcomes)</strong></p>
# returns: What You'll Achieve (Performance Outcomes)
def clean_html_tags(html_text):
    soup = BeautifulSoup(html_text, "html.parser")
    return soup.get_text()


def preprocess_html_content(html_text):
    decoded_text = html.unescape(html_text)
    clean_text = clean_html_tags(decoded_text)
    return clean_text


def preprocess_training_data(data):
    for item in data:
        item["text"] = preprocess_html_content(item["text"])
    return data


def clean_text(text):
    """
    Cleans text by removing unnecessary whitespace and special characters.
    """
    return re.sub(r"\s+", " ", text).strip()


def print_token_characters(tokens):
    text = "".join(tokens)

    for idx, char in enumerate(text):
        print(f"{char} {idx}")


def print_side_by_side(arr1, arr2):
    max_len = max(len(arr1), len(arr2))

    for i in range(max_len):
        elem1 = arr1[i] if i < len(arr1) else ""
        elem2 = arr2[i] if i < len(arr2) else ""

        print(f"{elem1}\t{elem2}")


def add_space_to_tokens(tokens, labels, no_space_entities, punctuations):
    is_bio_format = all(
        label.startswith("B-") or label.startswith("I-") or label == "O"
        for label in labels
    )
    # print(f"tokens: {tokens}, labels: {labels}, is_bio_format: {is_bio_format}")
    all_tokens = []
    all_labels = []
    # print(f"is bio format: {is_bio_format}, labels : {labels}")

    for i, token in enumerate(tokens):
        all_tokens.append(token)
        all_labels.append(labels[i])

        # print(f" 1 Token: {token}, Label: {labels[i]}")

        if i < len(tokens) - 1:
            next_token, next_label = tokens[i + 1], labels[i + 1]
            current_label_type = (
                labels[i][2:] if is_bio_format and labels[i] != "O" else labels[i]
            )
            next_label_type = (
                next_label[2:] if is_bio_format and next_label != "O" else next_label
            )

            # print(f" 2 Token: {token} Next Token: {next_token}, Next Label: {next_label}, Current Label Type: {current_label_type}, Next Label Type: {next_label_type}")

            if re.match(r"^\$|\€|\£|\₹|\¥$", token) and re.match(
                r"^\d[\d,]*$", next_token
            ):
                # or token == '-':
                # print(f"3 Token: {token}, Next Token: {next_token}")
                continue

            if is_bio_format:
                if (
                    labels[i].startswith("B-")
                    and next_label.startswith("I-")
                    and current_label_type == next_label_type
                ):
                    # print(f"4 Token: {token}, Next Token: {next_token}")
                    if current_label_type not in no_space_entities:
                        all_tokens.append(" ")
                        all_labels.append("O")

                if (
                    next_label.startswith("I-")
                    and current_label_type == next_label_type
                ):
                    # print(f"5 Token: {token}, Next Token: {next_token}")
                    continue

                if token == "-":
                    # print(f"5a {RED} HYPHEN-- Token: {token}, Next Token: {next_token}, next label type: {next_label_type} {RESET}")
                    # if next_label_type in no_space_entities:
                    #     continue

                    all_tokens.append(" ")
                    all_labels.append("O")

                elif next_token not in punctuations:
                    # print(f"6 Token: {token}, Next Token: {next_token}")
                    all_tokens.append(" ")
                    all_labels.append("O")

            else:
                # print(f"6 Token: {token}, current_label_type: {current_label_type}, next_label_type: {next_label_type}")
                if current_label_type == next_label_type:
                    # print(f"7 Next Token: {next_token}")
                    if (
                        current_label_type not in no_space_entities
                        and token != ","
                        and next_token != ":"
                    ):
                        # print(f"8 Token: {token}, Next Token: {next_token}")
                        all_tokens.append(" ")
                        all_labels.append("O")

                elif next_token not in punctuations:
                    # print(f"9 Token: {token}, Next Token: {next_token}")
                    all_tokens.append(" ")
                    all_labels.append("O")
    # print(f"all_tokens: {all_tokens}, all_labels: {all_labels}")
    return all_tokens, all_labels


def calculate_entity_indices(data):
    """
    Takes in an array of data with empty entities and calculates the start and end indices for tokens.

    Args:
        data (list): List of dictionaries containing text and (initially empty) entity annotations.

    Returns:
        list: Updated data with calculated entity indices.
    """
    nlp = spacy.blank("en")

    updated_data = []

    for item in data:
        text = item["text"]
        doc = nlp(text)
        entities = []
        token_to_label = {
            entity["token"]: entity["label"] for entity in item["entities"]
        }

        for token in doc:
            label = token_to_label.get(token.text, "")

            entities.append(
                {
                    "start": token.idx,
                    "end": token.idx + len(token),
                    "label": label,
                    "token": token.text,
                }
            )

        updated_data.append({"text": text, "entities": entities})

    return updated_data


def print_data_with_entities(data, file=sys.stdout):
    """
    Prints the text with its dynamically calculated entity indices.

    Args:
        data (list): List of dictionaries containing text and entity annotations.

    Returns:
        None: Prints the formatted text and entities.
    """

    if not isinstance(data, list):
        raise ValueError("The input data must be a list of dictionaries.")

    for item in data:
        text = item.get("text", "")
        entities = item.get("entities", [])

        print(f"Text: {text}\n", file=file)
        print("Tokens with Indices:", file=file)
        for entity in entities:
            print(
                f"{entity['token']} ({entity['start']}, {entity['end']}): {entity['label']}",
                file=file
            )
        print("\n" + "-" * 50 + "\n", file=file)
