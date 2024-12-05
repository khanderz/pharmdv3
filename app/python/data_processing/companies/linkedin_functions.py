# app/python/data_processing/companies/utils/linkedin_functions.pyimport requests
import pandas as pd
import requests
from app.python.ai_processing.utils.logger import BLUE, GREEN, RED, RESET
from app.python.data_processing.companies.google_sheets_updater import (
    update_google_sheet,
    update_google_sheet_row,
    batch_update_google_sheet,
    get_column_letter,
)
from app.python.hooks.get_company_sizes import fetch_company_sizes
from app.python.hooks.get_linkedin_data import fetch_company_data
import ast


def safely_parse_list(value):
    if isinstance(value, list):
        return value
    if isinstance(value, str):
        try:
            return ast.literal_eval(value)
        except (ValueError, SyntaxError):
            pass

    return [value] if value else []


def seed_company_data(data, credentials_path, master_sheet_id, range_name):
    """
    Updates missing company_type and logo_url fields in the dataset and synchronizes with Google Sheets.

    Args:
        data (pd.DataFrame): The dataset containing company information.
        credentials_path (str): Path to Google Sheets API credentials.
        master_sheet_id (str): Google Sheets ID.
        range_name (str): Range name in the sheet to update.
    """

    for index, row in data.iterrows():
        company_name = row.get("company_name", "").strip()

        if not company_name:
            print(f"{RED}No company name found for row {index}{RESET}")
            continue

        print(f"{BLUE}Fetching LinkedIn data for {company_name}...{RESET}")
        linkedin_data = fetch_company_data(row.get("linkedin_url"))

        if not linkedin_data or "error" in linkedin_data:
            print(f"{RED}Failed to fetch data for {company_name}{RESET}")
            continue

        updated = False

        if pd.isna(row.get("company_type")) or not row["company_type"]:
            company_type = linkedin_data.get("company_type")
            if company_type:
                data.at[index, "company_type"] = company_type
                updated = True

        if pd.isna(row.get("logo_url")) or not row["logo_url"]:
            logo_url = linkedin_data.get("profile_pic_url")
            if logo_url:
                data.at[index, "logo_url"] = logo_url
                updated = True

        if updated:
            try:
                print(f"{BLUE}Updating Google Sheet for {company_name}...{RESET}")
                update_google_sheet_row(
                    credentials_path,
                    master_sheet_id,
                    range_name,
                    row_index=index + 1,
                    data=data.loc[index].fillna("").astype(str).tolist(),
                )
            except Exception as e:
                print(
                    f"{RED}Error updating Google Sheet for {company_name}: {e}{RESET}"
                )
        else:
            print(
                f"{BLUE}No updates needed for {company_name}. Skipping Google Sheet update.{RESET}"
            )

    print(f"{GREEN}Company data seeding completed successfully!{RESET}")

def map_linkedin_data_to_newcompany(row, linkedin_data):
    """
    Map LinkedIn data to a single company's attributes.
    """
    company_size_data = fetch_company_sizes()
    updated_attributes = []

    row["company_name"] = linkedin_data.get("name")
    row["linkedin_url"] = linkedin_data.get("linkedin_profile_url")
    
    row["company_url"] = linkedin_data.get("website")
    updated_attributes.append("company_url")

    row["company_type"] = linkedin_data.get("company_type")
    updated_attributes.append("company_type")

    row["year_founded"] = linkedin_data.get("founded_year")
    updated_attributes.append("year_founded")

    row["logo_url"] = linkedin_data.get("profile_pic_url")
    updated_attributes.append("logo_url")

    row["company_description"] = linkedin_data.get("description")
    updated_attributes.append("company_description")

    if linkedin_data.get("tagline") is not None:
        row["company_tagline"] = linkedin_data.get("tagline")
        updated_attributes.append("company_tagline")

    confirmed_locations = linkedin_data.get("locations", [])
    if confirmed_locations:
        company_countries = set(safely_parse_list(row.get("company_countries", [])))
        company_states = set(safely_parse_list(row.get("company_states", [])))
        company_cities = set(safely_parse_list(row.get("company_cities", [])))

        for location in confirmed_locations:
            if location.get("country"):
                company_countries.add(location["country"])
            if location.get("state"):
                company_states.add(location["state"])
            if location.get("city"):
                company_cities.add(location["city"])

        row["company_countries"] = list(company_countries)
        row["company_states"] = list(company_states)
        row["company_cities"] = list(company_cities)

        updated_attributes.extend(["company_countries", "company_states", "company_cities"])

    if company_size_data:
        staff_count = linkedin_data.get("company_size_on_linkedin")
        if staff_count is not None:
            for size in company_size_data:
                size_range = size["size_range"]
                try:
                    if "+" in size_range:
                        min_size = int(size_range.replace("+", "").strip())
                        max_size = float("inf")
                    else:
                        min_size, max_size = map(int, size_range.split("-"))
                except ValueError:
                    continue

                if min_size <= staff_count <= max_size:
                    row["company_size"] = size_range
                    updated_attributes.append("company_size")
                    break

    return row, updated_attributes


