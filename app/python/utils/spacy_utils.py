# app/python/utils/spacy_utils.py

import json
import re
import os
import spacy
from spacy.tokens import DocBin
from spacy.training import Example
from app.python.utils.data_handler import hash_train_data, load_data

# -------------------- SpaCy Data Conversion --------------------
RED = "\033[31m"
RESET = "\033[0m"
def print_token_characters(tokens):
    text = ''.join(tokens)
    
    for idx, char in enumerate(text):
        print(f"{char} {idx}")

def add_space_to_tokens(tokens, labels):
    all_tokens = []
    all_labels = []

    no_space_entities = {"COMMITMENT", "CURRENCY", "SALARY_SINGLE"}

    for i, token in enumerate(tokens):
        all_tokens.append(token)
        all_labels.append(labels[i])  
 
        if i < len(tokens) - 1:
            next_token = tokens[i + 1]
            
            if re.match(r'^\$|\€|\£|\₹|\¥$', token) and re.match(r'^\d[\d,]*$', next_token):
                continue   

            if labels[i].startswith("B-") and labels[i + 1].startswith("I-") and labels[i][2:] == labels[i + 1][2:]:
                if labels[i][2:] not in no_space_entities: 
                    all_tokens.append(" ")  
                    all_labels.append("O")

            if labels[i + 1].startswith("I-") and labels[i][2:] == labels[i + 1][2:]:     
                continue 

            elif next_token not in [".", ",", "!", "?", ";", ":", "'"]:
                all_tokens.append(" ")
                all_labels.append("O")

    return all_tokens, all_labels

