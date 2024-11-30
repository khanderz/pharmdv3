#  app/python/hooks/get_hc_domains.py

import requests


def fetch_hc_domains():
    try:
        response = requests.get("http://localhost:3000/healthcare_domains.json")
        response.raise_for_status()
        return response.json()
    except requests.exceptions.RequestException as e:
        print(f"Error fetching hc domains: {e}")
        return None


hc_domain_data = fetch_hc_domains()


def get_hc_domain_id(domain_name):
    if not hc_domain_data:
        return None

    for domain in hc_domain_data:
        if domain["name"] == domain_name:
            return domain["id"]
    return None


def get_hc_domain_name(domain_id):
    if not hc_domain_data:
        return None

    for domain in hc_domain_data:
        if domain["id"] == domain_id:
            return domain["name"]
    return None
