# app/python/ai_processing/job_description_extraction/train_job_description_extraction.py
import spacy
import os
from spacy.training import iob_to_biluo
from app.python.ai_processing.utils.label_mapping import get_label_list
from app.python.ai_processing.utils.data_handler import load_data, load_spacy_model
from app.python.ai_processing.utils.logger import (
    GREEN,
    RED,
    RESET,
    configure_logging,
    configure_warnings,
)
from app.python.ai_processing.utils.spacy_utils import handle_spacy_data
from app.python.ai_processing.utils.trainer import train_spacy_model
from app.python.ai_processing.utils.utils import calculate_entity_indices, print_data_with_entities
from app.python.ai_processing.utils.validation_utils import evaluate_model, validate_entities
from app.python.ai_processing.utils.data_handler import project_root
from transformers import LongformerTokenizer, LongformerModel

configure_warnings()
configure_logging()

FOLDER = "job_description_extraction"
BASE_DIR = os.path.join(project_root, FOLDER)

CONVERTED_FILE = "train_data_spacy.json"
CONVERTED_FILE_PATH = os.path.join(BASE_DIR, "data", CONVERTED_FILE)
MODEL_SAVE_PATH = os.path.join(BASE_DIR, "model", "spacy_job_description_ner_model")
SPACY_DATA_PATH = os.path.join(BASE_DIR, "data", "train.spacy")

# updated_data = calculate_entity_indices(train_data)
# print_data_with_entities(updated_data)

tokenizer = LongformerTokenizer.from_pretrained("allenai/longformer-base-4096")
transformer = LongformerModel.from_pretrained("allenai/longformer-base-4096")

MAX_SEQ_LENGTH = 4096

converted_data = load_data(CONVERTED_FILE, FOLDER)
nlp = load_spacy_model(MODEL_SAVE_PATH, MAX_SEQ_LENGTH, model_name="allenai/longformer-base-4096")

if "ner" not in nlp.pipe_names:
    ner = nlp.add_pipe("ner")
    print(f"{RED}Added NER pipe to blank model: {nlp.pipe_names}{RESET}")

    for label in get_label_list(entity_type="job_description"):
        ner.add_label(label)

    spacy.tokens.Doc.set_extension("index", default=None, force=True)
    doc_bin, examples = handle_spacy_data(
        SPACY_DATA_PATH,
        CONVERTED_FILE,
        FOLDER,
        nlp,
        tokenizer,
        MAX_SEQ_LENGTH,
        transformer,
    )

    nlp.initialize(get_examples=lambda: examples)

    os.makedirs(MODEL_SAVE_PATH, exist_ok=True)
    nlp.to_disk(MODEL_SAVE_PATH)
    print(f"{GREEN}Model saved to {MODEL_SAVE_PATH} with NER component added.{RESET}")
else:
    ner = nlp.get_pipe("ner")
    print(f"{GREEN}NER pipe already exists in blank model: {nlp.pipe_names}{RESET}")

    doc_bin, examples = handle_spacy_data(
        SPACY_DATA_PATH,
        CONVERTED_FILE,
        FOLDER,
        nlp,
        tokenizer,
        MAX_SEQ_LENGTH,
        transformer,
    )

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
# validate_entities(converted_data, nlp)


# ------------------- TEST EXAMPLES -------------------
def convert_example_to_biluo(text):
    """Convert model predictions for the given text to BILUO format."""
    tokens = tokenizer(
        text,
        max_length=MAX_SEQ_LENGTH,
        truncation=True,
        padding="max_length",
        return_tensors="pt",
    )

    decoded_text = tokenizer.decode(tokens["input_ids"][0], skip_special_tokens=True)

    doc = nlp(decoded_text)

    iob_tags = [
        token.ent_iob_ + "-" + token.ent_type_ if token.ent_type_ else "O"
        for token in doc
    ]
    biluo_tags = iob_to_biluo(iob_tags)

    return doc, biluo_tags


def inspect_job_description_predictions(text):
    """Inspect model predictions for job description text."""
    doc, biluo_tags = convert_example_to_biluo(text)

    print("\nOriginal Text:")
    print(f"'{text}'\n")
    print("Token Predictions:")
    print(f"{'Token':<15}{'Predicted Label':<20}{'BILUO Tag':<20}")
    print("-" * 50)

    for token, biluo_tag in zip(doc, biluo_tags):
        predicted_label = token.ent_type_ if token.ent_type_ else "O"
        print(f"{token.text:<15}{predicted_label:<20}{biluo_tag:<20}")


test_texts = [
    "We dramatically improve lives, by letting healthcare professionals turn extra time and ambition into career growth and financial opportunity.  This position requires 5+ years of experience in project management and a proven track record.",
    "There has never been a more exciting time to join our growing team and help us serve even more healthcare professionals and healthcare facilities, who can then better serve patients. Compensation includes a salary range of $100,000 to $120,000 plus benefits.",
    "Included Health is a new kind of healthcare company, delivering integrated virtual care and navigation. We’re on a mission to raise the standard of healthcare for everyone. Candidates must be proficient in data analysis and possess strong communication skills.",
    "Included Health considers all qualified applicants in accordance with the San Francisco Fair Chance Ordinance. Responsibilities include providing technical guidance and leading cross-functional teams.",
    "The ideal candidate should hold a Master's degree in a relevant field.",
]

for text in test_texts:
    inspect_job_description_predictions(text)