#  custom offsets from BIO to BILUO tags
def bio_to_offset(nlp, text, labels):
    """Convert BIO data format (len(text)) to spaCy's character offset format (len(doc))."""
    doc = nlp.make_doc(text)
    tokens = [token.text for token in doc]
    
    all_tokens, all_labels = add_space_to_tokens(tokens, labels)

    if len(all_tokens) != len(all_labels):
        raise ValueError(f"Token and label length mismatch. Tokens: {len(all_tokens)}, Labels: {len(all_labels)}")

    # print_token_characters(all_tokens)
    # print(f"all_tokens length: {len(all_tokens)}")
    entities = []
    current_entity = None
    current_start = None
    current_label = None
    char_offset = 0

    for i, (word, label) in enumerate(zip(all_tokens, all_labels)):
        word_start = char_offset
        word_length = len(word)
        char_offset += word_length 
        next_label = all_labels[i + 1] if i + 1 < len(all_labels) else None

        # print(f"word: {word}, label : {label}, next label: {next_label} word_start : {word_start}, char_offset : {char_offset}")

        if label.startswith("B-"):
            if current_entity is not None:
                # print(f"1 appending current_entity: {current_entity}, current_start: {current_start}, char_offset - word_length: {char_offset - word_length}, current_label: {current_label}")
                entities.append((current_start, char_offset - word_length, current_label, current_entity))

            current_entity = word
            current_start = word_start
            current_label = label[2:]

        elif label.startswith("I-"):
            # print(f"  current_entity: {current_entity}, current label : {current_label}")
            if current_entity is not None:
                current_entity += " " + word
                # print(f"1b appending current_entity: {current_entity}, current label : {current_label} current_start: {current_start}")
                entities.append((current_start, char_offset, current_label, current_entity))
                current_entity = None
                current_start = None
                current_label = None

        elif label == "O":
            if current_entity is not None and next_label is not None and (not next_label.startswith("I-")):
                # print(f"2a appending current_entity next to another entity: {current_entity}, current_start: {current_start}, char_offset - 1: {char_offset - 1}, current_label: {current_label} ")
                entities.append((current_start, char_offset - 1, current_label, current_entity))
        
                current_entity = None
                current_start = None
                current_label = None    
        else:
            raise ValueError(f"Invalid label: {label}")
        
        if i == len(all_tokens) - 1:
            if current_entity is not None:
                # print(f"3 appending current_entity: {current_entity}, current_start: {current_start}, char_offset - 1: {char_offset - 1}, current_label: {current_label}")
                entities.append((current_start, char_offset - 1, current_label, current_entity))

    # print(f"entities: {entities}")
    # print("-" * 15, "bio_to_offset", "-" * 15)
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
def custom_offsets_to_biluo_tags(spans, text, doc):
    """Convert spans len(doc) into BILUO format len(text)."""
    modified_text = text 
    previous_end = 0
    previous_token_text = None
    COMMITMENT_TEXT = ["part", "full"]
    
    for token in doc:
        print(f" 1 Token: '{token.text}' (start: {token.idx}, end: {token.idx})")
        is_commitment_token = False
        if previous_token_text:
            is_commitment_token = any(word.lower() == previous_token_text.lower() for word in COMMITMENT_TEXT)
        

        connecting_hyphen = token.text == "-" and previous_end == token.idx
        print(f" 2 Previous end: {previous_end}, token.idx: {token.idx}, token.text: {token.text} connecting_hyphen: {connecting_hyphen}")
        
        if connecting_hyphen and not is_commitment_token:
            modified_text = modified_text[:token.idx] + ' - ' + modified_text[token.idx + len(token.text):]
            print(f" 3 Replaced hyphen at position {token.idx} with ' - '")
        
        previous_end = token.idx + len(token.text)
        previous_token_text = token.text

    biluo_tags = ["O"] * len(modified_text) 
    # for i, el in enumerate(text):
    #     print(f"i: {i}, el: {el}")

    for start, end, label, token in spans:
        word = None

        if start < len(modified_text) and end <= len(modified_text):
            span_modified_text = modified_text[start:end]
            # print(f" 1 start {modified_text[start]} end {modified_text[end]}, print word : {modified_text[start:end]}")
            # print(f"2 span_modified_text: {span_modified_text}, word : {word}")

            word = span_modified_text
            biluo_tags[start] = f"U-{label}"
            # print(f"3 biluo_tags[start]: {biluo_tags[start]} word : {word}")

        if word is not None :
            # print(f"4 word: {word}, token: {token}")
            if len(word) > 1:
                biluo_tags[start] = f"B-{label}"
                # print(f"5 biluo_tags[start]: {biluo_tags[start]}")

                for i in range(start + 1, end - 1):
                    biluo_tags[i] = f"I-{label}"
                    # print(f"6 biluo_tags[i]: {biluo_tags[i]}")
                if end - 1 >= start:
                    biluo_tags[end - 1] = f"L-{label}"
                    # print(f"7 biluo_tags[end - 1]: {biluo_tags[end - 1]}")

        if word != token:
            print(f"{RED}Word mismatch: {word} != {token}{RESET}")   

    # for idx, tag in enumerate(biluo_tags):
    #     if idx < len(modified_text):  
    #         print(f"biluo_tags[{idx}]: {tag}, associated token: {modified_text[idx]}")

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
                    f"{RED}VALIDATION FAIL********: {span_tokens[span_index]} ->  Expected: {span_labels[span_index]}, Found: {actual_tag}{RESET}"
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

        biluo_tags = custom_offsets_to_biluo_tags(spans, text, doc)
        # converted_tags = convert_tokens_to_whole_word(doc, biluo_tags, spans, text)

        # for token, tag in zip([token.text for token in doc], converted_tags):
        #     print(f"token: {token} tag: {tag}")

        # if spans:
        #     print(f"\n{'Entities (start, end, label, token):':<50}")
        #     print(f"{'Start':<10}{'End':<10}{'Label':<20}{'Token':<20}")
        #     print("-" * 70)

        #     for start, end, label, token in spans:
        #         print(f"{start:<10}{end:<10}{label:<20}{token:<20}")

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
