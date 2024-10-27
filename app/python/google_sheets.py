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
    data = pd.DataFrame(values[1:], columns=headers) if len(values) > 1 else pd.DataFrame(columns=headers)
    return data

# Load master sheet
master_sheet_id = '17iuCwmJOrik5WS8LZqhuQom4xjNvpbJF3O-vZ5kgFqs'
master_range_name = 'master!A:Q'
master_data = load_sheet_data(master_sheet_id, master_range_name)

# Load zapier sheet
zapier_sheet_id = '1cGhpgWgX0CH5QtyhvkR0oHeFbcLQgTFEmzYvxPwRKog'   
zapier_range_name = 'Sheet1!A:O'
zapier_data = load_sheet_data(zapier_sheet_id, zapier_range_name)

# load hubspot sheet
hubspot_sheet_id = '1S5E55ObK_U2DDizBWWezOOjwIPVq0BAeOMg1pQbOEc8'
hubspot_range_name = 'all-companies!A:U'
hubspot_data = load_sheet_data(hubspot_sheet_id, hubspot_range_name)

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
    
    master_data = pd.concat([master_data, zapier_data], ignore_index=True)
    return master_data

filled_master_data = transfer_data(master_data, zapier_data)

# Remove NaN values and newlines
filled_master_data = filled_master_data.fillna('').applymap(lambda x: str(x).replace('\n', ' ') if isinstance(x, str) else x)

# Check filled data
print("Filled Master Data (after transfer):")
print(filled_master_data.head())


# def fill_missing_values(master_data, hubspot_data):
#     # Rename zapier columns to match master data structure
#     zapier_data = zapier_data.rename(columns={
#         'organization_name': 'company_name',
#         'description': 'company_description',
#         'number_of_employees': 'company_size',
#         'last_funding_type': 'last_funding_type',
#         'city': 'company_cities',
#         'region': 'company_states',
#         'country': 'company_countries'
#     })
    
#     # Print initial samples for debugging
#     print("Master Data (sample):")
#     print(master_data.head())
#     print("\nZapier Data (sample after renaming):")
#     print(zapier_data.head())

#     for index, row in master_data.iterrows():
#         zapier_row = zapier_data[zapier_data['company_name'] == row['company_name']]
        
#         if zapier_row.empty:
#             print(f"No match found in zapier_data for {row['company_name']}")
#         else:
#             print(f"Match found for {row['company_name']}")
#             for column in master_data.columns:
#                 if pd.isna(row[column]) and not pd.isna(zapier_row.iloc[0][column]):
#                     print(f"Updating {column} for {row['company_name']}: {row[column]} -> {zapier_row.iloc[0][column]}")
#                     master_data.at[index, column] = zapier_row.iloc[0][column]
    
#     return master_data

# # Fill missing values in the master sheet
# filled_master_data = fill_missing_values(master_data, hubspot_data)

# Verify filled data
print("Filled Master Data:")
print(filled_master_data.head())

def update_google_sheet(sheet_id, range_name, data):
    credentials_path = os.getenv("GOOGLE_CREDENTIALS_PATH")
    creds = service_account.Credentials.from_service_account_file(credentials_path)
    service = build('sheets', 'v4', credentials=creds)
    
    # Limit columns to match Google Sheets range
    data = data.iloc[:, :17]  
    
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

# Update master sheet with filled data
update_google_sheet(master_sheet_id, master_range_name, filled_master_data)
