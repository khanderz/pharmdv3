# app/python/job_post_processing.py
import sys
import json
import base64
from salary_extraction.extract_salary import extract_salary_from_text

if __name__ == "__main__":
    encoded_data = sys.argv[1]
    data = json.loads(base64.b64decode(encoded_data).decode('utf-8'))
    text = data.get('text', '')

    result = extract_salary_from_text(text)
    
    print(json.dumps(result))
