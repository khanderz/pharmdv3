from app.python.ai_processing.company_extraction.train_company_extraction import (
    inspect_company_predictions,
)
from app.python.ai_processing.utils.logger import BLUE, GREEN, RED, RESET

from app.python.data_processing.companies.google_sheets_updater import (
    batch_update_google_sheet,
    update_google_sheet_row,
)
from collections import Counter
from googleapiclient.errors import HttpError
import time


def process_predictions(tokens, biluo_tags, max_domains=3, min_frequency=2):
    domain_counts = Counter(
        token.ent_type_ for token, tag in zip(tokens, biluo_tags) if tag != "O"
    )

    filtered_domains = [
        domain for domain, count in domain_counts.items() if count >= min_frequency
    ]

    if not filtered_domains:
        filtered_domains = [
            domain for domain, _ in domain_counts.most_common(max_domains)
        ]

    top_domains = sorted(
        filtered_domains, key=lambda domain: domain_counts[domain], reverse=True
    )[:max_domains]

    return top_domains


def retry_with_backoff(func, max_retries=10, *args, **kwargs):
    """Retry a function with exponential backoff."""
    delay = 1
    for attempt in range(max_retries):
        try:
            return func(*args, **kwargs)
        except HttpError as e:
            if e.resp.status == 429 and "RATE_LIMIT_EXCEEDED" in str(e):
                print(
                    f"{RED}Rate limit exceeded. Retrying in {delay} seconds... (Attempt {attempt + 1}/{max_retries}){RESET}"
                )
                time.sleep(delay)
                delay = min(delay * 2, 60)
            else:
                raise
    return False


def process_and_update_sheet(credentials_path, sheet_id, data, sheet_name):
    if (
        "company_description" not in data.columns
        or "healthcare_domain" not in data.columns
    ):
        print("Missing 'company_description' or 'healthcare_domain' column in sheet.")
        return

    batch_updates = []

    header_range = f"{sheet_name}!A1:{chr(65 + len(data.columns) - 1)}1"
    batch_updates.append({"range": header_range, "values": [data.columns.tolist()]})

    for index, row in data.iterrows():
        company_name = row.get("company_name")
        company_description = row.get("company_description", "")
        existing_domains = row.get("healthcare_domain", "")

        if existing_domains:
            print(
                f"{BLUE}Skipping row {index+1} (domain already exists for {company_name}).{RESET}"
            )
            continue

        if not company_description:
            print(
                f"{RED}Skipping row {index+1} (no description provided for {company_name}).{RESET}"
            )
            continue

        try:
            tokens, biluo_tags = inspect_company_predictions(company_description)
            top_domains = process_predictions(tokens, biluo_tags)
            healthcare_domains_str = ", ".join(top_domains)

            data.at[index, "healthcare_domain"] = healthcare_domains_str

            updated_row = data.loc[index]
            row_data = updated_row.fillna("").astype(str).tolist()

            print(
                f"{BLUE}HC domain found for {company_name}: {healthcare_domains_str}{RESET}"
            )

            start_column = "A"
            end_column = chr(65 + len(row_data) - 1)
            range_to_update = (
                f"{sheet_name}!{start_column}{index + 2}:{end_column}{index + 2}"
            )
            batch_updates.append({"range": range_to_update, "values": [row_data]})

        except Exception as e:
            print(
                f"{RED}An error occurred during processing for {company_name}: {e}{RESET}"
            )

    if batch_updates:
        print("Performing batch update...")
        try:
            retry_with_backoff(
                batch_update_google_sheet,
                credentials_path=credentials_path,
                sheet_id=sheet_id,
                updates=batch_updates,
            )
            print(f"{GREEN}Batch update completed successfully.{RESET}")
        except Exception as e:
            print(f"{RED}Batch update failed: {e}{RESET}")
