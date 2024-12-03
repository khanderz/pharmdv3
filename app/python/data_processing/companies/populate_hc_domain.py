from app.python.ai_processing.company_extraction.train_company_extraction import (
    inspect_company_predictions,
)
from app.python.ai_processing.utils.logger import BLUE, GREEN, RED, RESET

from app.python.data_processing.companies.google_sheets_updater import (
    update_google_sheet_row,
)
from collections import Counter

def process_predictions(tokens, biluo_tags, company_name, max_domains=5, min_frequency=2):
    domain_counts = Counter(
        token.ent_type_ for token, tag in zip(tokens, biluo_tags) if tag != "O"
    )

    print(f"Domain Counts: {domain_counts}")

    filtered_domains = [domain for domain, count in domain_counts.items() if count >= min_frequency]

    if not filtered_domains:
        print(f"{RED}No domains met the frequency criteria for {company_name}. Falling back to top domains.{RESET}")
        filtered_domains = [domain for domain, _ in domain_counts.most_common(max_domains)]

    top_domains = filtered_domains[:max_domains]

    if not top_domains:
        print(f"{RED}No valid domains found for {company_name}.{RESET}")
    else:
        print(f"{BLUE}Top domains for {company_name}: {', '.join(top_domains)}{RESET}")

    return top_domains

def process_and_update_sheet(credentials_path, sheet_id, data, sheet_name):
    if (
        "company_description" not in data.columns
        or "healthcare_domain" not in data.columns
    ):
        print("Missing 'company_description' or 'healthcare_domain' column in sheet.")
        return

    for index, row in data.iterrows():
        company_name = row.get("company_name")
        company_description = row.get("company_description", "")
        healthcare_domains = row.get("healthcare_domain")

        if not company_description:
            print(
                f"{RED}Skipping row {index+1} (no description provided for {company_name}).{RESET}"
            )
            continue

        try:
            tokens, biluo_tags = inspect_company_predictions(company_description)

            process_predictions(tokens, biluo_tags, company_name)

        except Exception as e:
            print(
                f"{RED}An error occurred during Google Sheet update for {company_name}: {e}{RESET}"
            )    
        #     domain_counts = Counter(
        #         token.ent_type_ for token, tag in zip(tokens, biluo_tags) if tag != "O"
        #     )

        #     top_domains = [domain for domain, _ in domain_counts.most_common(5)]
        #     healthcare_domains_str = ", ".join(top_domains)

        #     data.at[index, "healthcare_domain"] = healthcare_domains_str
        #     updated_row = data.loc[index]
        #     row_data = updated_row.fillna("").astype(str).tolist()

        #     print(
        #         f"{BLUE}HC domain found for {company_name}: {healthcare_domains_str}{RESET}"
        #     )
        #     update_google_sheet_row(
        #         credentials_path,
        #         sheet_id,
        #         sheet_name,
        #         row_index=index + 1,
        #         data=row_data,
        #     )
        #     print(f"{GREEN}HC domain processed for {company_name}.{RESET}")
        # except Exception as e:
        #     print(
        #         f"{RED}An error occurred during Google Sheet update for {company_name}: {e}{RESET}"
        #     )
