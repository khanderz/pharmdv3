#  app/python/hooks/get_currencies.py
import requests


def fetch_currencies():
    try:
        response = requests.get("http://localhost:3000/job_salary_currencies.json")
        response.raise_for_status()
        return response.json()
    except requests.exceptions.RequestException as e:
        print(f"Error fetching currencies: {e}")
        return None


#  cache data
currency_data = fetch_currencies()


def get_currency_type(symbol):
    """Fetch currency code from cached currency data based on symbol."""
    if not currency_data:
        return None
    for currency in currency_data:
        if currency["currency_sign"] == symbol:
            return currency["currency_code"]
    return None
