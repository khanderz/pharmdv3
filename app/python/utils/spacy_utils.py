# app/python/utils/spacy_utils.py

import json
import os
import spacy
from spacy.tokens import DocBin
from spacy.training import Example
from app.python.utils.data_handler import hash_train_data, load_data

# -------------------- SpaCy Data Conversion --------------------

#  custom offsets from BIO to BILUO tags
def bio_to_offset(nlp, text, labels):
    """Convert BIO data format (len(text)) to spaCy's character offset format (len(doc))."""
    doc = nlp.make_doc(text)
    tokens = [token.text for token in doc]

    if len(tokens) != len(labels):
        print(f"Warning: Length mismatch between tokens and labels in text: '{text} for tokens: {len(tokens)}, labels : {len(labels)}'")
        return []

    entities = []
    current_entity = None
    current_start = None
    current_label = None
    char_offset = 0

    for i, label in enumerate(labels):
        word = tokens[i]
        word_start = char_offset

        if label.startswith("B-"):  
            if current_entity:
                entities.append(
                    (current_start, char_offset, current_label, current_entity)
                )

            current_entity = word
            current_start = word_start
            current_label = label[2:]  # Get the entity label without the "B-" prefix

        elif label.startswith("I-") and current_label == label[2:]:
            current_entity += " " + word
        else:
            if current_entity:
                entities.append(
                    (current_start, char_offset - 1, current_label, current_entity)
                )

            current_entity = None
            current_label = None
            current_start = None

        if i < len(labels) - 1:  # if an entity is next to another entity
            next_label = labels[i + 1]
            if current_entity and next_label.startswith("B-"):
                char_offset += len(word)
            else:
                char_offset += len(word) + 1

    if current_entity:
        entities.append((current_start, char_offset, current_label, current_entity))

    print("-" * 15, "bio_to_offset", "-" * 15)
    return [
        {"start": start, "end": end, "label": label, "token": token}
        for start, end, label, token in entities
    ]

def convert_bio_to_spacy_format(input_file, folder, nlp, CONVERTED_FILE_PATH):
    """Convert BIO formatted input data to spaCy format and save it."""
    data = load_data(input_file, folder)

    converted_data = []
    for item in data:
        text = item["text"]
        labels = item["labels"]
        entities = bio_to_offset(nlp, text, labels)
        converted_data.append({"text": text, "entities": entities})

    with open(CONVERTED_FILE_PATH, "w") as f:
        json.dump(converted_data, f, indent=2)

    print(
        f"Data converted and saved to: {CONVERTED_FILE_PATH} (Location: {CONVERTED_FILE_PATH})"
    )

#  custom offsets BILUO tags from doc to text
def custom_offsets_to_biluo_tags(spans, text):
    """Convert spans len(doc) into BILUO format len(text)."""
    biluo_tags = ["O"] * len(text)

    for start, end, label, token in spans:
        word = None

        if start < len(text) and end <= len(text):
            word = text[start:end]
            biluo_tags[start] = f"U-{label}"

        if word is not None :
            if len(word) > 1 :
                biluo_tags[start] = f"B-{label}"
                for i in range(start + 1, end - 1):
                    biluo_tags[i] = f"I-{label}"
                if end - 1 >= start:
                    biluo_tags[end - 1] = f"L-{label}"

    print("-" * 15, "custom_offsets_to_biluo_tags", "-" * 15)
    return biluo_tags

