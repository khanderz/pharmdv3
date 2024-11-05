# zapier_functions.py
import pandas as pd


def transfer_data(master_data, zapier_data):
    zapier_data = zapier_data.rename(
        columns={
            "organization_name": "company_name",
            "description": "company_description",
            "number_of_employees": "company_size",
            "last_funding_type": "last_funding_type",
            "city": "company_cities",
            "region": "company_states",
            "country": "company_countries",
        }
    )

    zapier_data["company_name"] = zapier_data["company_name"].str.lower().str.strip()
    existing_companies = set(master_data["company_name"].unique())
    zapier_data = zapier_data[~zapier_data["company_name"].isin(existing_companies)]

    master_data = pd.concat([master_data, zapier_data], ignore_index=True)
    print("Transferred Zapier data into master data.")
    return master_data
