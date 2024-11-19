# app/python/utils/spacy_utils.py

import json
import re
import os
import spacy
from spacy.tokens import DocBin
from spacy.training import Example
from app.python.utils.data_handler import generate_path, hash_train_data, load_data
from app.python.utils.logger import BLUE,   RED, RESET
from app.python.utils.utils import add_space_to_tokens, print_side_by_side, print_token_characters

# -------------------- SpaCy Data Conversion --------------------
no_space_entities = {"COMMITMENT", "CURRENCY", "SALARY_SINGLE"}
punctuations = [".", ",", "!", "?", ";", ":", "'"]

# ------------------- CONVERT BIO TO SPACY -------------------
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
    return converted_data

#  custom offsets from BIO to BILUO tags
def bio_to_offset(nlp, text, labels):
    """Convert BIO data format (len(text)) to spaCy's character offset format (len(doc))."""
    doc = nlp.make_doc(text)
    tokens = [token.text for token in doc]
    # print(f"text: {text} ") 
    all_tokens, all_labels = add_space_to_tokens(tokens, labels, no_space_entities, punctuations)

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

    return [
        {"start": start, "end": end, "label": label, "token": token}
        for start, end, label, token in entities
    ]

# ------------------- LOAD/CONVERT SPACY TO BILUO -------------------
def handle_spacy_data(SPACY_DATA_PATH, CONVERTED_FILE, FOLDER, TRAIN_DATA_FILE, nlp, tokenizer=None, MAX_SEQ_LENGTH=None, longformer_model=None):
    last_hash_path = generate_path("last_train_data_hash.txt", FOLDER)
    examples = []

    converted_file_path = generate_path(CONVERTED_FILE, FOLDER)
    current_hash = hash_train_data(FOLDER,TRAIN_DATA_FILE)

    if not os.path.exists(converted_file_path):
        print(f"{BLUE}BIO TO BILUO FORMAT converted file {converted_file_path} not found. Generating it from BIO format.{RESET}")
        
        pre_examples  = convert_bio_to_spacy_format(TRAIN_DATA_FILE, FOLDER, nlp, converted_file_path)
        doc_bin, examples = convert_to_spacy_format(pre_examples, SPACY_DATA_PATH, nlp)
    else:
        print(f"{BLUE}Using existing BIO to BILUO format converted file: {converted_file_path}{RESET}")

    if os.path.exists(SPACY_DATA_PATH):
        print(f"{BLUE}BIO TO BILUO FORMAT Converted data already exists. Checking for changes...{RESET}")
        
        try:
            with open(last_hash_path, "r") as f:
                last_hash = f.read()
                print(f"{BLUE}Last hash found{RESET}")
        except FileNotFoundError:
            last_hash = None
            print(f"{RED}Warning: last_train_data_hash.txt not found.{RESET}")

        if current_hash == last_hash:
            print(f"{BLUE}Training data has not changed. Loading existing data...{RESET}")
            
            doc_bin = DocBin().from_disk(SPACY_DATA_PATH)
            docs = list(doc_bin.get_docs(nlp.vocab))

            processed_examples = []
            for doc in docs:
                if tokenizer and MAX_SEQ_LENGTH:
                    inputs = tokenizer(
                        doc.text,
                        max_length=MAX_SEQ_LENGTH,
                        truncation=True,
                        padding="max_length",
                        return_tensors="pt",
                    )
                    outputs = longformer_model(**inputs)
                    embeddings = outputs.last_hidden_state 
                    entities = [(ent.start_char, ent.end_char, ent.label_) for ent in doc.ents]
                    processed_examples.append({"inputs": inputs, "embeddings": embeddings, "entities": entities})
                else:
                    entities = [(ent.start_char, ent.end_char, ent.label_) for ent in doc.ents]
                    processed_examples.append({"inputs": None, "entities": entities})

                # examples.append(Example.from_dict(doc, {"entities": entities})) //TODO: check if this is needed

            return doc_bin, processed_examples  
        else:
            print(f"{BLUE}Training data has changed. Converting data now...{RESET}")
            train_data = load_data(CONVERTED_FILE, FOLDER)
            doc_bin, examples = convert_to_spacy_format(train_data, SPACY_DATA_PATH, nlp)
 
            try:
                doc_bin.to_disk(SPACY_DATA_PATH)
                print(f"{BLUE}Data saved to {SPACY_DATA_PATH}{RESET}")

                with open(last_hash_path, "w") as f:
                    f.write(current_hash)
            except Exception as e:
                print(f"{RED}Error saving doc_bin: {e}{RESET}")

    else:
        print(f"{BLUE}Converted to spacy data does not exist. Converting data now...{RESET}")
        train_data = load_data(CONVERTED_FILE, FOLDER)
        doc_bin, examples = convert_to_spacy_format(train_data, SPACY_DATA_PATH, nlp)

        try:
            doc_bin.to_disk(SPACY_DATA_PATH)
            print(f"{BLUE}Data saved to {SPACY_DATA_PATH}{RESET}")

            with open(last_hash_path, "w") as f:
                f.write(current_hash)
        except Exception as e:
            print(f"{RED}Error saving doc_bin: {e} {RESET}")

    return doc_bin, examples         

