# app/python/salary_extraction/extract_salary.py
import spacy
import re
import json

# Load pre-trained NER model
MODEL_PATH = "app/python/salary_extraction/model/salary_ner_model"
nlp = spacy.load(MODEL_PATH)

def extract_salary_from_text(text):
    """
    Detects salary ranges in the given job post text.
    Returns the min and max salary if found, along with the interval and currency.
    """
    doc = nlp(text)
    min_salary, max_salary, interval, currency = None, None, None, None
    
    # Define regex patterns for salary and currency
    salary_pattern = re.compile(r'(\d{1,3}(?:,\d{3})*(?:k|K)?)')
    interval_pattern = re.compile(r'\b(annually|monthly|weekly|daily|hourly)\b', re.IGNORECASE)
    currency_pattern = re.compile(r'\b(USD|GBP|EUR|JPY|INR)\b', re.IGNORECASE)

    # Extract salary ranges
    amounts = re.findall(salary_pattern, text)
    if len(amounts) >= 1:
        min_salary = int(amounts[0].replace(",", "").replace("k", "000"))
    if len(amounts) >= 2:
        max_salary = int(amounts[1].replace(",", "").replace("k", "000"))
    
    # Extract interval and currency 
    interval_match = interval_pattern.search(text)
    if interval_match:
        interval = interval_match.group(0)
    currency_match = currency_pattern.search(text)
    if currency_match:
        currency = currency_match.group(0)

    return {"min_salary": min_salary, "max_salary": max_salary, "interval": interval, "currency": currency}


if __name__ == "__main__":
    sample_text = "The estimated salary range is between $130,000 and $160,000 per year."
    
    result = extract_salary_from_text(sample_text)
    print(json.dumps(result))
