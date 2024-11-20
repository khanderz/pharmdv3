from linkedin_api import Linkedin
import os
from dotenv import load_dotenv

load_dotenv()

def fetch_company_data(company_name, username, password):
    """
    Fetch company data from LinkedIn using a linkedin-api library.
    """
    try:
        api = Linkedin(username, password)
        print(f"Authenticated as {username}")
        
        try:
            company = api.get_company(company_name)
            print(f"Fetched company data for {company_name}")
            return company
        
        except Exception as e:
            print(f"Error fetching company data for {company_name}: {e}")
            return {"error": f"Company fetch error: {str(e)}"}

    except Exception as e:
        print(f"Failed to authenticate with LinkedIn: {e}")
        return {"error": f"Authentication error: {str(e)}"}

if __name__ == "__main__":
    USERNAME = os.getenv("LINKEDIN_USERNAME")
    PASSWORD = os.getenv("LINKEDIN_PASSWORD")

    COMPANY_NAME = "91181613"

    company_data = fetch_company_data(COMPANY_NAME, USERNAME, PASSWORD)
    print(company_data)
