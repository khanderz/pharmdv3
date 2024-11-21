# app/python/data_processing/companies/google_sheets_updater.py
from google.oauth2 import service_account
from googleapiclient.discovery import build
import pandas as pd

from app.python.ai_processing.utils.logger import GREEN, RED, RESET


def load_sheet_data(credentials_path, sheet_id, range_name):
    creds = service_account.Credentials.from_service_account_file(credentials_path)
    service = build("sheets", "v4", credentials=creds)
    sheet = service.spreadsheets()
    result = sheet.values().get(spreadsheetId=sheet_id, range=range_name).execute()
    values = result.get("values", [])

    headers = values[0] if values else []
    actual_columns_count = len(headers)
    cleaned_data = [
        row + [""] * (actual_columns_count - len(row)) for row in values[1:]
    ]
    data = pd.DataFrame(cleaned_data, columns=headers)

    if "company_name" in data.columns:
        data["company_name"] = data["company_name"].str.lower().str.strip()
    else:
        print(f"{RED}Warning: 'company_name' column is missing from the loaded data.{RESET}")

    return data


def update_google_sheet(credentials_path, sheet_id, range_name, data):
    data = data.fillna("").astype(str)
    data = data.iloc[:, :19]

    values = [data.columns.tolist()] + data.values.tolist()

    body = {"values": values}
    creds = service_account.Credentials.from_service_account_file(credentials_path)
    service = build("sheets", "v4", credentials=creds)
    sheet = service.spreadsheets()

    try:
        result = (
            sheet.values()
            .update(
                spreadsheetId=sheet_id,
                range=range_name,
                valueInputOption="RAW",
                body=body,
            )
            .execute()
        )
        print(f"{GREEN}{result.get('updatedCells')} cells updated.{RESET}")
    except Exception as e:
        print(f"{RED}An error occurred during update: {e}{RESET}")

