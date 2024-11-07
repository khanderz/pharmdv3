# app/python/salary_extraction/train_model.py

import os
import spacy
import json
import random
import spacy_transformers  
from spacy.tokens import DocBin
from spacy.training import Example
from spacy.training.iob_utils import offsets_to_biluo_tags

script_dir = os.path.dirname(os.path.abspath(__file__))
train_data_path = os.path.join(script_dir, "data", "train_data.json")
converted_data_path = os.path.join(script_dir, "data", "train_data_spacy.json")
model_save_path = "app/python/salary_extraction/model/spacy_salary_ner_model"

# Load a blank spaCy model n' add transformer and NER pipeline
nlp = spacy.blank("en")
transformer_config = {
    "model": {
        "@architectures": "spacy-transformers.TransformerModel.v1",
        "name": "roberta-base",
        "get_spans": {
            "@span_getters": "spacy-transformers.doc_spans.v1"
        }
    }
}
transformer = nlp.add_pipe("transformer", config=transformer_config)
ner = nlp.add_pipe("ner")

ENTITY_LABELS = ["SALARY_MIN", "SALARY_MAX", "SALARY_SINGLE", "CURRENCY", "INTERVAL", "COMMITMENT", "JOB_COUNTRY"]
for label in ENTITY_LABELS:
    ner.add_label(label)

# Convert BIO data format to spaCy's character offset format
def bio_to_offset(text, labels):
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
    
    print(f"Entities detected for '{text}': {entities}")
    
    return [{"start": start, "end": end, "label": label} for start, end, label in entities]

def convert_bio_to_spacy_format(input_file, output_file):
    with open(input_file, 'r') as f:
        data = json.load(f)
    
    converted_data = []
    for item in data:
        text = item["text"]
        labels = item["labels"]
        entities = bio_to_offset(text, labels)
        
        converted_data.append({"text": text, "entities": entities})

    with open(output_file, 'w') as f:
        json.dump(converted_data, f, indent=2)
    print(f"Data converted and saved to {output_file}")

convert_bio_to_spacy_format(train_data_path, converted_data_path)

# Load and convert training data to DocBin format
def load_training_data(train_data_path):
    with open(train_data_path, "r") as f:
        train_data = json.load(f)
    return train_data

# Convert JSON data to spaCy format w/ BILUO alignment
def convert_to_spacy_format(train_data):
    db = DocBin()
    nlp_blank = spacy.blank("en")
    examples = []
    
    print("\nConverting training data to spaCy format...")
    for index, entry in enumerate(train_data):  
        text = entry["text"]
        entities = entry.get("entities", [])
        
        doc = nlp_blank.make_doc(text)
        spans = [(int(ent["start"]), int(ent["end"]), ent["label"]) for ent in entities]
        
        print(f"\nOriginal Text: '{text}'")
        print(f"Tokenized Text: {[token.text for token in doc]}") 
        
        biluo_tags = offsets_to_biluo_tags(doc, spans)

        if len(spans) > 0:
            print(f"Entities (start, end, label): {spans[:3]}")  
            print(f"BILUO Tags: {biluo_tags[:3]}") 
            
        example = Example.from_dict(doc, {"entities": spans})
        doc._.set("index", index) 
        db.add(example.reference)
        examples.append(example)
    
    return db, examples

# Register  extension for Doc to store indices
spacy.tokens.Doc.set_extension("index", default=None)

train_data = load_training_data(converted_data_path)
doc_bin, examples = convert_to_spacy_format(train_data)
doc_bin.to_disk("app/python/salary_extraction/data/train.spacy")

def train_spacy_model():
    print("\nStarting model training...")
    optimizer = nlp.begin_training()
    
    for epoch in range(5):  
        losses = {}
        random.shuffle(examples)
        
        for example in examples:
            text = example.reference.text
            ents = example.reference.ents
            
            index = example.reference._.get("index")
            
            if index is not None and index % (len(examples) // 5) == 0:  
                print(f"\nTraining with example text: '{text[:50]}...'")
                print(f"Example annotations (sample): {[ent.text for ent in ents[:3]]}") 
            
            nlp.update([example], drop=0.2, losses=losses, sgd=optimizer)
        
        print(f"\nEpoch {epoch + 1}, Losses: {losses}")
        print("----" * 10)

    nlp.to_disk(model_save_path)
    print(f"Model saved to {model_save_path}")


train_spacy_model()

nlp = spacy.load(model_save_path)

def inspect_model_predictions(text):
    doc = nlp(text)
    print("\nOriginal Text:")
    print(f"'{text}'\n")
    print("Token Predictions:")
    print(f"{'Token':<15}{'Predicted Label':<20}")
    print("-" * 35)
    for token in doc:
        label = token.ent_type_ if token.ent_type_ else "O"
        print(f"{token.text:<15}{label:<20}")

print("\nExample Prediction:")
inspect_model_predictions("The salary is expected to be $100,000 annually in USD.")

test_texts = [
    "The annual salary is expected to be $120,000 USD.",
    "Compensation ranges from €50,000 to €70,000 annually.",
    "Base pay in Canada is CAD 60,000 per year.",
    "This position offers a minimum salary of £45,000.",
    "Contractor role with hourly rate of 25 AUD."
]

for text in test_texts:
    print(f"\nTesting text: '{text}'")
    inspect_model_predictions(text)
