# app/python/hooks/get_ats_types.py

import requests

def fetch_ats_types():
    try:
        response = requests.get("http://localhost:3000/api/ats_types")
        response.raise_for_status()
        return response.json()
    except requests.exceptions.RequestException as e:
        print(f"Error fetching ATS types: {e}")
        return None

ats_type_data = fetch_ats_types()

def get_ats_type_by_code(ats_type_code):
    if not ats_type_data:
        return None

    for ats_type in ats_type_data:
        if ats_type["ats_type_code"] == ats_type_code:
            return ats_type
    return None
