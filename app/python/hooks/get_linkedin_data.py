# app/python/hooks/get_linkedin_data.py
import os
import requests
from dotenv import load_dotenv

load_dotenv()

def fetch_company_data(linkedin_url):
    """
    Fetch company data from LinkedIn using the Proxycurl API.
    """
    try:
        proxycurl_key = os.getenv("PROXYCURL_API_KEY")
        if not proxycurl_key:
            raise ValueError("Proxycurl API key is missing. Set PROXYCURL_API_KEY in your environment variables.")
        
        headers = {
            "Authorization": f"Bearer {proxycurl_key}"
        }
        
        params = {
            "url": linkedin_url,  
            # "categories": "include", #TODO: might consider later for industry attribute
            # "funding_data": "include", #TODO: might consider later for last_funding_type attribute
            # "exit_data": "include",
            # "acquisitions": "include", # TODO: might consider later for acquired_by attribute
            # "extra": "include", #TODO: might consider later for ipo_status, operating_status
            "use_cache": "if-present",
            "fallback_to_cache": "on-error"
        }
        
        api_url = "https://nubela.co/proxycurl/api/linkedin/company"

        print(f"Fetching company data with URL: {api_url} and Params: {params}")
        response = requests.get(api_url, headers=headers, params=params)

        if response.status_code == 200:
            company_data = response.json()
            print(f"Fetched company data for {linkedin_url}: {company_data}")
            return company_data
        else:
            print(f"Failed to fetch company data for {linkedin_url}. Status Code: {response.status_code}, Response: {response.text}")
            return {"error": f"Company fetch error: {response.text}"}

    except Exception as e:
        print(f"Error occurred while fetching company data for {linkedin_url}: {e}")
        return {"error": f"Unexpected error: {str(e)}"}

# Example usage
if __name__ == "__main__":
    linkedin_url = "https://www.linkedin.com/company/23andme/"   
    result = fetch_company_data(linkedin_url)
