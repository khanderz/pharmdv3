#  app/python/hooks/get_company_specialties.py

import requests

def fetch_company_specialties():
    try:
        response = requests.get("http://localhost:3000/company_specialties.json")
        response.raise_for_status()
        return response.json()
    except requests.exceptions.RequestException as e:
        print(f"Error fetching company specialties: {e}")
        return None
    
company_specialty_data = fetch_company_specialties()

def get_company_specialty_id(specialty_name):
    if not company_specialty_data:
        return None

    for specialty in company_specialty_data:
        if specialty["name"] == specialty_name:
            return specialty["id"]
    return None

def get_company_specialty_name(specialty_id):
    if not company_specialty_data:
        return None

    for specialty in company_specialty_data:
        if specialty["id"] == specialty_id:
            return specialty["name"]
    return None