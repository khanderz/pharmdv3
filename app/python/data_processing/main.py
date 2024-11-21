# app/python/data_processing/main.py
import os
from dotenv import load_dotenv
 
from companies.google_sheets_updater import load_sheet_data
from companies.hubspot_functions import rename_hubspot_columns, fill_missing_values_with_hubspot
from companies.linkedin_functions import filter_active_companies, enrich_with_linkedin_data
from companies.utils.cleaner import remove_duplicates
from companies.zapier_functions import transfer_data

load_dotenv()

if __name__ == "__main__":
    credentials_path = os.getenv("GOOGLE_CREDENTIALS_PATH")

    master_sheet_id = os.getenv("MASTER_SHEET_ID")
    master_range_name = os.getenv("MASTER_RANGE_NAME")
    master_active_range_name = os.getenv("MASTER_ACTIVE_RANGE_NAME")
    master_linkedin_issues_range_name = os.getenv("MASTER_LINKEDIN_ISSUE_RANGE_NAME")

    # hubspot_sheet_id = os.getenv("HUBSPOT_SHEET_ID")
    # hubspot_range_name = os.getenv("HUBSPOT_RANGE_NAME")
    # zapier_sheet_id = os.getenv("ZAPIER_SHEET_ID")
    # zapier_range_name = os.getenv("ZAPIER_RANGE_NAME")

    linkedin_username = os.getenv("LINKEDIN_USERNAME")
    linkedin_pw = os.getenv("LINKEDIN_PASSWORD")

    master_data = load_sheet_data(credentials_path, master_sheet_id, master_range_name)
    master_active_data = load_sheet_data(credentials_path, master_sheet_id, master_active_range_name)
    master_linkedin_issue_data = load_sheet_data(credentials_path, master_sheet_id, master_linkedin_issues_range_name)
    # hubspot_data = load_sheet_data(credentials_path, hubspot_sheet_id, hubspot_range_name)
    # zapier_data = load_sheet_data(credentials_path, zapier_sheet_id, zapier_range_name)

    # hubspot_data = rename_hubspot_columns(hubspot_data)
    # master_data = fill_missing_values_with_hubspot(master_data, hubspot_data)
    # master_data = transfer_data(master_data, zapier_data)

    master_data = remove_duplicates(master_data)

    filter_active_companies(master_data, master_sheet_id, master_active_range_name, credentials_path, master_linkedin_issue_data)
    master_active_data = remove_duplicates(master_active_data)
    # enrich_with_linkedin_data(master_active_data, linkedin_username, linkedin_pw)
    # update_google_sheet(credentials_path, master_sheet_id, master_range_name, master_data)