def convert_to_spacy_format(train_data, SPACY_DATA_PATH, nlp):
    """Convert training data to spaCy format with BILUO alignment."""
    db = DocBin()
    nlp = spacy.blank("en")
    
    print(f"---------------CONVERTING TRAIN DATA TO SPACY FORMAT...")

    examples = []
    for _, entry in enumerate(train_data):
        text = entry["text"]
        entities = entry.get("entities", [])
        doc = nlp(text)
        example_entities = [(int(ent["start"]), int(ent["end"]), ent["label"]) for ent in entities]
        spans = [doc.char_span(start, end, label=label) for start, end, label in example_entities]
        spans = [span for span in spans if span is not None]   
        doc.ents = spans

        example = Example.from_dict(doc, {"entities": example_entities}) 
        db.add(doc)   
        examples.append(example)      

    db.to_disk(SPACY_DATA_PATH)
    loaded_db = DocBin().from_disk(SPACY_DATA_PATH)
    loaded_docs = list(loaded_db.get_docs(nlp.vocab))

    # for doc in loaded_docs:
    #     print(f"\nText: {doc.text}")
    #     print("Entities:")
    #     for ent in doc.ents:
    #         print(f"  - Text: '{ent.text}', Start: {ent.start_char}, End: {ent.end_char}, Label: {ent.label_}")

    # docs = list(DocBin().from_disk("path/to/train.spacy").get_docs(nlp.vocab))
    if not list(loaded_db.get_docs(nlp.vocab)):
        print(f"{RED}Warning: No documents were added to `doc_bin`.{RESET}")
    else:
        print(f"{BLUE}{len(loaded_docs)} documents saved/added to `doc_bin`.{RESET}")

    return db, examples

def convert_biluo_to_tokens_and_labels(text, all_tokens, all_labels):
    """Convert BILUO tags to tokens and labels."""
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

    tokens_with_spaces, _ = add_space_to_tokens(new_tokens, new_labels, no_space_entities, punctuations)
    new_text = ''.join(tokens_with_spaces)
    biluo_tags = ["O"] * len(new_text) 

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

        # word_mismatch = False

        # if word != token:
        #     word_mismatch = True
        #     print(f"{RED}Word mismatch: {word} != {token}{RESET}")   

    # if word_mismatch:
        # print(f"tokens with spaces: {tokens_with_spaces}, new text: {new_text}")
        # for idx, tag in enumerate(biluo_tags):
        #     if idx < len(new_text):  
        #         print(f"biluo_tags[{idx}]: {tag}, associated token: {new_text[idx]}")
    # print_side_by_side(text, biluo_tags)
    # print_token_characters(tokens_with_spaces)
    # print("-" * 15, "custom_offsets_to_biluo_tags", "-" * 15)
    return biluo_tags, tokens_with_spaces

def align_biluo_tags(char_to_token_index, biluo_tags, document_text):
    """Align BILUO tags(len(text)) to whole word tokens(len(doc))."""
    # print(f"tags : {biluo_tags}")
    alignment = []
    token_pos = 0
    always_u_tags = {"CURRENCY", "SALARY_MIN", "SALARY_MAX", "SALARY_SINGLE", "INTERVAL"}

    for word in document_text:
        word_tags = []
        # print(f"word: {word}")
        
        for _ in word:
            while token_pos < len(char_to_token_index) and char_to_token_index[token_pos] == -1:
                token_pos += 1
            
            if token_pos < len(char_to_token_index):
                tag_index = char_to_token_index[token_pos]
                if tag_index >= 0:
                    word_tags.append(biluo_tags[token_pos])
                token_pos += 1
        # print(f"word_tags: {word_tags}")
        if word_tags:
            if "JOB_COUNTRY" in word_tags[0]:
                if len(word_tags) == 1:
                    final_tag = "U-JOB_COUNTRY"
                elif word_tags[0].startswith("B-"):
                    final_tag = "B-JOB_COUNTRY"
                elif word_tags[-1].startswith("L-"):
                    final_tag = "L-JOB_COUNTRY"
                else:
                    final_tag = "I-JOB_COUNTRY"

            else:
                final_tag = word_tags[0] if word_tags[0].startswith("B-") or word_tags[0].startswith("U-") else word_tags[-1]

            tag_type = final_tag.split("-")[-1]
            if tag_type in always_u_tags:
                final_tag = f"U-{tag_type}"

        else:
            final_tag = "O"
        
        alignment.append(final_tag)
    return alignment

