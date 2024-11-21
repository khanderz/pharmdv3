# app/python/data_processing/companies/utils/cleaner.py

def remove_duplicates(data):
    data["company_name"] = data["company_name"].str.lower().str.strip()

    if "linkedin_url" in data.columns:
        data["linkedin_url"] = data["linkedin_url"].str.lower().str.strip()

    relevant_columns = ["company_name", "linkedin_url"]

    initial_count = len(data)
    duplicate_mask = data.duplicated(subset=relevant_columns, keep="first")
    duplicate_count = duplicate_mask.sum()

    data = data.drop_duplicates(subset=relevant_columns, keep="first").reset_index(drop=True)

    final_count = len(data)
    print(f"initial_count: {initial_count}")
    print(f"\nRemoved {initial_count - final_count} duplicate rows.")
    print(f"Remaining rows: {final_count}")

    return data
