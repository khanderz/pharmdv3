# app/python/utils/data_handler.py
import hashlib
import json
import os
import spacy
from app.python.utils.logger import BLUE, RED, RESET

project_root = os.path.abspath(os.path.join(os.path.dirname(__file__), "../../..", "app", "python"))

def load_spacy_model(MODEL_SAVE_PATH):
    full_path = os.path.join(project_root, MODEL_SAVE_PATH)

    if os.path.exists(full_path):
        print(f"{BLUE}Loading existing model for further training...{RESET}")
        nlp = spacy.load(full_path)
        # nlp = spacy.blank("en")
    else:
        print(f"{RED}No existing model found. Initializing new model...{RESET}")
        nlp = spacy.blank("en")
        nlp.add_pipe(
            "transformer",
            config={
                "model": {
                    "@architectures": "spacy-transformers.TransformerModel.v1",
                    "name": "roberta-base",
                    "get_spans": {"@span_getters": "spacy-transformers.doc_spans.v1"},
                }
            },
        )
    return nlp    

def generate_path(file_name, folder):
    """Generate a full path to a file in a specified folder."""
    path = os.path.join(project_root, folder, "data", file_name)
    # print(f"{path}")
    return path

def load_data(json_file, folder):
    """Load JSON data from a specified file in a given folder."""
    train_data_path = generate_path(json_file, folder)

    # print(f"Loading data from {train_data_path}")

    try:
        with open(train_data_path, "r") as f:
            return json.load(f)
    except (FileNotFoundError, json.JSONDecodeError) as e:
        print(f"Error: {e}")
        return []


def hash_train_data(folder, file_path):
    """Calculate a hash of the training data to check for changes."""
    full_path = os.path.join(project_root, folder, 'data', file_path)
    
    if not os.path.exists(full_path):
        print(f"Warning: Training data file '{full_path}' does not exist.") 
        return None
    
    with open(full_path, "r") as f:
        return hashlib.md5(f.read().encode()).hexdigest()


# ------ for BIO format
# def create_tokenized_dataset(data):
#     dataset = Dataset.from_dict({
#         "text": [item["text"] for item in data],
#         "labels": [item["labels"] for item in data]
#     })
#     return dataset.map(tokenize_and_align_labels(data), batched=True)
