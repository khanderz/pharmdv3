import spacy
import re
import sys
import json
import base64

# Load spaCy model with NER capability
nlp = spacy.load("en_core_web_sm")

def parse_currency_data(currency_data):
    """
    Parses a comma-separated string of currency mappings into a dictionary.
    Expected format: "symbol:code"
    """
    currency_map = {}
    for pair in currency_data.split(','):
        try:
            symbol, code = pair.split(':')
            currency_map[symbol] = code
        except ValueError:
            print(f"Warning: Invalid currency pair '{pair}' in currency data.")
    return currency_map

def extract_salary_from_text(text, currency_map, interval_data):
    """
    Extracts salary range, interval, and currency code from the provided job description text.
    """
    intervals = interval_data.split(',')
    interval_synonyms = {
        'Annually': ['annually', 'year', 'yearly', 'per year', 'a year'],
        'Monthly': ['month', 'monthly', 'per month', 'a month'],
        'Weekly': ['week', 'weekly', 'per week', 'a week'],
        'Daily': ['day', 'daily', 'per day', 'a day'],
        'Hourly': ['hour', 'hourly', 'per hour', 'an hour'],
        'Bi-weekly': ['bi-weekly', 'every two weeks'],
        'Quarterly': ['quarter', 'quarterly']
    }

    salary_pattern = re.compile(r'(\$\d{1,3}(?:,\d{3})*(?:k|K)?(?:\s?-\s?\$\d{1,3}(?:,\d{3})*(?:k|K)?)?)')

    interval_pattern = re.compile(
        r'\b(' + '|'.join(
            [syn for interval in intervals for syn in interval_synonyms.get(interval, [interval])]
        ) + r')\b', re.IGNORECASE
    )

    currency_symbol = next((symbol for symbol in currency_map if symbol in text), '$')
    currency_code = currency_map.get(currency_symbol, 'USD')

    salaries = []
    intervals_found = []
    for match in re.finditer(salary_pattern, text):
        salary_text = match.group(0)
        
        vicinity_start = max(0, match.start() - 50)
        vicinity_end = min(len(text), match.end() + 50)
        vicinity_text = text[vicinity_start:vicinity_end]

        interval_match = interval_pattern.search(vicinity_text)
        interval = 'Annually'  # Default to Annually if no match
        if interval_match:
            matched_interval = interval_match.group(0).lower()
            for standard_interval, synonyms in interval_synonyms.items():
                if matched_interval in [s.lower() for s in synonyms] and standard_interval in intervals:
                    interval = standard_interval
                    break
        intervals_found.append(interval)

        amounts = re.findall(r'\d{1,3}(?:,\d{3})*', salary_text)
        amounts = [int(amount.replace(",", "")) * (1000 if 'k' in salary_text.lower() else 1) for amount in amounts]
        if len(amounts) == 2:
            salaries.append((amounts[0], amounts[1]))
        elif len(amounts) == 1:
            salaries.append((amounts[0], amounts[0]))

    if salaries and intervals_found:
        min_salary = min(s[0] for s in salaries)
        max_salary = max(s[1] for s in salaries)
        interval = intervals_found[0]  
        return f"{min_salary}, {max_salary}, {interval}, {currency_code}"
    return ""

if __name__ == "__main__":
    encoded_data = sys.argv[1]
    json_data = base64.b64decode(encoded_data).decode('utf-8')

    try:
        data = json.loads(json_data)
    except json.JSONDecodeError:
        print("Error: Unable to decode JSON from input.")
        sys.exit(1)

    text = data.get('text', '')
    currency_data = data.get('currency_data', '')
    interval_data = data.get('interval_data', '')

    currency_map = parse_currency_data(currency_data)

    result = extract_salary_from_text(text, currency_map, interval_data)

    if result:
        print(result)
    else:
        print("")
