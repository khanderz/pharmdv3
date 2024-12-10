# app/python/ai_processing/job_description_extraction/train_job_description_extraction.py
import base64
import json
import sys
import warnings
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

TRAIN_DATA_FILE = "train_data.json"
CONVERTED_FILE = "train_data_spacy.json"
CONVERTED_FILE_PATH = os.path.join(BASE_DIR, "data", CONVERTED_FILE)
MODEL_SAVE_PATH = os.path.join(BASE_DIR, "model", "spacy_job_description_ner_model")
SPACY_DATA_PATH = os.path.join(BASE_DIR, "data", "train.spacy")

# train_data = load_data(TRAIN_DATA_FILE, FOLDER)
# updated_data = calculate_entity_indices(train_data)
# print_data_with_entities(updated_data)

tokenizer = LongformerTokenizer.from_pretrained("allenai/longformer-base-4096")
transformer = LongformerModel.from_pretrained("allenai/longformer-base-4096")

MAX_SEQ_LENGTH = 4096

converted_data = load_data(CONVERTED_FILE, FOLDER)
nlp = load_spacy_model(
    MODEL_SAVE_PATH, MAX_SEQ_LENGTH, model_name="allenai/longformer-base-4096"
)

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
# train_spacy_model(MODEL_SAVE_PATH, nlp, examples, resume=True)


# ------------------- VALIDATE TRAINER -------------------
# evaluate_model(nlp, converted_data)
validate_entities(converted_data, nlp)


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

    # print("Token Predictions:")
    # print(f"{'Token':<15}{'Predicted Label':<20}{'BILUO Tag':<20}")
    # print("-" * 50)

    entity_data = {}
    current_entity = None
    current_tokens = []

    for token, biluo_tag in zip(doc, biluo_tags):
        if biluo_tag != "O":
            entity_label = biluo_tag.split("-")[-1]

            if biluo_tag.startswith("B-"):
                if current_entity:
                    if current_entity not in entity_data:
                        entity_data[current_entity] = []
                    entity_data[current_entity].append(" ".join(current_tokens))

                current_entity = entity_label
                current_tokens = [token.text]

            elif biluo_tag.startswith("I-"):
                current_tokens.append(token.text)

            elif biluo_tag.startswith("L-"):
                current_tokens.append(token.text)
                if current_entity:
                    if current_entity not in entity_data:
                        entity_data[current_entity] = []
                    entity_data[current_entity].append(" ".join(current_tokens))
                current_entity = None
                current_tokens = []

            elif biluo_tag.startswith("U-"):
                if entity_label not in entity_data:
                    entity_data[entity_label] = []
                entity_data[entity_label].append(token.text)
        else:
            if current_entity:
                if current_entity not in entity_data:
                    entity_data[current_entity] = []
                entity_data[current_entity].append(" ".join(current_tokens))
                current_entity = None
                current_tokens = []

    if current_entity:
        if current_entity not in entity_data:
            entity_data[current_entity] = []
        entity_data[current_entity].append(" ".join(current_tokens))

    return entity_data


# test_texts = [
#     "We dramatically improve lives, by letting healthcare professionals turn extra time and ambition into career growth and financial opportunity.  This position requires 5+ years of experience in project management and a proven track record.",
#     "There has never been a more exciting time to join our growing team and help us serve even more healthcare professionals and healthcare facilities, who can then better serve patients. Compensation includes a salary range of $100,000 to $120,000 plus benefits.",
#     "Included Health is a new kind of healthcare company, delivering integrated virtual care and navigation. We’re on a mission to raise the standard of healthcare for everyone. Candidates must be proficient in data analysis and possess strong communication skills.",
#     "Included Health considers all qualified applicants in accordance with the San Francisco Fair Chance Ordinance. Responsibilities include providing technical guidance and leading cross-functional teams.",
#     "The ideal candidate should hold a Master's degree in a relevant field.",
# ]