def map_linkedin_data_to_company(row, linkedin_data):
    """
    Map LinkedIn data to a single company's attributes.
    """
    company_size_data = fetch_compa
    ny_sizes()
    updated_attributes = []

    if pd.isna(row.get("company_url")) or not row["company_url"]:
        row["company_url"] = linkedin_data.get("website")
        updated_attributes.append("company_url")

    if pd.isna(row.get("logo_url")) or not row["logo_url"]:
        row["logo_url"] = linkedin_data.get("profile_pic_url")
        updated_attributes.append("logo_url")

    if pd.isna(row.get("company_type")) or not row["company_type"]:
        company_type = linkedin_data.get("company_type")
        if company_type:
            row["company_type"] = company_type
            updated_attributes.append("company_type")

    if pd.isna(row.get("year_founded")) or not row["year_founded"]:
        row["year_founded"] = linkedin_data.get("founded_year")
        updated_attributes.append("year_founded")

    row["company_description"] = linkedin_data.get("description")
    updated_attributes.append("company_description")

    if linkedin_data.get("tagline") is not None:
        row["company_tagline"] = linkedin_data.get("tagline")
        updated_attributes.append("company_tagline")

    confirmed_locations = linkedin_data.get("locations", [])
    if confirmed_locations:
        for location in confirmed_locations:
            country = location.get("country")
            state = location.get("state")
            city = location.get("city")

            current_countries = safely_parse_list(row.get("company_countries"))
            if country and country not in current_countries:
                current_countries.append(country)
                row["company_countries"] = current_countries
                updated_attributes.append("company_countries")

            current_states = safely_parse_list(row.get("company_states"))
            if state and state not in current_states:
                current_states.append(state)
                row["company_states"] = current_states
                updated_attributes.append("company_states")

            current_cities = safely_parse_list(row.get("company_cities"))
            if city and city not in current_cities:
                current_cities.append(city)
                row["company_cities"] = current_cities
                updated_attributes.append("company_cities")

    if company_size_data:
        staff_count = linkedin_data.get("company_size_on_linkedin")
        if staff_count is not None:
            for size in company_size_data:
                size_range = size["size_range"]
                try:
                    if "+" in size_range:
                        min_size = int(size_range.replace("+", "").strip())
                        max_size = float("inf")
                    else:
                        min_size, max_size = map(int, size_range.split("-"))
                except ValueError:
                    continue

                if min_size <= staff_count <= max_size:
                    row["company_size"] = size_range
                    updated_attributes.append("company_size")
                    break

    return row, updated_attributes

def enrich_with_linkedin_data(
    master_active_data, credentials_path, master_sheet_id, active_range_name
):
    """
    Enrich data with LinkedIn company details using the LinkedIn API hook.
    """

    for index, row in master_active_data.iterrows():
        company_name = row["company_name"]

        if pd.isna(company_name) or not company_name.strip():
            print(f"{RED}No company name found for row {index}{RESET}")
            continue

        print(
            f"{BLUE}Fetching LinkedIn master_active_data for {company_name}...{RESET}"
        )

        linkedin_url = row.get("linkedin_url")
        linkedin_data = fetch_company_data(linkedin_url)

        if not linkedin_data or "error" in linkedin_data:
            print(f"{RED}Failed to fetch data for {company_name}{RESET}")
            continue

        row, updated_attributes = map_linkedin_data_to_company(row, linkedin_data)

        if updated_attributes:
            print(
                f"{GREEN}Updated attributes for {company_name}: {', '.join(updated_attributes)}{RESET}"
            )

        try:
            print(
                f"{BLUE}Updating Google Sheet after processing {company_name}...{RESET}"
            )
            update_google_sheet(
                credentials_path, master_sheet_id, active_range_name, master_active_data
            )
        except Exception as e:
            print(f"{RED}An error occurred during Google Sheet update: {e}{RESET}")

    return master_active_data

