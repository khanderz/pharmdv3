import os
from dotenv import load_dotenv
import requests
import pandas as pd
from urllib.parse import urlparse
from google_sheets import load_sheet_data, update_google_sheet

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
        domain['value'].lower(): [alias.lower() for alias in domain['aliases']]
        for domain in domains_data
    }
    print("Successfully fetched healthcare domains keywords.")
    print("Healthcare Domains Keywords:")
    for domain, keywords in healthcare_domains_keywords.items():
        print(f"Domain: {domain.title()}, Keywords: {keywords}")
    return healthcare_domains_keywords

def get_domain_from_url(company_url):
    """
    Extracts the main domain from the company URL.
    """
    print(f"Extracting domain from URL: {company_url}")
    parsed_url = urlparse(company_url)
    domain = parsed_url.netloc.lower().replace("www.", "")
    print(f"Extracted domain: {domain}")
    return domain

def classify_healthcare_domain_specialty(healthcare_domains_keywords, company_url=None):
    """
    Classifies the company URL into relevant healthcare domains using keywords.
    """
    identified_domains = []
    
    if company_url:
        print("Classifying healthcare domains based on company URL...")
        for domain, keywords in healthcare_domains_keywords.items():
            print(f"\nChecking domain '{domain.title()}' with keywords: {keywords}")
            for keyword in keywords:
                if keyword in company_url:
                    identified_domains.append(domain.title())
                    print(f"Matched domain '{domain.title()}' with keyword '{keyword}' in URL.")
                    break  # Exit loop after the first match within the domain keywords

    if not identified_domains:
        print("No healthcare domains matched for this URL.")
    return list(set(identified_domains))

def update_google_sheet_with_domains(sheet_id, range_name):
    """
    Updates Google Sheets with classified healthcare domains based on company URL.
    Processes only the first 5 rows for testing purposes.
    """
    print("Loading master data from Google Sheets...")
    master_data = load_sheet_data(sheet_id, range_name)
    healthcare_domains_keywords = fetch_healthcare_domains_keywords()
    print("Successfully loaded master data.")

    for index, row in master_data.head(5).iterrows(): 
        company_url = row.get('company_url')
        
        print(f"\nProcessing company: {row['company_name']}")
        
        # Use company URL for classification
        domain = get_domain_from_url(company_url) if not pd.isna(company_url) else None
        domains = classify_healthcare_domain_specialty(healthcare_domains_keywords, domain)
        
        matched_domains = ', '.join(domains)
        master_data.at[index, 'healthcare_domain'] = matched_domains
        print(f"Updated {row['company_name']} with matched domains: {matched_domains}")

    print("\nUpdating Google Sheets with the classified domains for the first 5 rows...")
    update_google_sheet(sheet_id, range_name, master_data)
    print("Google Sheets update complete.")

if __name__ == "__main__":
    update_google_sheet_with_domains(MASTER_SHEET_ID, MASTER_RANGE_NAME)