# test_texts = [
#     """&lt;div class=&quot;content-intro&quot;&gt;&lt;p&gt;&lt;strong&gt;&lt;em&gt;Attention recruitment agencies:&lt;/em&gt;&lt;/strong&gt;&lt;em&gt; 4DMT is a clinical-stage biotherapeutics company harnessing the power of directed evolution for targeted genetic medicines. We seek to unlock the full potential of gene therapy using our platform, Therapeutic Vector Evolution (TVE), which combines the power of directed evolution with our approximately one billion synthetic AAV capsid-derived sequences to invent evolved vectors for use in our products. We believe key features of our targeted and evolved vectors will help us create targeted product candidates with improved therapeutic profiles. These profiles will allow us to treat a broad range of large market diseases, unlike most current genetic medicines that generally focus on rare or small market diseases. &amp;nbsp;&lt;/p&gt;\n&lt;p&gt;Company Differentiators:&amp;nbsp;&lt;/p&gt;\n&lt;p&gt;• &amp;nbsp; &amp;nbsp;Fully integrated clinical-phase company with internal manufacturing&lt;br&gt;• &amp;nbsp; &amp;nbsp;Demonstrated ability to move rapidly from idea to IND&lt;br&gt;• &amp;nbsp; &amp;nbsp;Five candidate products in the clinic and two declared pre-clinical programs&lt;br&gt;• &amp;nbsp; &amp;nbsp;Robust technology and IP foundation, including our TVE and manufacturing platforms&lt;br&gt;• &amp;nbsp; &amp;nbsp;Initial product safety and efficacy data substantiates the value of our platforms&lt;br&gt;• &amp;nbsp; &amp;nbsp;Opportunities to expand to other indications and modalities within genetic medicine&lt;/p&gt;&lt;/div&gt;&lt;p&gt;&lt;strong&gt;Position Summary:&amp;nbsp;&lt;/strong&gt;&amp;nbsp;&lt;/p&gt;\n&lt;p&gt;The Associate Director of Clinical Quality Assurance (CQA) will be responsible for supporting Quality Assurance oversight of 4DMT sponsored clinical studies, ensuring studies are executed in compliance with all applicable international regulatory requirements for Good Clinical Practice (GCP).&amp;nbsp;&amp;nbsp;This position reports to the Senior Director, GCP Compliance and Quality Systems and contributes to the development, implementation, and successful execution of the CQA mission, objectives, and strategic plan.&lt;/p&gt;\n&lt;p&gt;&lt;strong&gt;Responsibilities:&lt;/strong&gt;&amp;nbsp;&lt;/p&gt;\n&lt;p&gt;&lt;strong&gt;Provide Quality oversight for multiple 4DMT Clinical Studies, including the following study-specific activities:&lt;/strong&gt;&lt;/p&gt;\n&lt;ul&gt;\n&lt;li&gt;Partner with Clinical stakeholder to support timely identification, escalation, investigation, documentation, and resolution of GCP-related quality events, acting at all times with an appropriate sense of urgency.&lt;/li&gt;\n&lt;li&gt;Provide GCP guidance to clinical study teams, including via attendance at Study team meetings, with support from Sr. Director GCP Compliance.&lt;/li&gt;\n&lt;li&gt;Ensure principles of Risk Management are applied to Clinical Studies per ICH E6&lt;/li&gt;\n&lt;li&gt;Coordinate GCP Compliance audits of high-risk clinical vendors/sites, including clinical investigator sites.&lt;/li&gt;\n&lt;li&gt;Ensure audit findings are communicated to audit stakeholders and collaborate with auditees and vendors to track, review, approve, and assess the adequacy of&lt;/li&gt;\n&lt;li&gt;Perform Clinical Document reviews, ensuring the quality, accuracy and completeness of various documents, including as applicable Clinical Protocols, IBs, DSURs, Module 2.6 Tabulated and Written Summaries, and Integrated&lt;/li&gt;\n&lt;/ul&gt;\n&lt;p&gt;&lt;strong&gt;Support investigation and management of specific Clinical Study Quality Events as assigned:&lt;/strong&gt;&lt;/p&gt;\n&lt;ul&gt;\n&lt;li&gt;Monitor, track, and facilitate the completion of formal corrective and preventive actions (CAPAs) to address identified&amp;nbsp;Clinical Study Quality Events, including potential serious breaches of GCP.&amp;nbsp;&lt;/li&gt;\n&lt;/ul&gt;\n&lt;p&gt;&lt;strong&gt;Support a quality-focused work environment in Clinical that fosters learning, respect, open communication, collaboration, integration, and teamwork:&lt;/strong&gt;&lt;/p&gt;\n&lt;ul&gt;\n&lt;li&gt;Drive the development and continuous improvement of the Clinical Quality Management System through the development / refinement of Clinical QA processes / initiatives as assigned&lt;/li&gt;\n&lt;/ul&gt;\n&lt;p&gt;&lt;strong&gt;Partner with GMP Quality and Clinical Operations teams to facilitate the investigation of clinical supply quality issues such as temperature excursions, product complaints and deviations reported from clinical sites.&lt;/strong&gt;&lt;/p&gt;\n&lt;p&gt;&lt;strong&gt;&amp;nbsp;&lt;/strong&gt;&lt;/p&gt;\n&lt;p&gt;&lt;strong&gt;&lt;u&gt;QUALIFICATIONS:&amp;nbsp;&lt;/u&gt;&lt;/strong&gt;&lt;/p&gt;\n&lt;ul&gt;\n&lt;li&gt;B.S./B.A. in a science or related life science field or equivalent; advanced scientific degree preferred.&lt;/li&gt;\n&lt;li&gt;8+ years working within a regulated environment such as Regulatory, Quality, Pharmacovigilance or Clinical Development / Operations within the Biotech or similar industry&lt;/li&gt;\n&lt;li&gt;Proven experience with GCP Quality Management Systems, audit support, and quality oversight of global clinical studies, including knowledge of quality investigation / root cause analysis techniques&lt;/li&gt;\n&lt;li&gt;Minimum of 4 years of experience in a role including responsibility for providing GCP oversight of clinical study activities, preferably at a clinical study sponsor&lt;/li&gt;\n&lt;li&gt;In-depth understanding of GCP requirements for investigational products&lt;/li&gt;\n&lt;li&gt;Extensive practical experience and understanding of clinical quality assurance as applied throughout the clinical development life-cycle&lt;/li&gt;\n&lt;li&gt;Excellent communication skills, both oral and written&lt;/li&gt;\n&lt;li&gt;Excellent interpersonal skills, collaborative approach essential&lt;/li&gt;\n&lt;li&gt;Comfortable in a fast-paced small company environment with minimal direction and able to adjust workload based upon changing priorities&lt;/li&gt;\n&lt;/ul&gt;\n&lt;p&gt;Base salary compensation range: $152,000 - $199,000&lt;/p&gt;\n&lt;p&gt;"""
# ]

