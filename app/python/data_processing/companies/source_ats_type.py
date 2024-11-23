# app/python/data_processing/companies/source_ats_type.py

import pandas as pd
from app.python.ai_processing.utils.logger import BLUE, GREEN, RED, RESET
from app.python.data_processing.companies.google_sheets_updater import update_google_sheet
from app.python.hooks.get_ats_types import fetch_ats_types

ats_type_data = fetch_ats_types()

from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
from selenium.common.exceptions import WebDriverException
from webdriver_manager.chrome import ChromeDriverManager
import time

def fetch_url_status(url, ats_homepage):
    """
    Uses Selenium to render the page and check for dynamic content.
    Returns True if the page is valid, otherwise False.
    """
    driver = None  

    try:
        chrome_options = Options()
        chrome_options.add_argument("--headless")  
        chrome_options.add_argument("--disable-gpu")
        chrome_options.add_argument("--no-sandbox")
        chrome_options.add_argument("--disable-dev-shm-usage")

        service = Service(ChromeDriverManager().install())
        driver = webdriver.Chrome(service=service, options=chrome_options)

        print(f"{BLUE}Trying to fetch URL with Selenium: {url}{RESET}")
        driver.get(url)

        time.sleep(2)  

        final_url = driver.current_url.lower()

        if ats_homepage and final_url == ats_homepage:
            print(f"{RED}Redirected to ATS homepage: {final_url}{RESET}")
            return False

        page_text = driver.find_element(By.TAG_NAME, "body").text.lower()

        if "page not found" in page_text or "the page you requested was not found" or "sorry, we couldn't find anything" or "not found" in page_text:
            print(f"{RED}Invalid page content detected for URL: {url}{RESET}")
            return False
        
        if "hasn't added any jobs yet" or "sorry, no job openings" in page_text:
            print(f"{RED}no added jobs yet for URL: {url}{RESET}")
            return False
        
        print(f"{GREEN}Valid page found for URL: {url}{RESET}")
        return True

    except WebDriverException as e:
        print(f"{RED}Error fetching URL with Selenium: {e}{RESET}")
        return False

    finally:
        if driver:
            driver.quit()



def build_ats_url(ats_pattern, company_name):
    """
    Replaces the wildcard (*) in the ATS pattern with the company_name.
    """
    return ats_pattern.replace("*", company_name.lower())

def match_ats_type(company_name):
    """
    Loops through all ATS types, builds the URL using the company_name, and tests for a match.
    Returns the ats_type_code if a match is found, otherwise None.
    """
    if not ats_type_data:
        return None

    for ats_type in ats_type_data:
        ats_type_code = ats_type["ats_type_code"]
        ats_pattern = ats_type.get("domain_matching_url") 
        ats_homepage = ats_type.get("homepage")
        if not ats_pattern:
            continue

        test_url = build_ats_url(ats_pattern, company_name)

        status = fetch_url_status(test_url, ats_homepage)

        if status:
            print(f" status")
            return ats_type_code

    return None

def update_ats_type_in_master_data(master_active_data, credentials_path, master_sheet_id, active_range_name):
    """
    Updates the ats_type for each company in master_active_data, only if ats_type is not already set.
    """
    updated_data = []

    existing_active_data = pd.DataFrame(columns=master_active_data.columns)

    for _, row in master_active_data.iterrows():
        company_name = row["company_name"]
        current_ats_type = row.get("ats_type")

        print(f"{BLUE}Processing {company_name}...{RESET}")

        if current_ats_type and not pd.isna(current_ats_type):
            print(f"{GREEN}ATS type already set for {company_name}, skipping.{RESET}")
            updated_data.append(row)
            continue

        matched_ats_type = match_ats_type(company_name)

        if matched_ats_type:
            print(f"{GREEN}Matched ATS type for {company_name}: {matched_ats_type}{RESET}")
            row["ats_type"] = matched_ats_type
        else:
            print(f"{RED}No ATS type matched for {company_name}{RESET}")

        updated_data.append(row)

    updated_df = pd.DataFrame(updated_data, columns=master_active_data.columns)
    updated_active_data = pd.concat([existing_active_data, updated_df]).drop_duplicates(subset="company_name", keep="last")


    print(f"{BLUE}Updating Google Sheet...{RESET}")
    update_google_sheet(credentials_path, master_sheet_id, active_range_name, updated_active_data)
    print(f"{GREEN}Google Sheet updated successfully.{RESET}")

    print(f"{GREEN}Updated companies: {updated_data}{RESET}")
    return master_active_data