# app/python/companies/utils/linkedin_functions.pyimport requests
import pandas as pd
import requests
from app.python.hooks.get_linkedin_data import fetch_company_data
from app.python.utils.logger import BLUE, RED, RESET, GREEN
from google_sheets_updater import update_google_sheet

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

        print(f"Fetching LinkedIn master_data for {company_name}...")
        linkedin_data = fetch_company_data(company_name, linkedin_username, linkedin_pw)
        master_data.at[index, "linkedin_data"] = str(linkedin_data) 

    return master_data

def filter_active_companies(master_data, sheet_id, active_range_name, credentials_path):
    """
    Filter companies with active LinkedIn URLs and add them to the "active" spreadsheet.
    """
    if "linkedin_url" not in master_data.columns:
        missing_companies = master_data["company_name"].tolist() if "company_name" in master_data.columns else []
        print(
            f"Warning: 'linkedin_url' column is missing from the master data. Affected companies: {', '.join(missing_companies) if missing_companies else 'No company_name column found'}"
        )
        return

    active_data = []

    for index, row in master_data.iterrows():
        linkedin_url = row.get("linkedin_url")
        if pd.isna(linkedin_url) or not linkedin_url.strip():
            continue

        try:
            response = requests.head(linkedin_url, allow_redirects=True, timeout=5)
            if response.status_code == 200:
                print(f"Active LinkedIn URL found for {row['company_name']}")
                active_data.append(row)
            else:
                print(f"Inactive LinkedIn URL for {row['company_name']}")
        except requests.RequestException as e:
            print(f"Error checking LinkedIn URL for {row['company_name']}: {e}")

    if active_data:
        active_df = pd.DataFrame(active_data, columns=master_data.columns)
        update_google_sheet(credentials_path, sheet_id, active_range_name, active_df)
        print(f"Updated 'active' spreadsheet with {len(active_data)} companies.")
    else:
        print("No active companies found to update.")
