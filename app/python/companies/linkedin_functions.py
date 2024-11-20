# app/python/companies/utils/linkedin_functions.pyimport requests
import pandas as pd
import requests
from app.python.hooks.get_linkedin_data import fetch_company_data
from app.python.utils.logger import BLUE, RED, RESET, GREEN
from app.python.companies.google_sheets_updater import update_google_sheet

def enrich_with_linkedin_data(master_data, linkedin_username, linkedin_pw):
    """
    Enrich data with LinkedIn company details using the LinkedIn API hook.
    """

    if not linkedin_username or not linkedin_pw:
        print(f"{RED}LinkedIn credentials are missing. Skipping enrichment.{RESET}")
        return master_data

    if "linkedin_data" not in master_data.columns:
        master_data["linkedin_data"] = ""

    for index, row in master_data.iterrows():
        company_name = row["company_name"]
        if pd.isna(company_name) or not company_name.strip():
            continue

        print(f"{BLUE}Fetching LinkedIn master_data for {company_name}...{RESET}")
        linkedin_data = fetch_company_data(company_name, linkedin_username, linkedin_pw)
        master_data.at[index, "linkedin_data"] = str(linkedin_data) 

    return master_data

def filter_active_companies(master_data, sheet_id, active_range_name, credentials_path, master_linkedin_issue_data):
    """
    Filter companies with active LinkedIn URLs and add them to the "active" spreadsheet.
    """

    active_data = []
    problem_data = []
 
    for index, row in master_data.iterrows():
        company_name = row["company_name"]
        print(f"{BLUE}Checking LinkedIn URL for {company_name}...{RESET}")
        linkedin_url = row.get("linkedin_url")

        if pd.isna(linkedin_url) or not linkedin_url.strip():
            master_data.at[index, "operating_status"] = False
            print(f"{RED}No LinkedIn URL found for {company_name}{RESET}")
            continue

        try:
            headers = {
                "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
            }
            response = requests.head(linkedin_url, headers=headers, allow_redirects=True, timeout=5)
            print(f"response: {response.status_code}")

            if response.status_code == 200:
                print(f"{GREEN}Active LinkedIn URL found for {company_name}{RESET}")

                master_data.at[index, "operating_status"] = True

                updated_row = row.copy()
                updated_row["operating_status"] = True
                active_data.append(updated_row)

            elif response.status_code == 404:
                print(f"{RED}LinkedIn URL not found (404) for {company_name}{RESET}")
                master_data.at[index, "operating_status"] = False   

            else:
                print(f"{RED}Request issue for {company_name}: HTTP {response.status_code}{RESET}")
                updated_row = row.copy()
                problem_data.append(updated_row)

        except requests.RequestException as e:
            print(f"{RED}Error checking LinkedIn URL for {company_name}: {e}{RESET}")

    if active_data:
        active_df = pd.DataFrame(active_data, columns=master_data.columns)
        update_google_sheet(credentials_path, sheet_id, active_range_name, active_df)
        print(f"{GREEN}Updated 'active' spreadsheet with {len(active_data)} companies.{RESET}")
    elif problem_data:
        problem_df = pd.DataFrame(problem_data, columns=master_data.columns)
        update_google_sheet(credentials_path, sheet_id, master_linkedin_issue_data, problem_df)
        print(f"{RED}Updated 'LinkedIn issues' spreadsheet with {len(problem_data)} companies.{RESET}")    
    else:
        print(f"{BLUE}No active companies found to update.{RESET}")
