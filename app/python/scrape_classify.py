# scrape_classify.py
import requests
from bs4 import BeautifulSoup
import pandas as pd
from app.python.google_sheets_updater import load_sheet_data, update_google_sheet
from urllib.parse import urljoin

ATS_TYPES_URL = "http://localhost:3000/api/ats_types"

SPECIALTY_KEYWORDS_URL = "http://localhost:3000/company_specialties.json"


def fetch_specialty_keywords():
    """
    Fetches specialty keywords from Rails API.
    """
    try:
        response = requests.get(SPECIALTY_KEYWORDS_URL)
        response.raise_for_status()
        specialties_data = response.json()

        specialties_keywords = {
            specialty["value"]: specialty["keywords"]
            for specialty in specialties_data
            if "keywords" in specialty
        }
        return specialties_keywords
    except requests.RequestException as e:
        print(f"Error fetching specialties: {e}")
        return {}


def fetch_ats_keywords():
    """
    Fetches ATS types from the Rails API and builds a keyword dictionary.
    """
    try:
        response = requests.get(ATS_TYPES_URL)
        response.raise_for_status()
        ats_data = response.json()

        ats_keywords = {
            ats["ats_type_name"]: ats["ats_type_code"].lower() for ats in ats_data
        }
        return ats_keywords
    except requests.RequestException as e:
        print(f"Error fetching ATS types: {e}")
        return {}


def identify_ats_type(careers_url):
    ats_keywords = fetch_ats_keywords()

    try:
        response = requests.get(careers_url, timeout=10)
        response.raise_for_status()
        page_content = response.text.lower()

        for ats_name, keyword in ats_keywords.items():
            if keyword in page_content:
                print(f"Identified {ats_name} as the ATS for {careers_url}")
                return ats_name
    except requests.RequestException as e:
        print(f"Error accessing {careers_url}: {e}")
    return None


def classify_healthcare_domain_specialty(about_us_content):
    healthcare_domains_keywords = fetch_healthcare_domains_keywords()
    specialty_keywords = fetch_specialty_keywords()

    identified_domains = []
    identified_specialties = []

    for domain, keywords in healthcare_domains_keywords.items():
        if any(keyword.lower() in about_us_content.lower() for keyword in keywords):
            identified_domains.append(domain)

    for domain in identified_domains:
        if domain in specialty_keywords:
            for specialty, keywords in specialty_keywords[domain].items():
                if any(
                    keyword.lower() in about_us_content.lower() for keyword in keywords
                ):
                    identified_specialties.append(specialty)

    return identified_domains, identified_specialties


def extract_and_classify_info(company_name, company_url):
    careers_url = f"{company_url}/careers"
    ats_type = identify_ats_type(careers_url)

    about_us_url = f"{company_url}/about"
    try:
        about_response = requests.get(about_us_url, timeout=10)
        about_response.raise_for_status()
        about_content = BeautifulSoup(about_response.text, "html.parser").get_text()

        healthcare_domains, specialties = classify_healthcare_domain_specialty(
            about_content
        )
    except requests.RequestException as e:
        print(f"Error accessing {about_us_url}: {e}")
        healthcare_domains, specialties = [], []

    return ats_type, healthcare_domains, specialties


def update_with_ai_info(filled_master_data):
    for index, row in filled_master_data.iterrows():
        if (
            pd.isna(row["company_ats_type"])
            or pd.isna(row["healthcare_domain"])
            or pd.isna(row["company_specialty"])
        ):
            company_url = row["company_url"]
            ats_type, healthcare_domains, specialties = extract_and_classify_info(
                row["company_name"], company_url
            )

            if ats_type:
                filled_master_data.at[index, "company_ats_type"] = ats_type
            if healthcare_domains:
                filled_master_data.at[index, "healthcare_domain"] = ", ".join(
                    healthcare_domains
                )
            if specialties:
                filled_master_data.at[index, "company_specialty"] = ", ".join(
                    specialties
                )

            print(
                f"Updated {row['company_name']} with ATS type: {ats_type}, domains: {healthcare_domains}, specialties: {specialties}"
            )

    return filled_master_data


if __name__ == "__main__":
    master_sheet_id = "your_master_sheet_id"
    master_range_name = "master!A:R"

    filled_master_data = load_sheet_data(master_sheet_id, master_range_name)

    filled_master_data = update_with_ai_info(filled_master_data)

    update_google_sheet(master_sheet_id, master_range_name, filled_master_data)
