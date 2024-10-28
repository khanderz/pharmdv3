# google_sheet_helper.py
import os
from dotenv import load_dotenv
from google.oauth2 import service_account
from googleapiclient.discovery import build
import pandas as pd

load_dotenv()

def load_sheet_data(sheet_id, range_name):
    credentials_path = os.getenv("GOOGLE_CREDENTIALS_PATH")
    creds = service_account.Credentials.from_service_account_file(credentials_path)
    service = build('sheets', 'v4', credentials=creds)
    sheet = service.spreadsheets()
    result = sheet.values().get(spreadsheetId=sheet_id, range=range_name).execute()
    values = result.get('values', [])
    
    headers = values[0] if values else []
    actual_columns_count = len(headers)
    cleaned_data = [row + [''] * (actual_columns_count - len(row)) for row in values[1:]]
    data = pd.DataFrame(cleaned_data, columns=headers)
    return data

def update_google_sheet(sheet_id, range_name, data):
    credentials_path = os.getenv("GOOGLE_CREDENTIALS_PATH")
    creds = service_account.Credentials.from_service_account_file(credentials_path)
    service = build('sheets', 'v4', credentials=creds)
    
    data = data.iloc[:, :18]  
    values = [data.columns.tolist()] + data.values.tolist()
    
    body = {'values': values}
    sheet = service.spreadsheets()
    
    try:
        result = sheet.values().update(
            spreadsheetId=sheet_id, range=range_name,
            valueInputOption='RAW', body=body).execute()
        print(f"{result.get('updatedCells')} cells updated.")
    except Exception as e:
        print(f"An error occurred during update: {e}")

def rename_hubspot_columns(hubspot_data):
    return hubspot_data.rename(columns={
        'Company name': 'company_name',
        'City': 'company_cities',
        'Country/Region': 'company_countries',
        'Website URL': 'company_url',
        'Is Public': 'is_public',
        'Logo URL': 'logo_url',
        'State/Region': 'company_states',
        'Year Founded': 'year_founded',
        'LinkedIn Company Page': 'linkedin_url'
    })

def transfer_data(master_data, zapier_data):
    zapier_data = zapier_data.rename(columns={
        'organization_name': 'company_name',
        'description': 'company_description',
        'number_of_employees': 'company_size',
        'last_funding_type': 'last_funding_type',
        'city': 'company_cities',
        'region': 'company_states',
        'country': 'company_countries'
    })
    
    existing_companies = set(master_data['company_name'].unique())
    zapier_data = zapier_data[~zapier_data['company_name'].isin(existing_companies)]
    
    master_data = pd.concat([master_data, zapier_data], ignore_index=True)
    return master_data

def remove_duplicates(data):
    initial_count = len(data)
    data = data.drop_duplicates(subset='company_name', keep='first').reset_index(drop=True)
    final_count = len(data)
    print(f"Removed {initial_count - final_count} duplicate rows.")
    return data

# Example usage
if __name__ == "__main__":
    master_sheet_id = os.getenv("MASTER_SHEET_ID")
    master_range_name = os.getenv("MASTER_RANGE_NAME")
    master_data = load_sheet_data(master_sheet_id, master_range_name)

    update_google_sheet(master_sheet_id, master_range_name, master_data)
