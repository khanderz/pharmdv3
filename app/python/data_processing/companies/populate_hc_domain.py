from app.python.ai_processing.company_extraction.train_company_extraction import (
    inspect_company_predictions,
)
from app.python.ai_processing.utils.logger import BLUE, GREEN, RED, RESET
from app.python.data_processing.companies.google_sheets_updater import (
    update_google_sheet_row,
)


def process_and_update_sheet(
    credentials_path, sheet_id, master_active_data, master_linkedin_issues_sheet_name
):
    if (
        "company_description" not in master_active_data.columns
        or "healthcare_domain" not in master_active_data.columns
    ):
        print("Missing 'company_description' or 'healthcare_domain' column in sheet.")
        return

    for index, row in master_active_data.iterrows():
        company_name = row.get("company_name")
        company_description = row.get("company_description", "")
        healthcare_domains = row.get("healthcare_domain")

        if not company_description:
            print(
                f"{RED}Skipping row {index+1} (no description provided for {company_name}).{RESET}"
            )
            continue

        try:
            _, biluo_tags = inspect_company_predictions(company_description)
            healthcare_domains = [
                token.ent_type_ for token, tag in zip(_, biluo_tags) if tag != "O"
            ]

            healthcare_domains_str = ", ".join(set(healthcare_domains))

            master_active_data.at[index, "healthcare_domain"] = healthcare_domains_str
            updated_row = master_active_data.loc[index]
            row_data = updated_row.fillna("").astype(str).tolist()

            print(
                f"{BLUE}HC domain found for {company_name}: {healthcare_domains_str}{RESET}"
            )
            update_google_sheet_row(
                credentials_path,
                sheet_id,
                master_linkedin_issues_sheet_name,
                row_index=index + 1,
                data=row_data,
            )
            print(f"{GREEN}HC domain processed for {company_name}.{RESET}")
        except Exception as e:
            print(
                f"{RED}An error occurred during Google Sheet update for {company_name}: {e}{RESET}"
            )
