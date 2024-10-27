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

# Load master, zapier, and hubspot sheets
master_sheet_id = '17iuCwmJOrik5WS8LZqhuQom4xjNvpbJF3O-vZ5kgFqs'
master_range_name = 'master!A:R'
master_data = load_sheet_data(master_sheet_id, master_range_name)

# Ensure all required columns exist in master data before processing
required_columns = [
    'company_name', 'company_description', 'healthcare_domain', 'company_specialty',
    'company_ats_type', 'company_size', 'last_funding_type', 'linkedin_url', 'company_url', 
    'is_public', 'year_founded', 'operating_status', 'company_cities', 'company_states', 
    'company_countries', 'acquired_by', 'ats_id', 'logo_url'
]

for col in required_columns:
    if col not in master_data.columns:
        master_data[col] = ''  # Ensure the column exists with empty values



zapier_sheet_id = '1cGhpgWgX0CH5QtyhvkR0oHeFbcLQgTFEmzYvxPwRKog'   
zapier_range_name = 'Sheet1!A:O'
zapier_data = load_sheet_data(zapier_sheet_id, zapier_range_name)

hubspot_sheet_id = '1S5E55ObK_U2DDizBWWezOOjwIPVq0BAeOMg1pQbOEc8'
hubspot_range_name = 'all-companies!A:U'
hubspot_data = load_sheet_data(hubspot_sheet_id, hubspot_range_name)

print("Master Data Loaded Successfully")
print(master_data.head())
print(master_data.columns)

def rename_hubspot_columns(hubspot_data):
    hubspot_data = hubspot_data.rename(columns={
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
    return hubspot_data

hubspot_data = rename_hubspot_columns(hubspot_data)

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

filled_master_data = transfer_data(master_data, zapier_data)
filled_master_data = filled_master_data.fillna('').apply(lambda x: x.replace('\n', ' ') if isinstance(x, str) else x)

def fill_missing_values_with_hubspot(master_data, hubspot_data):
    # Iterate through master data rows and fill missing values from HubSpot
    for index, row in master_data.iterrows():
        hubspot_row = hubspot_data[hubspot_data['company_name'] == row['company_name']]
        
        if not hubspot_row.empty:
            # Fill each required column based on HubSpot data
            for column in ['company_url', 'is_public', 'logo_url', 'year_founded', 'linkedin_url']:
                if pd.isna(row.get(column, '')) or row[column] == '':
                    print(f"Updating {column} for {row['company_name']}: {row.get(column, '')} -> {hubspot_row.iloc[0].get(column, '')}")
                    master_data.at[index, column] = hubspot_row.iloc[0].get(column, '')

            # Handle city, state, and country by appending to array if missing
            for loc_column in ['company_cities', 'company_states', 'company_countries']:
                master_value = row.get(loc_column, '')
                hubspot_value = hubspot_row.iloc[0].get(loc_column, '')

                # Convert to list if master_value contains data
                master_values = master_value.split(', ') if master_value else []

                # Append hubspot_value if it's not empty and not already in the list
                if hubspot_value and hubspot_value not in master_values:
                    master_values.append(hubspot_value)
                    print(f"Appending {hubspot_value} to {loc_column} for {row['company_name']}")
                    master_data.at[index, loc_column] = ', '.join(master_values)
    
    return master_data



filled_master_data = fill_missing_values_with_hubspot(filled_master_data, hubspot_data)

# Function to remove duplicate rows based on 'company_name' and keep the first occurrence
def remove_duplicates(data):
    initial_count = len(data)
    data = data.drop_duplicates(subset='company_name', keep='first').reset_index(drop=True)
    final_count = len(data)
    print(f"Removed {initial_count - final_count} duplicate rows.")
    return data

# Remove duplicates from filled_master_data
filled_master_data = remove_duplicates(filled_master_data)

print("Filled Master Data:")
print(filled_master_data.columns)
print(filled_master_data.head())

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

update_google_sheet(master_sheet_id, master_range_name, filled_master_data)
