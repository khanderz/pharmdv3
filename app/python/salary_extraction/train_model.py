# app/python/salary_extraction/train_model.py

import spacy
import random
import spacy_transformers  
import os
import warnings
import logging
import hashlib
from spacy.tokens import DocBin

from app.python.utils.label_mapping import get_label_list
from app.python.utils.data_handler import generate_path, load_data
from app.python.utils.spacy_utils import  convert_bio_to_spacy_format, convert_to_spacy_format
from app.python.utils.validation_utils import check_entity_alignment

def hash_train_data(file_path):
    if not os.path.exists(file_path):
        print(f"Warning: Training data file '{file_path}' does not exist.")
        return None   
    with open(file_path, 'r') as f:
        return hashlib.md5(f.read().encode()).hexdigest()
    
# Set up constants for file paths
FOLDER = "salary_extraction"
TRAIN_DATA_PATH = "train_data.json"
CONVERTED_DATA_PATH = generate_path("train_data_spacy.json", FOLDER)
MODEL_SAVE_PATH = "app/python/salary_extraction/model/spacy_salary_ner_model"
SPACY_DATA_PATH = "app/python/salary_extraction/data/train.spacy"

# Suppress warnings
warnings.filterwarnings("ignore", message="`resume_download` is deprecated")
warnings.filterwarnings("ignore", message="Some weights of the model checkpoint at roberta-base were not used")
warnings.simplefilter(action='ignore', category=FutureWarning)
warnings.filterwarnings("ignore", category=UserWarning) 

# Set logging levels
logging.getLogger("transformers").setLevel(logging.WARNING)
logging.getLogger("torch").setLevel(logging.WARNING)
logging.getLogger("transformers").setLevel(logging.ERROR)  
logging.getLogger("torch").setLevel(logging.ERROR)

# Load data
data = load_data(TRAIN_DATA_PATH, FOLDER)

# Load and configure the spaCy model
nlp = spacy.blank("en")
nlp.add_pipe("transformer", config={
    "model": {
        "@architectures": "spacy-transformers.TransformerModel.v1",
        "name": "roberta-base",
        "get_spans": {
            "@span_getters": "spacy-transformers.doc_spans.v1"
        }
    }
})
ner = nlp.add_pipe("ner")

# Check if converted JSON file exists; if not, run conversion
if not os.path.exists(CONVERTED_DATA_PATH):
    convert_bio_to_spacy_format(TRAIN_DATA_PATH, CONVERTED_DATA_PATH, FOLDER, nlp)

for label in get_label_list():
    ner.add_label(label)

# Register extension for Doc to store indices
spacy.tokens.Doc.set_extension("index", default=None)

if os.path.exists(SPACY_DATA_PATH):
    print("Converted data already exists. Checking for changes...")
    
    # Check if train data file exists and get its hash
    current_hash = hash_train_data('app/python/salary_extraction/data/train_data.json')
    
    # Compare with the previous hash saved in a separate file
    try:
        with open('last_train_data_hash.txt', 'r') as f:
            last_hash = f.read()
    except FileNotFoundError:
        last_hash = None

    if current_hash == last_hash:
        print("Training data has not changed. Loading existing data...")
        doc_bin = DocBin().from_disk(SPACY_DATA_PATH)
        examples = []  # Load examples from doc_bin if necessary
    else:
        print("Training data has changed. Converting data now...")
        train_data = load_data(CONVERTED_DATA_PATH, FOLDER)
        doc_bin, examples = convert_to_spacy_format(train_data)
        doc_bin.to_disk(SPACY_DATA_PATH)
        # Save the new hash to track future changes
        if current_hash is not None:
            with open('last_train_data_hash.txt', 'w') as f:
                f.write(current_hash)

else:
    print("Converted data does not exist. Converting data now...")
    train_data = load_data(CONVERTED_DATA_PATH, FOLDER)
    doc_bin, examples = convert_to_spacy_format(train_data)
    doc_bin.to_disk(SPACY_DATA_PATH)
    # Save the hash for the first time
    current_hash = hash_train_data(TRAIN_DATA_PATH)
    if current_hash is not None:
        with open('last_train_data_hash.txt', 'w') as f:
            f.write(current_hash)
    else:
        print("Unable to save the hash since the training data file does not exist.")

def train_spacy_model():
    """Train the spaCy model with the given examples."""
    print("\nStarting model training...")
    optimizer = nlp.begin_training()
    
    for epoch in range(5):  
        random.shuffle(examples)
        losses = {}
        
        for example in examples:
            index = example.reference._.get("index")
            if index is not None and index % (len(examples) // 5) == 0:
                print(f"\nTraining example: '{example.reference.text[:50]}...'")
            
            nlp.update([example], drop=0.2, losses=losses, sgd=optimizer)
        
        print(f"\nEpoch {epoch + 1}, Losses: {losses}")
        print("----" * 10)

    nlp.to_disk(MODEL_SAVE_PATH)
    print(f"Model saved to {MODEL_SAVE_PATH}")

# Check entity alignment for the training data
for entry in load_data(CONVERTED_DATA_PATH, FOLDER):
    text = entry["text"]
    entities = [(ent["start"], ent["end"], ent["label"]) for ent in entry.get("entities", [])]
    check_entity_alignment(nlp, text, entities)

train_spacy_model()

# Load the trained model for predictions
nlp = spacy.load(MODEL_SAVE_PATH)

def inspect_model_predictions(text):
    """Inspect model predictions for the given text."""
    doc = nlp(text)
    print("\nOriginal Text:")
    print(f"'{text}'\n")
    print("Token Predictions:")
    print(f"{'Token':<15}{'Predicted Label':<20}{'BILUO Tag':<20}")
    print("-" * 50)
    for token in doc:
        print(f"{token.text:<15}{token.ent_type_ if token.ent_type_ else 'O':<20}{token.ent_iob_ if token.ent_type_ else 'O':<20}")


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
