# app/python/ai_processing/company_extraction/train_company_extraction.py

import spacy
import os
from spacy.training import iob_to_biluo
from app.python.ai_processing.utils.data_handler import load_data, load_spacy_model
from app.python.ai_processing.company_extraction.label_mapping import get_label_list
from app.python.ai_processing.utils.logger import (
    GREEN,
    RED,
    RESET,
    configure_logging,
    configure_warnings,
)
from app.python.ai_processing.utils.spacy_utils import handle_spacy_data
from app.python.ai_processing.utils.trainer import train_spacy_model
from app.python.ai_processing.utils.training_data_processor import fix_entity_offsets
from app.python.ai_processing.utils.utils import (
    calculate_entity_indices,
    print_data_with_entities,
)
from app.python.ai_processing.utils.validation_utils import (
    evaluate_model,
    validate_entities,
)
from app.python.ai_processing.utils.data_handler import project_root
from transformers import LongformerTokenizer, LongformerModel

configure_warnings()
configure_logging()

FOLDER = "company_extraction"
BASE_DIR = os.path.join(project_root, FOLDER)

TRAIN_DATA_FILE = "train_data.json"
CONVERTED_FILE = "train_data_spacy.json"
CONVERTED_FILE_PATH = os.path.join(BASE_DIR, "data", CONVERTED_FILE)
MODEL_SAVE_PATH = os.path.join(BASE_DIR, "model", "spacy_company_ner_model")
SPACY_DATA_PATH = os.path.join(BASE_DIR, "data", "train.spacy")

tokenizer = LongformerTokenizer.from_pretrained("allenai/longformer-base-4096")
transformer = LongformerModel.from_pretrained("allenai/longformer-base-4096")

MAX_SEQ_LENGTH = 4096

# train_data = load_data(TRAIN_DATA_FILE, FOLDER)
# updated_data = calculate_entity_indices(train_data)
# print_data_with_entities(updated_data)
# fix_entity_offsets(train_data, updated_data)

converted_data = load_data(CONVERTED_FILE, FOLDER)
nlp = load_spacy_model(
    MODEL_SAVE_PATH, MAX_SEQ_LENGTH, model_name="allenai/longformer-base-4096"
)

if "ner" not in nlp.pipe_names:
    ner = nlp.add_pipe("ner")
    print(f"{RED}Added NER pipe to blank model: {nlp.pipe_names}{RESET}")

    for label in get_label_list(entity_type="healthcare_domain"):
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
#             print(f"Entity: '{ent.text}', Label: '{ent.label_}'")

# ------------------- TRAIN MODEL -------------------
train_spacy_model(MODEL_SAVE_PATH, nlp, examples)


# ------------------- VALIDATE TRAINER -------------------
evaluate_model(nlp, converted_data)
# validate_entities(train_data, nlp)


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


def inspect_company_predictions(text):
    """Inspect model predictions for companies text."""
    doc, biluo_tags = convert_example_to_biluo(text)

    print("\nOriginal Text:")
    print(f"'{text}'\n")
    print("Token Predictions:")
    print(f"{'Token':<15}{'Predicted Label':<20}{'BILUO Tag':<20}")
    print("-" * 50)

    for token, biluo_tag in zip(doc, biluo_tags):
        predicted_label = token.ent_type_ if token.ent_type_ else "O"
        print(f"{token.text:<15}{predicted_label:<20}{biluo_tag:<20}")
    return doc, biluo_tags


test_texts = [
    "Ensysce Biosciences is a clinical stage biotechnology firm focused on developing innovative drug formulations that leverage nanotechnology to create safer prescription options aimed at reducing the risk of abuse and preventing overdose.",
    "Everlywell provides a convenient and comprehensive home health testing experience.",
    "Pathfinder® offers the world's first dynamic rigidizing overtube for endoscopy stability, managing loop formation and enhancing endoscope control during GI procedures.",
    "Sight Sciences focuses on delivering innovative and clinically validated therapies to eyecare providers, aiming to address the root causes of common eye diseases through less invasive and more intuitive solutions.",
    "Tempus is a leading technology company in precision medicine, utilizing AI to empower personalized cancer care through genomic sequencing and real-time data analysis.",
    "TytoCare offers innovative telehealth solutions that enable high-quality primary care from the comfort of home.",
    "Seneca Family of Agencies provides unconditional care and a comprehensive continuum of mental health and support services for children and families facing trauma, including in-home wraparound, foster care, adoption, crisis response, and therapeutic programs.",
    "a specialty pharmaceutical corporation dedicated to leading the way in the development and commercialization of infectious disease medicines for COVID-19, malaria, dengue, and other infectious diseases",
]

for text in test_texts:
    inspect_company_predictions(text)
