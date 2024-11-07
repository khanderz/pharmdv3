# app/python/salary_extraction/train_model.py

import spacy
import random
import spacy_transformers  
import os
import warnings
import logging

from app.python.utils.label_mapping import get_label_list
from app.python.utils.data_handler import generate_path, load_data
from app.python.utils.spacy_utils import check_entity_alignment, convert_bio_to_spacy_format, convert_to_spacy_format

warnings.filterwarnings("ignore", message="`resume_download` is deprecated")
warnings.filterwarnings("ignore", message="Some weights of the model checkpoint at roberta-base were not used")
warnings.simplefilter(action='ignore', category=FutureWarning)
warnings.filterwarnings("ignore", category=UserWarning) 

logging.getLogger("transformers").setLevel(logging.WARNING)
logging.getLogger("torch").setLevel(logging.WARNING)
logging.getLogger("transformers").setLevel(logging.ERROR)  
logging.getLogger("torch").setLevel(logging.ERROR)

folder = "salary_extraction"
train_data_path = "train_data.json"
converted_data_path = generate_path("train_data_spacy.json", folder)
model_save_path = "app/python/salary_extraction/model/spacy_salary_ner_model"

data = load_data(train_data_path, folder)

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
if not os.path.exists(converted_data_path):
    convert_bio_to_spacy_format(train_data_path, converted_data_path, folder, nlp)

for label in get_label_list():
    ner.add_label(label)

# Register extension for Doc to store indices
spacy.tokens.Doc.set_extension("index", default=None)

train_data = load_data(converted_data_path, folder)
doc_bin, examples = convert_to_spacy_format(train_data)
doc_bin.to_disk("app/python/salary_extraction/data/train.spacy")

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

    nlp.to_disk(model_save_path)
    print(f"Model saved to {model_save_path}")

for entry in train_data:
    text = entry["text"]
    entities = [(ent["start"], ent["end"], ent["label"]) for ent in entry.get("entities", [])]
    check_entity_alignment(nlp, text, entities)

train_spacy_model()

# Load the trained model for predictions
nlp = spacy.load(model_save_path)

def inspect_model_predictions(text):
    """Inspect model predictions for the given text."""
    doc = nlp(text)
    print("\nOriginal Text:")
    print(f"'{text}'\n")
    print("Token Predictions:")
    print(f"{'Token':<15}{'Predicted Label':<20}")
    print("-" * 50)
    for token in doc:
        print(f"{token.text:<15}{token.ent_type_ if token.ent_type_ else 'O':<20}")

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
