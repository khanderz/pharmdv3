# app/python/companies/utils/cleaner.py

def remove_duplicates(data):
    data["company_name"] = data["company_name"].str.lower().str.strip()
    initial_count = len(data)
    data = data.drop_duplicates(subset="company_name", keep="first").reset_index(
        drop=True
    )
    final_count = len(data)
    print(f"Removed {initial_count - final_count} duplicate rows.")
    return data