def convert_tokens_to_whole_word(doc, biluo_tags, spans, text):
    """Convert BILUO tags(len(text)) to whole word tokens(len(doc))"""
    biluo_tokens = ["O"] * len(doc)
    char_to_token_index = []
    current_token_index = 0
    text = text.strip()
    
    for token in doc:
        token_length = len(token.text)
        for _ in range(token_length):
            char_to_token_index.append(current_token_index)
        current_token_index += 1

    space_token_index = -1
    new_char_to_token_index = []
    for c in text:
        if c == " ":
            new_char_to_token_index.append(space_token_index)
        else:
            new_char_to_token_index.append(char_to_token_index.pop(0))

    text_length = len(text)
    assert (
        len(new_char_to_token_index) == text_length
    ), f"Length mismatch: {len(new_char_to_token_index)} != {text_length}"

    for i in range(len(biluo_tags)):
        if i < len(new_char_to_token_index):
            token_index = new_char_to_token_index[i]

            if biluo_tags[i].startswith("B-"):
                biluo_tokens[token_index] = f"B-{biluo_tags[i][2:]}"
            elif biluo_tags[i].startswith("I-"):
                pass
            elif biluo_tags[i].startswith("U-"):
                biluo_tokens[token_index] = f"U-{biluo_tags[i][2:]}"
            elif biluo_tags[i].startswith("L-"):
                pass

    # """Validation check for the converted BILUO tags."""
    span_labels = [label for _, _, label, _ in spans]
    span_tokens = [token for _, _, _, token in spans]

    span_index = 0
    for idx, (token, actual_tag) in enumerate(zip(doc, biluo_tokens)):
        if actual_tag != "O":
            if span_labels[span_index] not in str(actual_tag):
                print(
                    f"VALIDATION FAIL********: {span_tokens[span_index]} ->  Expected: {span_labels[span_index]}, Found: {actual_tag}"
                )
                span_index += 1
            else:
                print(
                    f"VALIDATION PASS: {span_tokens[span_index]} ->   {span_labels[span_index]} equals {actual_tag}"
                )
                span_index += 1

    print("-" * 15, "convert_tokens_to_whole_word", "-" * 15)
    return biluo_tokens


def convert_to_spacy_format(train_data):
    """Convert training data to spaCy format with BILUO alignment."""
    db = DocBin()
    nlp_blank = spacy.blank("en")
    examples = []

    print("\nConverting training data to spaCy format...")

    for index, entry in enumerate(train_data):
        text = entry["text"]
        entities = entry.get("entities", [])
        doc = nlp_blank.make_doc(text)
        tokens = []
        spans = []
        for ent in entities:
            start = int(ent["start"])
            end = int(ent["end"])
            label = ent["label"]
            token = ent["token"]
            spans.append((start, end, label, token))
            tokens.append(token)

        print(f"\n{'Original Text:':<20} '{text}'")

        biluo_tags = custom_offsets_to_biluo_tags(spans, text)
        converted_tags = convert_tokens_to_whole_word(doc, biluo_tags, spans, text)

        for token, tag in zip([token.text for token in doc], converted_tags):
            print(f"token: {token} tag: {tag}")

        if spans:
            print(f"\n{'Entities (start, end, label, token):':<50}")
            print(f"{'Start':<10}{'End':<10}{'Label':<20}{'Token':<20}")
            print("-" * 70)

            for start, end, label, token in spans:
                print(f"{start:<10}{end:<10}{label:<20}{token:<20}")

        example_entities = [(start, end, label) for start, end, label, _ in spans]

        example = Example.from_dict(doc, {"entities": example_entities})

        doc._.set("index", index)
        db.add(example.reference)
        examples.append(example)

    return db, examples


def handle_convert_to_spacy(SPACY_DATA_PATH, CONVERTED_FILE, FOLDER, TRAIN_DATA_FILE):
    if os.path.exists(SPACY_DATA_PATH):
        print("Converted data already exists. Checking for changes...")

        current_hash = hash_train_data(CONVERTED_FILE)

        try:
            with open("last_train_data_hash.txt", "r") as f:
                last_hash = f.read()
        except FileNotFoundError:
            last_hash = None

        if current_hash == last_hash:
            print("Training data has not changed. Loading existing data...")
            doc_bin = DocBin().from_disk(SPACY_DATA_PATH)
            examples = []
        else:
            print("Training data has changed. Converting data now...")
            train_data = load_data(CONVERTED_FILE, FOLDER)
            doc_bin, examples = convert_to_spacy_format(train_data)

            doc_bin.to_disk(SPACY_DATA_PATH)
            if current_hash is not None:
                with open("last_train_data_hash.txt", "w") as f:
                    f.write(current_hash)

    else:
        print("Converted data does not exist. Converting data now...")
        train_data = load_data(CONVERTED_FILE, FOLDER)
        doc_bin, examples = convert_to_spacy_format(train_data)

        doc_bin.to_disk(SPACY_DATA_PATH)

        current_hash = hash_train_data(TRAIN_DATA_FILE)
        if current_hash is not None:
            with open("last_train_data_hash.txt", "w") as f:
                f.write(current_hash)
        else:
            print(
                "Unable to save the hash since the training data file does not exist."
            )
