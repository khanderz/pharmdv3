# hubspot_functions.py
import pandas as pd


def rename_hubspot_columns(hubspot_data):
    return hubspot_data.rename(
        columns={
            "Company name": "company_name",
            "City": "company_cities",
            "Country/Region": "company_countries",
            "Website URL": "company_url",
            "Is Public": "is_public",
            "Logo URL": "logo_url",
            "State/Region": "company_states",
            "Year Founded": "year_founded",
            "LinkedIn Company Page": "linkedin_url",
            "LinkedIn Bio": "company_description",
            "Number of Employees": "company_size",
        }
    )


def fill_missing_values_with_hubspot(master_data, hubspot_data):
    hubspot_data["company_name"] = hubspot_data["company_name"].str.lower().str.strip()
    for _, hubspot_row in hubspot_data.iterrows():
        company_name = hubspot_row["company_name"]

        matching_master_row = master_data[master_data["company_name"] == company_name]

        if not matching_master_row.empty:
            print(f"Updating data for existing company: {company_name}")
            index = matching_master_row.index[0]

            for column in [
                "company_url",
                "is_public",
                "logo_url",
                "year_founded",
                "linkedin_url",
                "company_description",
                "company_size",
            ]:
                if (
                    pd.isna(master_data.at[index, column])
                    or master_data.at[index, column] == ""
                ):
                    new_value = hubspot_row.get(column, "")
                    print(f"Setting {column} for {company_name} to {new_value}")
                    master_data.at[index, column] = new_value

            for loc_column in ["company_cities", "company_states", "company_countries"]:
                master_value = master_data.at[index, loc_column] or ""
                hubspot_value = hubspot_row.get(loc_column, "").strip()

                master_values = master_value.split(", ") if master_value else []
                if hubspot_value and hubspot_value not in master_values:
                    master_values.append(hubspot_value)
                    master_data.at[index, loc_column] = ", ".join(master_values)
                    print(
                        f"Appended {hubspot_value} to {loc_column} for {company_name}"
                    )

        else:
            print(f"Adding new company: {company_name}")
            new_row = {
                "company_name": hubspot_row.get("company_name", ""),
                "company_cities": hubspot_row.get("company_cities", ""),
                "company_countries": hubspot_row.get("company_countries", ""),
                "company_description": hubspot_row.get("company_description", ""),
                "is_public": hubspot_row.get("is_public", ""),
                "logo_url": hubspot_row.get("logo_url", ""),
                "company_size": hubspot_row.get("company_size", ""),
                "company_states": hubspot_row.get("company_states", ""),
                "company_url": hubspot_row.get("company_url", ""),
                "year_founded": hubspot_row.get("year_founded", ""),
                "linkedin_url": hubspot_row.get("linkedin_url", ""),
            }

            # Use pd.concat to add the new row
            new_row_df = pd.DataFrame([new_row])
            master_data = pd.concat([master_data, new_row_df], ignore_index=True)

    return master_data
