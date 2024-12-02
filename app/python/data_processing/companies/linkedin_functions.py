# app/python/data_processing/companies/utils/linkedin_functions.pyimport requests
import pandas as pd
import requests
from app.python.ai_processing.utils.logger import BLUE, GREEN, RED, RESET
from app.python.data_processing.companies.google_sheets_updater import (
    update_google_sheet,
    update_google_sheet_row,
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
                print(f"{RED}Error updating Google Sheet for {company_name}: {e}{RESET}")
        else:
            print(f"{BLUE}No updates needed for {company_name}. Skipping Google Sheet update.{RESET}")

    print(f"{GREEN}Company data seeding completed successfully!{RESET}")

def enrich_with_linkedin_data(
    master_active_data, credentials_path, master_sheet_id, active_range_name
):
    """
    Enrich data with LinkedIn company details using the LinkedIn API hook.
    """

    company_size_data = fetch_company_sizes()

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

        updated_attributes = []

        # if pd.isna(row.get("last_funding_type")) or not row["last_funding_type"]:
        #     master_active_data.at[index, "last_funding_type"] = linkedin_data.get("fundingType")

        if pd.isna(row.get("company_url")) or not row["company_url"]:
            master_active_data.at[index, "company_url"] = linkedin_data.get("website")
            updated_attributes.append("company_url")

        if pd.isna(row.get("logo_url")) or not row["logo_url"]:
            master_active_data.at[index, "logo_url"] = linkedin_data.get(
                "profile_pic_url"
            )

        # if pd.isna(row.get("is_public")) or not row["is_public"]:
        #     company_type = linkedin_data.get("companyType", {}).get("code")
        #     if company_type == "PRIVATELY_HELD":
        #         master_active_data.at[index, "is_public"] = False
        #     elif company_type == "PUBLIC_COMPANY":
        #         master_active_data.at[index, "is_public"] = True
        #     else:
        #         master_active_data.at[index, "is_public"] = False

        #     updated_attributes.append("is_public")

        if pd.isna(row.get("year_founded")) or not row["year_founded"]:
            master_active_data.at[index, "year_founded"] = linkedin_data.get(
                "founded_year"
            )
            updated_attributes.append("year_founded")

        master_active_data.at[index, "company_description"] = linkedin_data.get(
            "description"
        )
        updated_attributes.append("company_description")

        if linkedin_data.get("tagline") is not None:
            master_active_data.at[index, "company_tagline"] = linkedin_data.get(
                "tagline"
            )
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
                    master_active_data.at[index, "company_countries"] = (
                        current_countries
                    )
                    updated_attributes.append("company_countries")

                current_states = safely_parse_list(row.get("company_states"))
                if state and state not in current_states:
                    current_states.append(state)
                    master_active_data.at[index, "company_states"] = current_states
                    updated_attributes.append("company_states")

                current_cities = safely_parse_list(row.get("company_cities"))
                if city and city not in current_cities:
                    current_cities.append(city)
                    master_active_data.at[index, "company_cities"] = current_cities
                    updated_attributes.append("company_cities")

        if company_size_data is None:
            print(
                f"{RED}Error: Unable to fetch company size data. Skipping company size update.{RESET}"
            )
        else:
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
                        print(
                            f"{RED}Unexpected size_range format: '{size_range}' for company size data. Skipping.{RESET}"
                        )
                        continue

                    if min_size <= staff_count <= max_size:
                        master_active_data.at[index, "company_size"] = size_range
                        updated_attributes.append("company_size")
                        break

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

    # print(f"{GREEN}Summary of Updates:{RESET}")
    # for company, attributes in updates_summary.items():
    #     print(f"{BLUE}{company}{RESET}: Updated attributes - {', '.join(attributes)}")

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
