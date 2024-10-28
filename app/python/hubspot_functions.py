# hubspot_functions.py
import pandas as pd

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

def fill_missing_values_with_hubspot(master_data, hubspot_data):
    hubspot_data['company_name'] = hubspot_data['company_name'].str.lower().str.strip()
    for index, row in master_data.iterrows():
        company_name = str(row['company_name']).strip().lower()
        hubspot_row = hubspot_data[hubspot_data['company_name'] == company_name]
        
        if not hubspot_row.empty:
            print(f"Updating data for company: {company_name}")

            for column in ['company_url', 'is_public', 'logo_url', 'year_founded', 'linkedin_url']:
                if pd.isna(row.get(column, '')) or row[column] == '':
                    new_value = hubspot_row.iloc[0].get(column, '')
                    print(f"Setting {column} for {company_name} to {new_value}")
                    master_data.at[index, column] = new_value

            for loc_column in ['company_cities', 'company_states', 'company_countries']:
                master_value = row.get(loc_column, '')
                hubspot_value = hubspot_row.iloc[0].get(loc_column, '').strip()

                master_values = master_value.split(', ') if master_value else []
                if hubspot_value and hubspot_value not in master_values:
                    master_values.append(hubspot_value)
                    master_data.at[index, loc_column] = ', '.join(master_values)
                    print(f"Appended {hubspot_value} to {loc_column} for {company_name}")
        else:
            print(f"No matching HubSpot data found for company: {company_name}")

    return master_data
