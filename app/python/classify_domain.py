import os
from dotenv import load_dotenv
import requests
import pandas as pd
from bs4 import BeautifulSoup
from google_sheets_updater import load_sheet_data, update_google_sheet
import re

load_dotenv()

DOMAIN_KEYWORDS_URL = "http://localhost:3000/healthcare_domains.json"
MASTER_SHEET_ID = os.getenv("MASTER_SHEET_ID")
MASTER_RANGE_NAME = os.getenv("MASTER_RANGE_NAME")


def fetch_healthcare_domains_keywords():
    print("Fetching healthcare domains keywords from API...")
    response = requests.get(DOMAIN_KEYWORDS_URL)
    response.raise_for_status()
    domains_data = response.json()

    healthcare_domains_keywords = {
        domain["value"].lower(): [domain["value"].lower()]
        + [alias.lower() for alias in domain["aliases"]]
        for domain in domains_data
    }
    print("Successfully fetched healthcare domains keywords.")
    return healthcare_domains_keywords


def get_text_from_url(company_url):
    print(f"Fetching and parsing text from URL: {company_url}")
    headers = {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
    }
    try:
        response = requests.get(company_url, headers=headers, timeout=5)
        response.raise_for_status()
        soup = BeautifulSoup(response.text, "html.parser")
        text = " ".join([p.get_text().lower() for p in soup.find_all("p")])
        return text
    except requests.exceptions.RequestException as e:
        print(f"Failed to fetch or parse text from {company_url}: {e}")
        return ""


def classify_healthcare_domain(healthcare_domains_keywords, page_text):
    identified_domains = []

    print("Classifying healthcare domains based on page text...")
    for domain, keywords in healthcare_domains_keywords.items():
        matched_keywords = []
        for keyword in keywords:
            pattern = r"\b" + re.escape(keyword) + r"\b"
            if re.search(pattern, page_text):
                matched_keywords.append(keyword)

        if matched_keywords:
            identified_domains.append(domain.title())
            print(
                f"Matched domain '{domain.title()}' with keywords {matched_keywords} in page text."
            )

    if not identified_domains:
        print("No healthcare domains matched for this text.")
    return list(set(identified_domains))


def remove_duplicates(data):
    initial_count = len(data)
    data = data.drop_duplicates(subset="company_name", keep="first").reset_index(
        drop=True
    )
    final_count = len(data)
    print(f"Removed {initial_count - final_count} duplicate rows.")
    return data


def update_google_sheet_with_domains(sheet_id, range_name):
    print("Loading master data from Google Sheets...")
    master_data = load_sheet_data(sheet_id, range_name)
    healthcare_domains_keywords = fetch_healthcare_domains_keywords()
    print("Successfully loaded master data.")

    for index, row in master_data.iterrows():
        company_url = row.get("company_url")
        existing_domains = row.get("healthcare_domain", "")

        print(f"\nProcessing company: {row['company_name']}")

        page_text = get_text_from_url(company_url) if not pd.isna(company_url) else ""
        new_domains = classify_healthcare_domain(healthcare_domains_keywords, page_text)

        updated_domains = ", ".join(sorted(set(new_domains)))

        if updated_domains != existing_domains:
            master_data.at[index, "healthcare_domain"] = updated_domains
            print(
                f"Updated {row['company_name']} with matched domains: {updated_domains}"
            )
        else:
            print(f"No update needed for {row['company_name']}.")

    master_data = remove_duplicates(master_data)

    print("\nUpdating Google Sheets with the classified domains for all rows...")
    update_google_sheet(sheet_id, range_name, master_data)
    print("Google Sheets update complete.")


if __name__ == "__main__":
    update_google_sheet_with_domains(MASTER_SHEET_ID, MASTER_RANGE_NAME)
