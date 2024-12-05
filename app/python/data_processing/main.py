# app/python/data_processing/main.py
import os
from dotenv import load_dotenv

# from app.python.data_processing.companies.linkedin_functions import enrich_with_linkedin_data, seed_company_data
from app.python.data_processing.companies.populate_hc_domain import (
    process_and_update_sheet,
)
from companies.google_sheets_updater import load_sheet_data

from companies.utils.cleaner import remove_duplicates

load_dotenv()

if __name__ == "__main__":
    # ----------------------------- OS -----------------------------

    credentials_path = os.getenv("GOOGLE_CREDENTIALS_PATH")

    master_sheet_id = os.getenv("MASTER_SHEET_ID")

    # master_range_name = os.getenv("MASTER_RANGE_NAME")

    # master_active_range_name = os.getenv("MASTER_ACTIVE_RANGE_NAME")
    # master_active_sheet_name = os.getenv("MASTER_ACTIVE_SHEET_NAME")

    # master_linkedin_issues_range_name = os.getenv("MASTER_LINKEDIN_ISSUE_RANGE_NAME")
    # master_linkedin_issues_sheet_name = os.getenv("MASTER_LINKEDIN_ISSUE_SHEET_NAME")

    # master_linkedin_pull_range_name = os.getenv("MASTER_LINKEDIN_PULL_RANGE_NAME")
    # master_linkedin_pull_sheet_name = os.getenv("MASTER_LINKEDIN_PULL_SHEET_NAME")

    # linkedin_username = os.getenv("LINKEDIN_USERNAME")
    # linkedin_pw = os.getenv("LINKEDIN_PASSWORD")

    GREENHOUSE_SHEET_RANGE = os.getenv("GREENHOUSE_SHEET_RANGE")
    GREENHOUSE_SHEET_NAME = os.getenv("GREENHOUSE_SHEET_NAME")

    LEVER_SHEET_RANGE = os.getenv("LEVER_SHEET_RANGE")
    LEVER_SHEET_NAME = os.getenv("LEVER_SHEET_NAME")

    # ----------------------------- LOAD  -----------------------------

    # master_data = load_sheet_data(credentials_path, master_sheet_id, master_range_name)
    # master_active_data = load_sheet_data(
    #     credentials_path, master_sheet_id, master_active_range_name
    # )
    # master_linkedin_issue_data = load_sheet_data(
    #     credentials_path, master_sheet_id, master_linkedin_issues_range_name
    # )

    # master_linkedin_pull_data = load_sheet_data(
    #     credentials_path, master_sheet_id, master_linkedin_pull_range_name
    # )

    # greenhouse_data = load_sheet_data(
    #     credentials_path, master_sheet_id, GREENHOUSE_SHEET_RANGE
    # )

    # lever_data = load_sheet_data(credentials_path, master_sheet_id, LEVER_SHEET_RANGE)

    # ----------------------------- DATA PROCESSING -----------------------------

    # filter_active_companies(master_data, master_sheet_id, master_active_range_name, credentials_path, master_linkedin_issues_range_name, master_range_name)

    # updated_data = update_ats_type_in_master_data(
    #     master_linkedin_issue_data,
    #     credentials_path,
    #     master_sheet_id,
    #     master_linkedin_issues_sheet_name,
    # )

    # seed_company_data(greenhouse_data, credentials_path, master_sheet_id, GREENHOUSE_SHEET_NAME)
    # seed_company_data(lever_data, credentials_path, master_sheet_id, LEVER_SHEET_NAME)

    # ----------------------------- AI MODELS -----------------------------

    # process_and_update_sheet(
    #     credentials_path, master_sheet_id, greenhouse_data, GREENHOUSE_SHEET_NAME
    # )

    # process_and_update_sheet(
    #     credentials_path, master_sheet_id, lever_data, LEVER_SHEET_NAME
    # )

    # from app.python.data_processing.job_posts.process_job_post import (
    #     process_job_post_descriptions,
    # )

    # ----------------------------- HUBSPOT / ZAPIER -----------------------------

    # hubspot_sheet_id = os.getenv("HUBSPOT_SHEET_ID")
    # hubspot_range_name = os.getenv("HUBSPOT_RANGE_NAME")
    # zapier_sheet_id = os.getenv("ZAPIER_SHEET_ID")
    # zapier_range_name = os.getenv("ZAPIER_RANGE_NAME")

    # hubspot_data = load_sheet_data(credentials_path, hubspot_sheet_id, hubspot_range_name)
    # zapier_data = load_sheet_data(credentials_path, zapier_sheet_id, zapier_range_name)

    # hubspot_data = rename_hubspot_columns(hubspot_data)
    # master_data = fill_missing_values_with_hubspot(master_data, hubspot_data)
    # master_data = transfer_data(master_data, zapier_data)

    # master_data = remove_duplicates(master_data)
    # update_google_sheet(credentials_path, master_sheet_id, master_range_name, master_data)

    # ----------------------------- PROXYCURL -----------------------------
    query_params = {
        'country': 'US',
        'region': 'United States',
        # 'city': 'new AND york',
        'type': 'PRIVATELY_HELD',
        'follower_count_min': '100',
        # 'follower_count_max': '1000',
        # 'name': 'google OR apple',
        'industry': 'technology',
        # 'employee_count_max': '1000',
        # 'employee_count_min': '1000',
        # 'description': 'medical device',
        'founded_after_year': '2019',
        # 'founded_before_year': '1999',
        # 'funding_amount_max': '1000000',
        # 'funding_amount_min': '1000000',
        # 'funding_raised_after': '2019-12-30',
        # 'funding_raised_before': '2019-12-30',
        # 'public_identifier_in_list': 'stripe,amazon',
        # 'public_identifier_not_in_list': 'stripe,amazon',
        # 'page_size': '10',
        'enrich_profiles': 'enrich',
        'use_cache': 'if-present',
    }

    results = search_companies(query_params)
    filtered_companies = filter_healthcare_companies(results)
    update_companies_to_google_sheet(credentials_path, sheet_id, sheet_range, filtered_companies)