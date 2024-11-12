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
no_space_entities = {"COMMITMENT", "CURRENCY", "SALARY_SINGLE"}
punctuations = [".", ",", "!", "?", ";", ":", "'"]

def print_token_characters(tokens):
    text = ''.join(tokens)
    
    for idx, char in enumerate(text):
        print(f"{char} {idx}")

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

#  custom offsets from BIO to BILUO tags
def bio_to_offset(nlp, text, labels):
    """Convert BIO data format (len(text)) to spaCy's character offset format (len(doc))."""
    doc = nlp.make_doc(text)
    tokens = [token.text for token in doc]
    # print(f"text: {text} ") 
    all_tokens, all_labels = add_space_to_tokens(tokens, labels)

    # print_token_characters(all_tokens)

    if len(all_tokens) != len(all_labels):
        raise ValueError(f"Token and label length mismatch. Tokens: {len(all_tokens)}, Labels: {len(all_labels)}")

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
                # print(f"1 APPENDING---- current_entity: {current_entity}, current_start: {current_start}, char_offset - word_length: {char_offset - word_length}, current_label: {current_label}")
                entities.append((current_start, char_offset - word_length, current_label, current_entity))

            current_entity = word
            current_start = word_start
            current_label = label[2:]

        elif label.startswith("I-"):
            # print(f"1a current_entity: {current_entity}, current label : {current_label}")
            if current_entity is not None and next_label is not None and (not next_label.startswith("I-")):
                if current_label == "COMMITMENT":
                    current_entity += "-" + word
                else:
                    current_entity += " " + word
                
                # print(f"1b APPENDING---- current_entity: {current_entity}, current label : {current_label} current_start: {current_start}")
                entities.append((current_start, char_offset, current_label, current_entity))
                current_entity = None
                current_start = None
                current_label = None

        elif label == "O":
            if current_entity is not None and next_label is not None and (not next_label.startswith("I-")):
                # print(f"2a APPENDING---- current_entity next to another entity: {current_entity}, current_start: {current_start}, char_offset - 1: {char_offset - 1}, current_label: {current_label} ")
                entities.append((current_start, char_offset - 1, current_label, current_entity))
        
                current_entity = None
                current_start = None
                current_label = None    
        else:
            raise ValueError(f"Invalid label: {label}")
        
        if i == len(all_tokens) - 1:
            if current_entity is not None:
                # print(f"3 APPENDING---- current_entity: {current_entity}, current_start: {current_start}, char_offset - 1: {char_offset - 1}, current_label: {current_label}")
                entities.append((current_start, char_offset - 1, current_label, current_entity))

    # print(f"entities: {entities}")
    print("-" * 15, "bio_to_offset", "-" * 15)
    return [
        {"start": start, "end": end, "label": label, "token": token}
        for start, end, label, token in entities
    ]

def add_space_to_tokens(tokens, labels):
    is_bio_format = all(label.startswith("B-") or label.startswith("I-") or label == "O" for label in labels)
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
            current_label_type = labels[i][2:] if is_bio_format and labels[i] != "O" else labels[i]
            next_label_type = next_label[2:] if is_bio_format and next_label != "O" else next_label

            # print(f" 2 Token: {token} Next Token: {next_token}, Next Label: {next_label}, Current Label Type: {current_label_type}, Next Label Type: {next_label_type}")

            if (re.match(r'^\$|\€|\£|\₹|\¥$', token) and re.match(r'^\d[\d,]*$', next_token)): 
            # or token == '-':
                # print(f"3 Token: {token}, Next Token: {next_token}")
                continue   

            if is_bio_format:
                if labels[i].startswith("B-") and next_label.startswith("I-") and current_label_type == next_label_type:
                    # print(f"4 Token: {token}, Next Token: {next_token}")
                    if current_label_type not in no_space_entities: 
                        all_tokens.append(" ")  
                        all_labels.append("O")

                if next_label.startswith("I-") and current_label_type == next_label_type:
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
                    if current_label_type not in no_space_entities and token != "," and next_token != ":":
                        # print(f"8 Token: {token}, Next Token: {next_token}")
                        all_tokens.append(" ")
                        all_labels.append("O")


                elif next_token not in punctuations:
                    # print(f"9 Token: {token}, Next Token: {next_token}")
                    all_tokens.append(" ")
                    all_labels.append("O")
    # print(f"all_tokens: {all_tokens}, all_labels: {all_labels}")
    return all_tokens, all_labels

def convert_biluo_to_tokens_and_labels(text, all_tokens, all_labels):
    # print(f"all_tokens : {all_tokens}, all_labels : {all_labels}, text : {text}")
    result = []

    flattened_tokens = []
    flattened_labels = []

    for token, label in zip(all_tokens, all_labels):
        sub_tokens = token.split()
        flattened_tokens.extend(sub_tokens)
        flattened_labels.extend([label] * len(sub_tokens))
        # print(f"token : {token}, label : {label}, sub_tokens : {sub_tokens}")

    text_tokens = re.findall(r'\b(?:part|full|time)-\w+\b|\b\w+(?:,\w+)*\b|[^\w\s]', text, re.IGNORECASE)
    
    token_index = 0
    total_tokens = len(flattened_tokens)
    # print(f"text_tokens: {text_tokens}")

    for word in text_tokens:
        if token_index < total_tokens and word == flattened_tokens[token_index]:
            result.append(f"Token: {word}, Label: {flattened_labels[token_index]}")
            token_index += 1 
        else:
            result.append(f"Token: {word}, Label: O")

    # print(f"result: {result}")
    return result

