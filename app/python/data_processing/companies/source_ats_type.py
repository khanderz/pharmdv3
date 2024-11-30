# app/python/data_processing/companies/source_ats_type.py

import re
import pandas as pd
from app.python.ai_processing.utils.logger import BLUE, GREEN, RED, RESET
from app.python.data_processing.companies.google_sheets_updater import (
    update_google_sheet_row,
)
from app.python.hooks.get_ats_types import fetch_ats_types
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
from selenium.common.exceptions import (
    WebDriverException,
    TimeoutException,
    NoSuchElementException,
)
from webdriver_manager.chrome import ChromeDriverManager
import time

ats_type_data = fetch_ats_types()


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
        chrome_options.add_argument("--disable-extensions")
        chrome_options.add_argument("--window-size=1920,1080")

        service = Service(ChromeDriverManager().install())
        driver = webdriver.Chrome(service=service, options=chrome_options)

        print(f"{BLUE}Trying to fetch URL with Selenium: {url}{RESET}")
        driver.set_page_load_timeout(30)
        driver.get(url)

        time.sleep(2)

        final_url = driver.current_url.lower()

        if ats_homepage and final_url == ats_homepage.lower():
            return False

        try:
            page_text = driver.find_element(By.TAG_NAME, "body").text.lower()
            # print(f"{BLUE}Page text: {page_text}{RESET}")
        except NoSuchElementException:
            print(f"{RED}Body element not found for URL: {url}{RESET}")
            return False

        invalid_phrases = [
            "page not found",
            "the page you requested was not found",
            "sorry, we couldn't find anything",
            "not found",
            "page you're looking for doesn't exist",
            "doesn't exist",
        ]

        page_text_lower = page_text.lower()

        if any(phrase in page_text_lower for phrase in invalid_phrases):
            print(f"{RED}Invalid page content detected for URL: {url}{RESET}")
            return False

        no_jobs_phrases = ["hasn't added any jobs yet", "sorry, no job openings"]
        if any(phrase in page_text for phrase in no_jobs_phrases):
            print(f"{RED}No job postings found for URL: {url}{RESET}")
            return False

        print(f"{GREEN}Valid page found for URL: {url}{RESET}")
        return True

    except TimeoutException:
        print(f"{RED}Timeout occurred while fetching URL: {url}{RESET}")
        return False

    except WebDriverException as e:
        # print(f"{RED}An error occurred while fetching URL: {url}, {e}{RESET}")
        return False

    finally:
        if driver:
            driver.quit()


def build_ats_url(ats_pattern, company_name):
    """
    Replaces the wildcard (*) in the ATS pattern with the company_name.
    """
    suffixes = ["inc", "inc.", "corp", "corp.", "ltd", "ltd.", "llc", "llc."]

    name_without_suffix = company_name
    for suffix in suffixes:
        name_without_suffix = re.sub(rf"(?i)\b{suffix}\b", "", name_without_suffix)

    sanitized_name = re.sub(r"[^\w]", "", name_without_suffix).lower()

    return ats_pattern.replace("*", sanitized_name), sanitized_name


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

        test_url, sanitized_name = build_ats_url(ats_pattern, company_name)

        status = fetch_url_status(test_url, ats_homepage)

        if status:
            return ats_type_code, sanitized_name

    return None, None


def update_ats_type_in_master_data(
    master_active_data, credentials_path, master_sheet_id, master_active_sheet_name
):
    """
    Updates the ats_type for each company in master_active_data, only if ats_type is not already set.
    Updates the Google Sheet immediately for each matched ats_type.
    """

    print(f"{BLUE} setting ats type for sheet name : {master_active_sheet_name} {RESET}")

    for index, row in master_active_data.iterrows():
        company_name = row["company_name"]
        current_ats_type = row["company_ats_type"]

        print(f"{BLUE}Processing {company_name}...{RESET}")

        if pd.notna(current_ats_type) and str(current_ats_type).strip():
            print(f"{GREEN}ATS type already set for {company_name}, skipping.{RESET}")
            continue

        matched_ats_type, sanitized_name = match_ats_type(company_name)

        if matched_ats_type:
            print(
                f"{GREEN}Matched ATS type for {company_name}: {matched_ats_type}{RESET}"
            )
            print(f"{GREEN}Setting ats_id for {company_name}: {sanitized_name}{RESET}")

            master_active_data.at[index, "company_ats_type"] = matched_ats_type
            master_active_data.at[index, "ats_id"] = sanitized_name

            updated_row = master_active_data.loc[index]
            row_data = updated_row.fillna("").astype(str).tolist()

            try:
                print(
                    f"{BLUE}Updating Google Sheet for {company_name} for row {index + 1} ...{RESET}"
                )
                update_google_sheet_row(
                    credentials_path,
                    master_sheet_id,
                    master_active_sheet_name,
                    row_index=index + 1,
                    data=row_data,
                )
            except Exception as e:
                print(
                    f"{RED}An error occurred during Google Sheet update for {company_name}: {e}{RESET}"
                )

        else:
            print(f"{RED}No ATS type matched for {company_name}{RESET}")

    print(f"{GREEN}Finished processing all companies.{RESET}")
    return master_active_data
