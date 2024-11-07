# app/python/utils/spacy_utils.py

import json
import spacy
from spacy.tokens import DocBin
from spacy.training import Example
from spacy.training.iob_utils import offsets_to_biluo_tags
from app.python.utils.data_handler import load_data

# -------------------- SpaCy Data Conversion --------------------

def bio_to_offset(nlp, text, labels):
    """Convert BIO data format to spaCy's character offset format."""
    doc = nlp.make_doc(text)
    tokens = [token.text for token in doc]

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
        if label.startswith("B-"):
            if current_entity:
                entities.append((current_start, char_offset - 1, current_label))
            current_entity = word
            current_start = char_offset
            current_label = label[2:]
        elif label.startswith("I-") and current_label == label[2:]:
            current_entity += " " + word
        else:
            if current_entity:
                entities.append((current_start, char_offset - 1, current_label))
            current_entity = None
            current_label = None
            current_start = None
        char_offset += len(word) + 1  

    if current_entity:
        entities.append((current_start, char_offset - 1, current_label))
        
    return [{"start": start, "end": end, "label": label} for start, end, label in entities]

def convert_bio_to_spacy_format(input_file, output_file, folder, nlp):
    """Convert BIO formatted input data to spaCy format and save it."""
    data = load_data(input_file, folder)

    converted_data = []
    for item in data:
        text = item["text"]
        labels = item["labels"]
        entities = bio_to_offset(nlp, text, labels)
        
        converted_data.append({"text": text, "entities": entities})

    with open(output_file, 'w') as f:
        json.dump(converted_data, f, indent=2)
    print(f"Data converted and saved to {output_file}")

def convert_to_spacy_format(train_data, print_limit=3):
    """Convert training data to spaCy format with BILUO alignment."""
    db = DocBin()
    nlp_blank = spacy.blank("en")
    examples = []  
    
    print("\nConverting training data to spaCy format...")
    
    for index, entry in enumerate(train_data):  
        text = entry["text"]
        entities = entry.get("entities", [])
        
        doc = nlp_blank.make_doc(text)
        spans = [(int(ent["start"]), int(ent["end"]), ent["label"]) for ent in entities]

        if index < print_limit:
            print(f"\n{'Original Text:':<20} '{text}'")
            print(f"{'Tokenized Text:':<20} {[token.text for token in doc]}")
            
            biluo_tags = offsets_to_biluo_tags(doc, spans)

            if spans:
                print(f"\n{'Entities (start, end, label):':<35}")
                print(f"{'Start':<10}{'End':<10}{'Label':<20}")
                print("-" * 50)   
                
                for start, end, label in spans[:3]:   
                    print(f"{start:<10}{end:<10}{label:<20}")
                    
                print(f"\n{'BILUO Tags:':<35}")
                print(f"{'Token':<15}{'BILUO Tag':<15}")
                print("-" * 50)  

                for token, tag in zip([token.text for token in doc], biluo_tags[:3]):  
                    print(f"{token:<15}{tag:<15}")

        example = Example.from_dict(doc, {"entities": spans})
        doc._.set("index", index) 
        db.add(example.reference)
        examples.append(example)  
    
    return db, examples  

def check_entity_alignment(nlp, text, entities):
    doc = nlp.make_doc(text)
    biluo_tags = offsets_to_biluo_tags(doc, entities)
    print(f"CHECKING ALIGNMENT ----------------------------")
    print(f"Original Text: {text}")
    print("Tokens: ", [token.text for token in doc])
    print("BILUO Tags: ", biluo_tags)
