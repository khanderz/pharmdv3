# app/python/hooks/get_ats_types.py

import requests


def fetch_ats_types():
    """
    Fetches the ATS types and appends domain matching URLs to each entry.
    """
    try:
        response = requests.get("http://localhost:3000/api/ats_types")
        response.raise_for_status()
        ats_types = response.json()

        return ats_types
    except requests.exceptions.RequestException as e:
        print(f"Error fetching ATS types: {e}")
        return None


ats_type_data = fetch_ats_types()


def get_ats_type_by_code(ats_type_code):
    """
    Fetches the ATS type entry by ats_type_code.
    """
    if not ats_type_data:
        return None

    for ats_type in ats_type_data:
        if ats_type["ats_type_code"] == ats_type_code:
            return ats_type
    return None