def convert_tokens_to_whole_word(doc, biluo_tags, spans, tokens_with_spaces):
    """Convert BILUO tags(len(text)) to whole word tokens(len(doc))"""
    biluo_tokens = ["O"] * len(doc) #TODO:
    char_to_token_index = []
    current_token_index = 0

    for token in tokens_with_spaces:
        if token == " ":
            char_to_token_index.append(-1)
            continue
        token_len = len(token)
        for _ in range(token_len):
            char_to_token_index.append(current_token_index)
        current_token_index += 1

    tags = align_biluo_tags(char_to_token_index, biluo_tags, [token.text for token in doc])

    # print_side_by_side([token.text for token in doc], tags)

    # """Validation check for the converted BILUO tags."""
    span_labels = [label for _, _, label, _ in spans]
    span_tokens = [token for _, _, _, token in spans]
    # print(f"span_labels: {span_labels}, span_tokens: {span_tokens}")
    current_entity = None
    combined_token = ""
    token_list = []
    span_index = 0

    # for i, (word, tag) in enumerate(zip(doc, tags)):
    #     word = word.text if hasattr(word, 'text') else word

    #     if tag != "O":
    #         tag_prefix, entity_label = tag.split("-")
    #     else:
    #         tag_prefix, entity_label = "O", None

    #     if tag_prefix == "B" or tag_prefix == "U":
    #         if current_entity is not None:
    #             combined_token = " ".join(token_list).strip()  
    #             if span_index < len(span_labels) and current_entity == span_labels[span_index] and combined_token == span_tokens[span_index]:
    #                 print(f"{GREEN}Word match: {combined_token} == {span_tokens[span_index]}{RESET}")
    #                 print(f"{GREEN}Entity match: {current_entity} == {span_labels[span_index]}{RESET}")
    #             else:
    #                 print(f"{RED}1 Word mismatch: {combined_token} != {span_tokens[span_index]}{RESET}")
    #                 print(f"{RED}1 Entity mismatch: {current_entity} != {span_labels[span_index]}{RESET}")
    #             span_index += 1

    #         current_entity = entity_label
    #         token_list = [word]

    #         if tag_prefix == "U":
    #             combined_token = " ".join(token_list).strip()
    #             if span_index < len(span_labels) and current_entity == span_labels[span_index] and combined_token == span_tokens[span_index]:
    #                 print(f"{GREEN}Word match: {combined_token} == {span_tokens[span_index]}{RESET}")
    #                 print(f"{GREEN}Entity match: {current_entity} == {span_labels[span_index]}{RESET}")
    #             else:
    #                 print(f"{RED}2 Word mismatch: {combined_token} != {span_tokens[span_index]}{RESET}")
    #                 print(f"{RED}2 Entity mismatch: {current_entity} != {span_labels[span_index]}{RESET}")
    #             span_index += 1
    #             current_entity = None

    #     elif tag_prefix == "I" or tag_prefix == "L":
    #         if word in ["-", "/", "&"]:
    #             token_list[-1] += word  
    #         else:
    #             token_list.append(word) 

    #         if tag_prefix == "L":
    #             combined_token = ''.join(token_list) if any('-' in token for token in token_list) else ' '.join(token_list).strip()
    #             if span_index < len(span_labels) and current_entity == span_labels[span_index] and combined_token == span_tokens[span_index]:
    #                 print(f"{GREEN}Word match: {combined_token} == {span_tokens[span_index]}{RESET}")
    #                 print(f"{GREEN}Entity match: {current_entity} == {span_labels[span_index]}{RESET}")
    #             else:
    #                 print(f"{RED}3 Word mismatch: {combined_token} != {span_tokens[span_index]}{RESET}")
    #                 print(f"{RED}3 Entity mismatch: {current_entity} != {span_labels[span_index]}{RESET}")
    #             span_index += 1
    #             current_entity = None

    #     elif tag == "O":
    #         if current_entity is not None:
    #             combined_token = " ".join(token_list).strip()  
    #             if span_index < len(span_labels) and current_entity == span_labels[span_index] and combined_token == span_tokens[span_index]:
    #                 print(f"{GREEN}Word match: {combined_token} == {span_tokens[span_index]}{RESET}")
    #                 print(f"{GREEN}Entity match: {current_entity} == {span_labels[span_index]}{RESET}")
    #             else:
    #                 print(f"{RED}4 Word mismatch: {combined_token} != {span_tokens[span_index]}{RESET}")
    #                 print(f"{RED}4 Entity mismatch: {current_entity} != {span_labels[span_index]}{RESET}")
    #             span_index += 1
    #             current_entity = None

    # if current_entity is not None and span_index < len(span_labels):
    #     combined_token = " ".join(token_list).strip()  
    #     if current_entity == span_labels[span_index] and combined_token == span_tokens[span_index]:
    #         print(f"{GREEN}Word match: {combined_token} == {span_tokens[span_index]}{RESET}")
    #         print(f"{GREEN}Entity match: {current_entity} == {span_labels[span_index]}{RESET}")
    #     else:
    #         print(f"{RED}5 Word mismatch: {combined_token} != {span_tokens[span_index]}{RESET}")
    #         print(f"{RED}5 Entity mismatch: {current_entity} != {span_labels[span_index]}{RESET}")

    # print("-" * 15, "convert_tokens_to_whole_word", "-" * 15)
    return tags