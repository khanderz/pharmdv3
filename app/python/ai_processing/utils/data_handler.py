# app/python/ai_processing/utils/data_handler.py
import hashlib
import json
import os
import spacy
from app.python.ai_processing.utils.logger import BLUE, GREEN, RED, RESET

project_root = os.path.abspath(
    os.path.join(os.path.dirname(__file__), "../../..", "python", "ai_processing")
)


def load_spacy_model(
    MODEL_SAVE_PATH,
    MAX_SEQ_LENGTH=None,
    model_name="roberta-base",
    scispacy_model_name=None,
):    
    """
    Load an existing spaCy or SciSpacy model, or initialize a new transformer-based model.

    Args:
        MODEL_SAVE_PATH (str): Path to the saved model.
        MAX_SEQ_LENGTH (int, optional): Maximum sequence length for the tokenizer. Defaults to 512 for RoBERTa.
        model_name (str, optional): Name of the Hugging Face transformer model. Defaults to "roberta-base".
        scispacy_model_name (str, optional): Name of the SciSpacy model. Defaults to "en_core_sci_lg".

    Returns:
        spacy.Language: Loaded or initialized spaCy or SciSpacy model.
    """
    full_path = os.path.join(project_root, MODEL_SAVE_PATH)

    if os.path.exists(full_path):
        print(f"{BLUE}Loading model {model_name} with length {MAX_SEQ_LENGTH} {RESET}")
        nlp = spacy.load(full_path)

    if model_name.lower() == "scispacy":
        print(f"{GREEN}Loading SciSpacy model: {scispacy_model_name}...{RESET}")
        return spacy.load(scispacy_model_name)

    else:
        print(f"{RED}No existing model found. Initializing new model...{RESET}")

        default_max_length = (
            512 if "roberta" in model_name or "bert" in model_name else 4096
        )

        print(f"{BLUE}creating model {model_name} with length {MAX_SEQ_LENGTH} scispacy_model_name: {scispacy_model_name}  {RESET}")
        nlp = spacy.blank("en")
        nlp.add_pipe(
            "transformer",
            config={
                "model": {
                    "@architectures": "spacy-transformers.TransformerModel.v1",
                    "name": model_name,
                    "tokenizer_config": {
                        "max_length": MAX_SEQ_LENGTH or default_max_length,
                        "truncation": True,
                        "padding": "max_length",
                    },
                    "get_spans": {"@span_getters": "spacy-transformers.doc_spans.v1"},
                }
            },
            last=True,
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
    full_path = os.path.join(project_root, folder, "data", file_path)

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
