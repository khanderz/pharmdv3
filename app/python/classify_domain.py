# classify_domain.py
import os
from dotenv import load_dotenv
import requests
from bs4 import BeautifulSoup
import pandas as pd
from urllib.parse import urljoin
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
    return healthcare_domains_keywords

def scrape_overview_section(about_url):
    """
    Scrapes the 'Overview' section of the LinkedIn about page.
    """
    print(f"Scraping the LinkedIn about page at: {about_url}")
    try:
        response = requests.get(about_url, timeout=10)
        response.raise_for_status()
        soup = BeautifulSoup(response.text, 'html.parser')
        
        overview_section = soup.find('section', {'id': 'about'})  
        if overview_section:
            overview_text = overview_section.get_text(separator=' ', strip=True)
            print("Successfully scraped Overview section.")
            return overview_text
        else:
            print(f"No overview section found for {about_url}")
            return ""
    except requests.RequestException as e:
        print(f"Error accessing {about_url}: {e}")
        return ""

def classify_healthcare_domain_specialty(content, healthcare_domains_keywords):
    """
    Classifies the content into relevant healthcare domains using keywords (case-insensitive).
    """
    identified_domains = []
    content_lower = content.lower() 

    print("Classifying healthcare domains based on content...")
    for domain, keywords in healthcare_domains_keywords.items():
        if any(keyword in content_lower for keyword in keywords):
            identified_domains.append(domain.title())  
            print(f"Matched domain: {domain.title()}")
    
    if not identified_domains:
        print("No healthcare domains matched for this content.")
    return identified_domains

def update_google_sheet_with_domains(sheet_id, range_name):
    """
    Updates Google Sheets with classified healthcare domains based on LinkedIn 'About' pages.
    Processes only the first 5 rows for testing purposes.
    """
    print("Loading master data from Google Sheets...")

    master_data = load_sheet_data(sheet_id, range_name)
    healthcare_domains_keywords = fetch_healthcare_domains_keywords()
    print("Successfully loaded master data.")

    for index, row in master_data.head(5).iterrows(): 
        linkedin_url = row.get('linkedin_url')
        if not pd.isna(linkedin_url):
   
            about_url = urljoin(linkedin_url + '/', 'about')
            print(f"\nProcessing company: {row['company_name']} with LinkedIn URL: {linkedin_url}")
            overview_content = scrape_overview_section(about_url)
            domains = classify_healthcare_domain_specialty(overview_content, healthcare_domains_keywords)
            
            matched_domains = ', '.join(domains)
            master_data.at[index, 'healthcare_domain'] = matched_domains
            print(f"Updated {row['company_name']} with matched domains: {matched_domains}")
        else:
            print(f"No LinkedIn URL found for {row['company_name']}. Skipping.")

    print("\nUpdating Google Sheets with the classified domains for the first 5 rows...")
    update_google_sheet(sheet_id, range_name, master_data)
    print("Google Sheets update complete.")


if __name__ == "__main__":
    update_google_sheet_with_domains(MASTER_SHEET_ID, MASTER_RANGE_NAME)