def filter_active_companies(
    master_data,
    master_sheet_id,
    active_range_name,
    credentials_path,
    master_linkedin_issues_range_name,
    master_range_name,
):
    """
    Filter companies with active LinkedIn URLs and add them to the "active" spreadsheet.
    """

    active_data = []
    problem_data = []

    existing_active_data = pd.DataFrame(columns=master_data.columns)
    existing_problem_data = pd.DataFrame(columns=master_data.columns)

    for index, row in master_data.iterrows():
        company_name = row["company_name"]
        linkedin_url = row.get("linkedin_url")

        print(f"{BLUE}Checking LinkedIn URL for {company_name}...{RESET}")

        if pd.isna(linkedin_url) or not linkedin_url.strip():
            master_data.at[index, "operating_status"] = False
            print(f"{RED}No LinkedIn URL found for {company_name}{RESET}")
            problem_data.append(row)
            continue

        try:
            headers = {
                "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
            }
            response = requests.head(
                linkedin_url, headers=headers, allow_redirects=True, timeout=5
            )
            print(f"response: {response.status_code}")

            if response.status_code == 200:
                print(f"{GREEN}Active LinkedIn URL found for {company_name}{RESET}")

                master_data.at[index, "operating_status"] = True

                updated_row = row.copy()
                updated_row["operating_status"] = True
                active_data.append(updated_row)

                existing_problem_data = existing_problem_data[
                    existing_problem_data["company_name"] != company_name
                ]

            elif response.status_code == 404:
                print(f"{RED}LinkedIn URL not found (404) for {company_name}{RESET}")
                master_data.at[index, "operating_status"] = False

                existing_active_data = existing_active_data[
                    existing_active_data["company_name"] != company_name
                ]
                existing_problem_data = existing_problem_data[
                    existing_problem_data["company_name"] != company_name
                ]

            else:
                print(
                    f"{RED}Request issue for {company_name}: HTTP {response.status_code}{RESET}"
                )
                problem_row = row.copy()
                problem_data.append(problem_row)

                existing_active_data = existing_active_data[
                    existing_active_data["company_name"] != company_name
                ]

        except requests.RequestException as e:
            print(f"{RED}Error checking LinkedIn URL for {company_name}: {e}{RESET}")

            problem_row = row.copy()
            problem_data.append(problem_row)
            existing_active_data = existing_active_data[
                existing_active_data["company_name"] != company_name
            ]

    if active_data:
        active_df = pd.DataFrame(active_data, columns=master_data.columns)
        updated_active_data = pd.concat(
            [existing_active_data, active_df]
        ).drop_duplicates(subset="company_name")
        update_google_sheet(
            credentials_path, master_sheet_id, active_range_name, updated_active_data
        )

        print(
            f"{GREEN} existing_active_data length : {len(existing_active_data)}{RESET}"
        )
        print(
            f"{GREEN}Updated 'active' spreadsheet with {len(active_data)} companies.{RESET}"
        )

    if problem_data:
        problem_df = pd.DataFrame(problem_data, columns=master_data.columns)

        updated_problem_data = pd.concat(
            [existing_problem_data, problem_df]
        ).drop_duplicates(subset="company_name")
        update_google_sheet(
            credentials_path,
            master_sheet_id,
            master_linkedin_issues_range_name,
            updated_problem_data,
        )

        print(
            f"{RED} existing_problem_data length : {len(existing_problem_data)}{RESET}"
        )
        print(
            f"{RED}Updated 'LinkedIn issues' spreadsheet with {len(problem_data)} companies.{RESET}"
        )

    else:
        print(f"{BLUE}No active companies found to update.{RESET}")

    update_google_sheet(
        credentials_path, master_sheet_id, master_range_name, master_data
    )
    print(f"{BLUE}Master data sheet updated with all changes.{RESET}")

def update_companies_to_google_sheet(
    credentials_path, sheet_id, sheet_range, filtered_companies
):
    """
    Updates a Google Sheet with filtered companies' LinkedIn data in batches.

    Args:
        credentials_path (str): Path to the Google service account JSON credentials file.
        sheet_id (str): ID of the Google Sheet.
        sheet_range (str): Name of the sheet or range (e.g., 'Sheet1').
        filtered_companies (list[dict]): List of companies to process and update.
    """
    company_size_data = fetch_company_sizes()  
    batch_updates = []

    for company in filtered_companies:
        company_name = company.get("company_name")
        linkedin_url = company.get("linkedin_url")

        if not company_name or not linkedin_url:
            print(f"{RED}Skipping company with missing name or LinkedIn URL.{RESET}")
            continue


        row, updated_attributes = map_linkedin_data_to_newcompany(company, linkedin_data)

        if updated_attributes:
            print(f"{GREEN}Updated attributes for {company_name}: {', '.join(updated_attributes)}{RESET}")

            batch_updates.append(
                {
                    "range": f"{sheet_range}!A{row['row_index']}:Z{row['row_index']}",
                    "values": [list(row.values())],  # Convert the row dict to a list
                }
            )

    if batch_updates:
        try:
            print(f"{BLUE}Performing batch update for {len(batch_updates)} companies...{RESET}")
            batch_update_google_sheet(credentials_path, sheet_id, batch_updates)
        except Exception as e:
            print(f"{RED}Batch update failed: {e}{RESET}")
    else:
        print(f"{RED}No updates to perform. Check the filtered companies list.{RESET}")
