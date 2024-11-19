# app/python/job_description_extraction/train_job_description_extraction.py
import spacy
import os
from spacy.training import iob_to_biluo
from app.python.utils.label_mapping import get_label_list
from app.python.utils.data_handler import load_data, load_spacy_model
from app.python.utils.logger import GREEN, RED, RESET, configure_logging, configure_warnings
from app.python.utils.spacy_utils import   handle_spacy_data
from app.python.utils.trainer import train_spacy_model
from app.python.utils.utils import calculate_entity_indices, print_data_with_entities
from app.python.utils.validation_utils import evaluate_model
from app.python.utils.data_handler import project_root
from transformers import LongformerTokenizer, LongformerModel

configure_warnings()
configure_logging()

FOLDER = "job_description_extraction"
BASE_DIR = os.path.join(project_root, FOLDER)

TRAIN_DATA_FILE = "train_data.json"
CONVERTED_FILE = "train_data_spacy.json"
CONVERTED_FILE_PATH = os.path.join(BASE_DIR, "data", CONVERTED_FILE)
MODEL_SAVE_PATH = os.path.join(BASE_DIR, "model", "spacy_job_description_ner_model")
SPACY_DATA_PATH = os.path.join(BASE_DIR, "data", "train.spacy")

train_data = load_data(TRAIN_DATA_FILE, FOLDER)
# updated_data = calculate_entity_indices(train_data)
# print_data_with_entities(updated_data)

tokenizer = LongformerTokenizer.from_pretrained("allenai/longformer-base-4096")
transformer = LongformerModel.from_pretrained("allenai/longformer-base-4096")


# tokens = tokenizer(text, return_tensors="pt", max_length=4096, truncation=True)
# outputs = transformer(**tokens)

MAX_SEQ_LENGTH = 4096

converted_data = load_data(CONVERTED_FILE, FOLDER)
nlp = load_spacy_model(MODEL_SAVE_PATH, MAX_SEQ_LENGTH)

if "ner" not in nlp.pipe_names:
    ner = nlp.add_pipe("ner")
    print(f"{RED}Added NER pipe to blank model: {nlp.pipe_names}{RESET}")

    for label in get_label_list(entity_type="job_description"):
        ner.add_label(label)

    spacy.tokens.Doc.set_extension("index", default=None, force=True)
    doc_bin, examples = handle_spacy_data(SPACY_DATA_PATH, CONVERTED_FILE, FOLDER, TRAIN_DATA_FILE, nlp, tokenizer, MAX_SEQ_LENGTH)

    nlp.initialize(get_examples=lambda: examples)

    os.makedirs(MODEL_SAVE_PATH, exist_ok=True)
    nlp.to_disk(MODEL_SAVE_PATH)
    print(f"{GREEN}Model saved to {MODEL_SAVE_PATH} with NER component added.{RESET}")
else:
    ner = nlp.get_pipe("ner")
    print(f"{GREEN}NER pipe already exists in blank model: {nlp.pipe_names}{RESET}")

    doc_bin, examples = handle_spacy_data(SPACY_DATA_PATH, CONVERTED_FILE, FOLDER, TRAIN_DATA_FILE, nlp, tokenizer, MAX_SEQ_LENGTH)

    # for example in examples[:5]:   
    #     print(f"Text: {example.reference.text}")
    #     print("Entities:")
    #     for ent in example.reference.ents:
    #         print(f"  - Text: '{ent.text}', Start: {ent.start_char}, End: {ent.end_char}, Label: {ent.label_}")

# if examples: 
#     for example in examples:
#         print(f"\nText: '{example.reference.text}'")
#         print("Entities after initialization:")
#         for ent in example.reference.ents:
#             print(f"  - Text: '{ent.text}', Start: {ent.start_char}, End: {ent.end_char}, Label: {ent.label_}")

# ------------------- TRAIN MODEL -------------------
train_spacy_model(MODEL_SAVE_PATH, nlp, examples)


# ------------------- VALIDATE TRAINER -------------------
evaluate_model(nlp, converted_data)


# ------------------- TEST EXAMPLES -------------------
# def inspect_job_description_predictions(text, nlp, tokenizer, max_seq_length=4096):
#     """Inspect model predictions for job description text."""
#     # Tokenize the text with the long transformer's tokenizer
#     tokens = tokenizer(
#         text,
#         max_length=max_seq_length,
#         truncation=True,
#         padding="max_length",
#         return_tensors="pt",
#     )
    
#     # Convert tokens back to text for spaCy model
#     decoded_text = tokenizer.decode(tokens["input_ids"][0], skip_special_tokens=True)
    
#     # Process the text with the spaCy model
#     doc = nlp(decoded_text)
    
#     print("\nOriginal Text:")
#     print(f"'{text}'\n")
#     print("Predicted Entities:")
#     print(f"{'Entity Text':<40}{'Start':<10}{'End':<10}{'Label':<20}")
#     print("-" * 80)
#     for ent in doc.ents:
#         print(f"{ent.text:<40}{ent.start_char:<10}{ent.end_char:<10}{ent.label_:<20}")

# # Example Predictions
# print("\nExample Prediction:")
# inspect_job_description_predictions(
#     "The Senior Technical Engagement Manager oversees project timelines, "
#     "status updates, and provides day-to-day operational leadership.",
#     nlp,
#     tokenizer,
# )

# # Test texts
# test_texts = [
#     "This position requires 5+ years of experience in project management and a proven track record.",
#     "Compensation includes a salary range of $100,000 to $120,000 plus benefits.",
#     "Candidates must be proficient in data analysis and possess strong communication skills.",
#     "Responsibilities include providing technical guidance and leading cross-functional teams.",
#     "The ideal candidate should hold a Master's degree in a relevant field.",
# ]

# for text in test_texts:
#     print(f"\nTesting text: '{text}'")
#     inspect_job_description_predictions(text, nlp, tokenizer)