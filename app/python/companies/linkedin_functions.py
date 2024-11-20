# app/python/companies/utils/linkedin_functions.pyimport requests
import pandas as pd
import requests
from app.python.hooks.get_company_sizes import fetch_company_sizes, get_company_size
from app.python.hooks.get_linkedin_data import fetch_company_data
from app.python.utils.logger import BLUE, RED, RESET, GREEN
from app.python.companies.google_sheets_updater import update_google_sheet

def enrich_with_linkedin_data(master_active_data, linkedin_username, linkedin_pw):
    """
    Enrich data with LinkedIn company details using the LinkedIn API hook.
    """

    company_size_data = fetch_company_sizes()

    for index, row in master_active_data.iterrows():
        company_name = row["company_name"]

        if pd.isna(company_name) or not company_name.strip():
            print(f"{RED}No company name found for row {index}{RESET}")
            continue

        print(f"{BLUE}Fetching LinkedIn master_active_data for {company_name}...{RESET}")

        linkedin_data = fetch_company_data(company_name, linkedin_username, linkedin_pw)

        if not linkedin_data or "error" in linkedin_data:
            print(f"{RED}Failed to fetch data for {company_name}{RESET}")
            continue

        if pd.isna(row.get("last_funding_type")) or not row["last_funding_type"]:
            master_active_data.at[index, "last_funding_type"] = linkedin_data.get("fundingType")

        if pd.isna(row.get("company_url")) or not row["company_url"]:
            master_active_data.at[index, "company_url"] = linkedin_data.get("companyPageUrl")

        if pd.isna(row.get("is_public")) or not row["is_public"]:
            company_type = linkedin_data.get("companyType", {}).get("code")
            if company_type == "PRIVATELY_HELD":
                master_active_data.at[index, "is_public"] = False
            elif company_type == "PUBLIC":
                master_active_data.at[index, "is_public"] = True
                
        if pd.isna(row.get("year_founded")) or not row["year_founded"]:
            year_founded = linkedin_data.get("foundedOn", {}).get("year")
            master_active_data.at[index, "year_founded"] = year_founded

        if pd.isna(row.get("company_description")) or not row["company_description"]:
            master_active_data.at[index, "company_description"] = linkedin_data.get("description")

        company_tagline = linkedin_data.get("tagline")    
        if company_tagline:
            master_active_data.at[index, "company_tagline"] = company_tagline

        confirmed_locations = linkedin_data.get("confirmedLocations", [])
        if confirmed_locations:
            for location in confirmed_locations:
                country = location.get("country")
                geographic_area = location.get("geographicArea")
                city = location.get("city")

                current_countries = row.get("company_countries") or []
                if isinstance(current_countries, str):
                    current_countries = eval(current_countries) if current_countries else []
                if country and country not in current_countries:
                    current_countries.append(country)
                    master_active_data.at[index, "company_countries"] = current_countries

                current_states = row.get("company_states") or []
                if isinstance(current_states, str):
                    current_states = eval(current_states) if current_states else []
                if geographic_area and geographic_area not in current_states:
                    current_states.append(geographic_area)
                    master_active_data.at[index, "company_states"] = current_states

                current_cities = row.get("company_cities") or []
                if isinstance(current_cities, str):
                    current_cities = eval(current_cities) if current_cities else []
                if city and city not in current_cities:
                    current_cities.append(city)
                    master_active_data.at[index, "company_cities"] = current_cities

        if company_size_data is None:
            print(f"{RED}Error: Unable to fetch company size data. Skipping company size update.{RESET}")
        else:
            staff_count = linkedin_data.get("staffCount")
            if staff_count is not None:
                for size in company_size_data:
                    size_range = size["size_range"]
                    min_size, max_size = size_range.replace("+", "").split("-")
                    min_size = int(min_size)
                    max_size = float("inf") if "+" in size_range else int(max_size)

                    if min_size <= staff_count <= max_size:
                        master_active_data.at[index, "company_size"] = size_range
                        break


    return master_active_data

def filter_active_companies(master_data, master_sheet_id, active_range_name, credentials_path, master_linkedin_issue_data):
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
        update_google_sheet(credentials_path, master_sheet_id, active_range_name, active_df)
        print(f"{GREEN}Updated 'active' spreadsheet with {len(active_data)} companies.{RESET}")
        
    if problem_data:
        problem_df = pd.DataFrame(problem_data, columns=master_data.columns)
        update_google_sheet(credentials_path, master_sheet_id, master_linkedin_issue_data, problem_df)
        print(f"{RED}Updated 'LinkedIn issues' spreadsheet with {len(problem_data)} companies.{RESET}")    
    else:
        print(f"{BLUE}No active companies found to update.{RESET}")