#  custom offsets BILUO tags from doc to text
def custom_offsets_to_biluo_tags(spans, text):
    """Convert spans len(doc) into BILUO format len(text)."""
    all_labels = [label for _, _, label, _ in spans]
    all_tokens = [token for _, _, _, token in spans]

    new_tags = convert_biluo_to_tokens_and_labels(text, all_tokens, all_labels)

    new_labels = [tag.split(', Label: ')[1] for tag in new_tags]
    new_tokens = [tag.split(', Label: ')[0].replace('Token: ', '').strip() for tag in new_tags]

    tokens_with_spaces, _ = add_space_to_tokens(new_tokens, new_labels)
    new_text = ''.join(tokens_with_spaces)
    # print(f"tokens_with_spaces: {tokens_with_spaces}")
    biluo_tags = ["O"] * len(new_text) 

    # print(f"{len(('').join(text))}")

    # print_token_characters(tokens_with_spaces)
    # print(f"{len(('').join(tokens_with_spaces))}")

    for start, end, label, token in spans:
        word = None

        if start < len(new_text) and end <= len(new_text):
            # print(f"start: {start}, end: {end}, label: {label}, token: {token}")
            span_text = new_text[start:end]
            # print(f" 1 start {new_text[start]} end {new_text[end]}, print word : {new_text[start:end]}")
            # print(f"2 span_text: {span_text}, word : {word}")

            word = span_text
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

        word_mismatch = False

        if word != token:
            word_mismatch = True
            print(f"{RED}Word mismatch: {word} != {token}{RESET}")   

    if word_mismatch:
        # print(f"tokens with spaces: {tokens_with_spaces}, new text: {new_text}")
        for idx, tag in enumerate(biluo_tags):
            if idx < len(new_text):  
                print(f"biluo_tags[{idx}]: {tag}, associated token: {new_text[idx]}")


    print("-" * 15, "custom_offsets_to_biluo_tags", "-" * 15)
    return biluo_tags

def convert_tokens_to_whole_word(doc, biluo_tags, spans, text):
    """Convert BILUO tags(len(text)) to whole word tokens(len(doc))"""
    # print(f"biluo_tags: {biluo_tags}, doc: {doc},  text: {text}")
    
    # print_token_characters([token.text for token in doc])
    # print_token_characters(text)

    biluo_tokens = ["O"] * len(doc)
    char_to_token_index = []
    current_token_index = 0
    text = text.strip()
    
    # associates each character with a token index
    for token in doc:
        token_length = len(token.text)
        for _ in range(token_length):
            char_to_token_index.append(current_token_index)
        current_token_index += 1

    # handles spaces in text
    space_token_index = -1
    new_char_to_token_index = []
    for c in text:
        # print(f"c: {c}")
        if c == " ":
            new_char_to_token_index.append(space_token_index)
        else:
            new_char_to_token_index.append(char_to_token_index.pop(0))

    text_length = len(text)
    assert (
        len(new_char_to_token_index) == text_length
    ), f"Length mismatch: {len(new_char_to_token_index)} != {text_length}"
    
    # print(f"new_char_to_token_index: {new_char_to_token_index}")
    for i in range(len(biluo_tags)):
        if i < len(new_char_to_token_index):
            token_index = new_char_to_token_index[i]
            if token_index == -1:
                continue
        
            # print(f"biluo_tags[i]: {biluo_tags[i]}")
            if biluo_tags[i].startswith("B-"):
                # print(f" 1 ")
                biluo_tokens[token_index] = f"B-{biluo_tags[i][2:]}"
            elif biluo_tags[i].startswith("I-"):
                # print(f" 2 ")
                if biluo_tokens[token_index] == "O":
                    # print(f" 2a ")
                    biluo_tokens[token_index] = f"I-{biluo_tags[i][2:]}"
            elif biluo_tags[i].startswith("U-"):
                # print(f" 3 ")
                biluo_tokens[token_index] = f"U-{biluo_tags[i][2:]}"
            elif biluo_tags[i].startswith("L-"):
                if biluo_tokens[token_index] == "O":
                    # print(f" 4 ")
                    biluo_tokens[token_index] = f"L-{biluo_tags[i][2:]}"
            else:
                # print(f" 5 ")
                biluo_tokens[token_index] = "O"

    # print(f"biluo_tokens: {biluo_tokens}")
    # """Validation check for the converted BILUO tags."""
    span_labels = [label for _, _, label, _ in spans]
    span_tokens = [token for _, _, _, token in spans]

    span_index = 0
    for idx, (token, actual_tag) in enumerate(zip(doc, biluo_tokens)):
         if span_index < len(span_labels) and actual_tag != "O":
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

        biluo_tags = custom_offsets_to_biluo_tags(spans, text)
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
