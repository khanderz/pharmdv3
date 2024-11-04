# app/python/salary_extraction/extract_salary.py
import spacy
import json
import base64
import sys
from app.python.salary_extraction.entity_processing import process_extracted_entities

MODEL_PATH = "app/python/salary_extraction/model/salary_ner_model"
nlp = spacy.load(MODEL_PATH)

def extract_salary_from_text(text):
    doc = nlp(text)
    # process_extracted_entities(doc)

    min_salary, max_salary, interval, currency = None, None, None, None

    for ent in doc.ents:
        print(ent.text, ent.label_, getattr(ent._, "currency_type", None), getattr(ent._, "interval_type", None))

        if ent.label_ == "SALARY":
            salary_text = ent.text
            # Extract numerical values and process salary ranges, interval, etc.
            # Your extraction logic for min_salary, max_salary, etc., goes here

    return {
        "min_salary": min_salary,
        "max_salary": max_salary,
        "interval": interval,
        "currency": currency
    }

if __name__ == "__main__":
    encoded_data = sys.argv[1]
    data = json.loads(base64.b64decode(encoded_data).decode("utf-8"))
    text = data.get("text", "")

    result = extract_salary_from_text(text)
    
    print(json.dumps(result))
