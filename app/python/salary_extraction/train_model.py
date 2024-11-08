# app/python/salary_extraction/train_model.py

import spacy
import random
import spacy_transformers  
import os
import warnings
import logging
from spacy.tokens import DocBin

from app.python.utils.label_mapping import get_label_list
from app.python.utils.data_handler import generate_path, load_data, hash_train_data
from app.python.utils.spacy_utils import  convert_bio_to_spacy_format, convert_to_spacy_format, handle_convert_to_spacy
from app.python.utils.validation_utils import check_entity_alignment

FOLDER = "salary_extraction"
BASE_DIR = os.path.join("app", "python", FOLDER)

TRAIN_DATA_FILE = "train_data.json"
CONVERTED_FILE = "train_data_spacy.json"
CONVERTED_FILE_PATH = os.path.join(BASE_DIR, "data", CONVERTED_FILE)
MODEL_SAVE_PATH = os.path.join(BASE_DIR, "model", "spacy_salary_ner_model")
SPACY_DATA_PATH = os.path.join(BASE_DIR, "data", "train.spacy")

warnings.filterwarnings("ignore", message="`resume_download` is deprecated")
warnings.filterwarnings("ignore", message="Some weights of the model checkpoint at roberta-base were not used")
warnings.simplefilter(action='ignore', category=FutureWarning)
warnings.filterwarnings("ignore", category=UserWarning) 

logging.getLogger("transformers").setLevel(logging.WARNING)
logging.getLogger("torch").setLevel(logging.WARNING)
logging.getLogger("transformers").setLevel(logging.ERROR)  
logging.getLogger("torch").setLevel(logging.ERROR)


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
if not os.path.exists(generate_path(CONVERTED_FILE, FOLDER)):
    convert_bio_to_spacy_format(TRAIN_DATA_FILE, FOLDER, nlp, CONVERTED_FILE_PATH)

# # Register extension for Doc to store indices
spacy.tokens.Doc.set_extension("index", default=None)
handle_convert_to_spacy(SPACY_DATA_PATH, CONVERTED_FILE, FOLDER, TRAIN_DATA_FILE)

# data = load_data(TRAIN_DATA_FILE, FOLDER)
# converted_data = load_data(CONVERTED_FILE, FOLDER)


# for label in get_label_list():
#     ner.add_label(label)



# doc_bin, examples = convert_to_spacy_format(converted_data)
# doc_bin.to_disk("app/python/salary_extraction/data/train.spacy")

# def train_spacy_model():
#     """Train the spaCy model with the given examples."""
#     print("\nStarting model training...")
#     optimizer = nlp.begin_training()
    
#     for epoch in range(5):  
#         random.shuffle(examples)
#         losses = {}
        
#         for example in examples:
#             index = example.reference._.get("index")
#             if index is not None and index % (len(examples) // 5) == 0:
#                 print(f"\nTraining example: '{example.reference.text[:50]}...'")
            
#             nlp.update([example], drop=0.2, losses=losses, sgd=optimizer)
        
#         print(f"\nEpoch {epoch + 1}, Losses: {losses}")
#         print("----" * 10)

#     nlp.to_disk(MODEL_SAVE_PATH)
#     print(f"Model saved to {MODEL_SAVE_PATH}")

# Check entity alignment for the training data
# for entry in converted_data:
#     print('entry--------------------' , entry)
#     text = entry["text"]
#     entities = [(ent["start"], ent["end"], ent["label"]) for ent in entry.get("entities", [])]
#     check_entity_alignment(nlp, text, entities)

# train_spacy_model()

# Load the trained model for predictions
# nlp = spacy.load(MODEL_SAVE_PATH)

# def inspect_model_predictions(text):
#     """Inspect model predictions for the given text."""
#     doc = nlp(text)
#     print("\nOriginal Text:")
#     print(f"'{text}'\n")
#     print("Token Predictions:")
#     print(f"{'Token':<15}{'Predicted Label':<20}{'BILUO Tag':<20}")
#     print("-" * 50)
#     for token in doc:
#         print(f"{token.text:<15}{token.ent_type_ if token.ent_type_ else 'O':<20}{token.ent_iob_ if token.ent_type_ else 'O':<20}")


# print("\nExample Prediction:")
# inspect_model_predictions("The salary is expected to be $100,000 annually in USD.")

# test_texts = [
#     "The annual salary is expected to be $120,000 USD.",
#     "Compensation ranges from €50,000 to €70,000 annually.",
#     "Base pay in Canada is CAD 60,000 per year.",
#     "This position offers a minimum salary of £45,000.",
#     "Contractor role with hourly rate of 25 AUD."
# ]

# for text in test_texts:
#     print(f"\nTesting text: '{text}'")
#     inspect_model_predictions(text)
