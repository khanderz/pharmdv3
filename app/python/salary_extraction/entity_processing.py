from app.models import JobSalaryCurrency, JobSalaryInterval

def get_currency_type(symbol):
    currency = JobSalaryCurrency.query.filter_by(currency_sign=symbol).first()
    return currency.currency_code if currency else None

def get_interval_type(interval_text):
    interval_phrases = {
        "Annually": ["annually", "annual", "per year", "yearly", 'a year'],
        "Monthly": ["monthly", "per month", 'a month'],
        "Weekly": ["weekly", "per week", 'a week'],
        "Daily": ["daily", "per day", 'a day'],
        "Hourly": ["hourly", "per hour", 'an hour'],
        "Bi-weekly": ["bi-weekly", "biweekly", "every two weeks", 'every 2 weeks', 'every other week', "twice a month", "two times per month"],
        "Quarterly": ["quarterly", "per quarter", "every quarter", "every 3 months", "a quarter"],
    }
    
    interval_text = interval_text.lower()
    
    for interval_name, phrases in interval_phrases.items():
            if any(phrase in interval_text for phrase in phrases):
                interval = JobSalaryInterval.query.filter_by(interval=interval_name).first()
                return interval.interval if interval else None
        
    return None

def process_extracted_entities(doc):
    salary_min = None
    salary_max = None
    currency_type = None
    interval_type = None

    for ent in doc.ents:
        if ent.label_ == "SALARY":
            salary_text = ent.text.replace(",", "").replace("$", "").strip()
            if "-" in salary_text:
                min_salary, max_salary = salary_text.split("-")
                salary_min = min_salary.strip()
                salary_max = max_salary.strip()
            else:
                salary_min = salary_max = salary_text
        elif ent.label_ == "CURRENCY":
            currency_type = get_currency_type(ent.text)
        elif ent.label_ == "INTERVAL":
            interval_type = get_interval_type(ent.text) or None
        
    return {
        "salary_min": salary_min,
        "salary_max": salary_max,
        "currency_type": currency_type,
        "interval_type": interval_type,
    }
