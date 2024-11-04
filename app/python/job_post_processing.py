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
    print(f"Currency Data: {currency_data}----------------------")
    currency_map = {}

    for pair in currency_data.split(','):
        print(f"Pair: {pair}")
        try:
            symbol, code = pair.split(':')
            symbol = symbol.strip()
            code = code.strip()
            currency_map[symbol] = code
        except ValueError:
            print(f"Warning: Invalid currency pair '{pair}' in currency data.")
    return currency_map


def extract_salary_from_text(text, currency_map, interval_data):
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

    salaries = []
    intervals_found = []
    currency_symbol = None  # Only set if a salary is found

    for match in re.finditer(salary_pattern, text):
        salary_text = match.group(0)
        
        # Set the currency symbol if a salary is found
        if not currency_symbol:
            currency_symbol = next((symbol for symbol in currency_map if symbol in salary_text), '$')

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
        currency_code = currency_map.get(currency_symbol, 'USD')
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
    print(f"Text: {text}, Currency Data: {currency_data}, Interval Data: {interval_data}")
    currency_map = parse_currency_data(currency_data)

    # print(f"Currency Map: {currency_map}, text: {text}, interval_data: {interval_data}, currency data: {currency_data}")

    # print(extract_salary_from_text(text, currency_map, interval_data))


