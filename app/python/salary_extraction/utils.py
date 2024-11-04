# app/python/salary_extraction/utils.py
import re

def clean_text(text):
    """
    Cleans text by removing unnecessary whitespace and special characters.
    """
    return re.sub(r'\s+', ' ', text).strip()

def load_training_data(filepath):
    """
    Loads training data from a file.
    """
    # Implement loading logic here
    return []
