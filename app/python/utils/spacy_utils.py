# app/python/utils/spacy_utils.py

import json
import os
import spacy
from spacy.tokens import DocBin
from spacy.training import Example
from spacy.training.iob_utils import offsets_to_biluo_tags
from app.python.utils.data_handler import hash_train_data, load_data

# -------------------- SpaCy Data Conversion --------------------

#  custom offsets to BILUO tags
def bio_to_offset(nlp, text, labels):
    """Convert BIO data format to spaCy's character offset format."""
    doc = nlp.make_doc(text)
    tokens = [token.text for token in doc]

    # print(f"Original Text: '{text}'")
    # print(f"Tokenized: {tokens}")
    # print(f"Labels: {labels}")

    if len(tokens) != len(labels):
        print(f"Warning: Length mismatch between tokens and labels in text: '{text}'")
        print(f"Tokens: {tokens}")
        print(f"Labels: {labels}")
        return []

    entities = []
    current_entity = None
    current_start = None
    current_label = None
    char_offset = 0

    for i, label in enumerate(labels):
        word = tokens[i]
        word_start = char_offset  
        word_end = char_offset + len(word)   
        # print(f"*******************i: {i} label: {label} word: {word}***********************")

        if label.startswith("B-"):
            if current_entity:
                entities.append((current_start, char_offset, current_label, current_entity))
                # print(f"--------Appended data 1: {current_start} | {char_offset} | {current_label} ")
                # print(f"Finalizing entity 1: '{current_entity}' | Start: {current_start} | End: {char_offset} | Label: {current_label} ")

            current_entity = word
            current_start = word_start
            current_label = label[2:]  # Get the entity label without the "B-" prefix

            # print(f"Starting new entity 2: '{current_entity}' | Start: {current_start} | Label: {current_label} ")
        elif label.startswith("I-") and current_label == label[2:]:
            current_entity += " " + word

            # print(f"Extending entity 3: '{current_entity}'")
        else:
            if current_entity:
                entities.append((current_start, char_offset - 1, current_label, current_entity))
                # print(f"--------Appended data 4: {current_start} | {char_offset - 1} | {current_label}")
                # print(f"Finalizing entity 4: '{current_entity}' | Start: {current_start} | End: {word_end} | Label: {current_label} ")

            current_entity = None
            current_label = None
            current_start = None

        if i < len(labels) - 1:   # if an entity is next to another entity
            next_label = labels[i + 1]
            if current_entity and next_label.startswith("B-"):
                char_offset += len(word)  

                # print(f"Adjacent entities found 5: '{current_entity}' | Next Label: '{next_label}' ")
            else:
                char_offset += len(word) + 1  

        # print(f"Processing Token 6: '{word}' | Start: {word_start} | End: {word_end} | Label: {label} | offset {char_offset}  " )

    if current_entity:
        entities.append((current_start, char_offset, current_label, current_entity))
        # print(f"----------Appended last data 7: {current_start} | {char_offset} | {current_label}")
        # print(f"Finalizing last entity 7: '{current_entity}' | Start: {current_start} | End: {char_offset} | Label: {current_label} ")

    return [{"start": start, "end": end, "label": label, "token": token} for start, end, label, token in entities]


def convert_bio_to_spacy_format(input_file, folder, nlp, CONVERTED_FILE_PATH):
    """Convert BIO formatted input data to spaCy format and save it."""
    data = load_data(input_file, folder)

    converted_data = []
    for item in data:
        text = item["text"]
        labels = item["labels"]
        entities = bio_to_offset(nlp, text, labels)
        
        converted_data.append({"text": text, "entities": entities})

    with open(CONVERTED_FILE_PATH, 'w') as f:
        json.dump(converted_data, f, indent=2)

    # Print a message indicating the output file path and its location
    print(f"Data converted and saved to: {CONVERTED_FILE_PATH} (Location: {CONVERTED_FILE_PATH})")

#  custom offsets to BILUO tags
def custom_offsets_to_biluo_tags(doc, spans, text):
    """Convert spans with additional properties into BILUO format."""
    biluo_tags = ['O'] * len(text)

    for start, end, label, token in spans:
        word = None
        print(f'text : {text}')


        if start < len(text) and end <= len(text):
            print(f"Start: {start} | End: {end} | Label: {label} | Token: {token}")

            word = text[start:end]
            biluo_tags[start] = f'U-{label}'  
            print(f"word: {word}, label : {label}, start: {start}, end: {end}, text[start]: {text[start]}, text[end]: {text[end]} ")

            
        if len(word) > 1:
            biluo_tags[start] = f'B-{label}'   
            for i in range(start + 1, end - 1):   
                biluo_tags[i] = f'I-{label}'
            if end - 1 >= start:  
                biluo_tags[end - 1] = f'L-{label}'
                print(f" word: {word},label : {label},biluo_tags[i]: {biluo_tags[i]}")
                
    print(f"biluo_tags: {biluo_tags}")
    return biluo_tags

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
        spans = [(int(ent["start"]), int(ent["end"]), ent["label"], ent['token']) for ent in entities]

        # print(f"\n{'Original Text:':<20} '{text}'")
        
        biluo_tags = custom_offsets_to_biluo_tags(doc, spans, text)
        # print(f"************tags: {biluo_tags}")
        # if spans:
        #     print(f"\n{'Entities (start, end, label, token):':<50}")
        #     print(f"{'Start':<10}{'End':<10}{'Label':<20}{'Token':<20}")
        #     print("-" * 70)   
            
        #     for start, end, label, token in spans:
        #         print(f"{start:<10}{end:<10}{label:<20}{token:<20}")
                
        #     print(f"\n{'BILUO Tags:':<35}")
        #     print(f"{'Token':<15}{'BILUO Tag':<15}")
        #     print("-" * 25)  

        #     for token, tag in zip([token.text for token in doc], biluo_tags):
        #         print(f"{token:<15}{tag:<15}")

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
            with open('last_train_data_hash.txt', 'r') as f:
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
                with open('last_train_data_hash.txt', 'w') as f:
                    f.write(current_hash)

    else:
        print("Converted data does not exist. Converting data now...")
        train_data = load_data(CONVERTED_FILE, FOLDER)
        doc_bin, examples = convert_to_spacy_format(train_data)


        doc_bin.to_disk(SPACY_DATA_PATH)
 
        current_hash = hash_train_data(TRAIN_DATA_FILE)
        if current_hash is not None:
            with open('last_train_data_hash.txt', 'w') as f:
                f.write(current_hash)
        else:
            print("Unable to save the hash since the training data file does not exist.")
