#  app/python/hooks/get_company_sizes.py

import requests


def fetch_company_sizes():
    try:
        response = requests.get("http://localhost:3000/company_sizes.json")
        response.raise_for_status()
        return response.json()
    except requests.exceptions.RequestException as e:
        print(f"Error fetching company sizes: {e}")
        return None


company_size_data = fetch_company_sizes()


def get_company_size(size_range):
    if not company_size_data:
        return None

    for size in company_size_data:
        if size["size_range"] == size_range:
            return size["id"]
    return None
