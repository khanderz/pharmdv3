# main.py
import os
from dotenv import load_dotenv
import pandas as pd
from google_sheets_updater import load_sheet_data, update_google_sheet, remove_duplicates
from hubspot_functions import rename_hubspot_columns, fill_missing_values_with_hubspot
from zapier_functions import transfer_data

load_dotenv()

if __name__ == "__main__":
    master_sheet_id = os.getenv("MASTER_SHEET_ID")
    master_range_name = os.getenv("MASTER_RANGE_NAME")
    hubspot_sheet_id = os.getenv("HUBSPOT_SHEET_ID")
    hubspot_range_name = os.getenv("HUBSPOT_RANGE_NAME")
    zapier_sheet_id = os.getenv("ZAPIER_SHEET_ID")
    zapier_range_name = os.getenv("ZAPIER_RANGE_NAME")
    
    master_data = load_sheet_data(master_sheet_id, master_range_name)
    hubspot_data = load_sheet_data(hubspot_sheet_id, hubspot_range_name)
    # zapier_data = load_sheet_data(zapier_sheet_id, zapier_range_name)
    
    hubspot_data = rename_hubspot_columns(hubspot_data)
    master_data = fill_missing_values_with_hubspot(master_data, hubspot_data)
    # master_data = transfer_data(master_data, zapier_data)
    
    master_data = remove_duplicates(master_data)
    
    update_google_sheet(master_sheet_id, master_range_name, master_data)