# for text in test_texts:
#     inspect_job_description_predictions(text)

def main(encoded_data, validate_flag, data=None):
    if data:
        if isinstance(data, str):
            data = json.loads(data)

        updated_data = calculate_entity_indices([data])
        print_data_with_entities(updated_data, file=sys.stderr)
        return

    if validate_flag:
        print("\nValidating entities of the converted data only...", file=sys.stderr)
        result = validate_entities(converted_data, nlp)
        if result == "Validation passed for all entities.":

            result = {
                "status": "success",
                "message": "Validation passed for all entities",
            }
        sys.stdout.write(json.dumps(result) + "\n")

        return

    input_data = json.loads(base64.b64decode(encoded_data).decode("utf-8"))
    text = input_data.get("text", "")
    print(f"\nText: {text}", file=sys.stderr)

    print("\nRunning benefits extraction model inspection...", file=sys.stderr)
    predictions = inspect_job_description_predictions(text)

    output = {
        "status": "success" if predictions else "failure",
        "entities": predictions,
    }

    sys.stdout.write(json.dumps(output) + "\n")


# if __name__ == "__main__":
#     warnings.filterwarnings("ignore")
#     print(
#         "\nRunning job benefits extraction model inspection script...", file=sys.stderr
#     )
#     try:
#         encoded_data = sys.argv[1]
#         validate_flag = sys.argv[2].lower() == "true" if len(sys.argv) > 2 else False
#         data = sys.argv[3] if len(sys.argv) > 3 else None

#         main(encoded_data, validate_flag, data)
#     except Exception as e:
#         error_response = {"status": "error", "message": str(e)}
#         sys.stdout.write(json.dumps(error_response) + "\n")
#         sys.exit(1)