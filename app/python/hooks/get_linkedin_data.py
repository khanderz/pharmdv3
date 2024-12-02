import os
import requests
import time
from dotenv import load_dotenv

load_dotenv()


def fetch_company_data(linkedin_url, retries=3, backoff_factor=2):
    """
    Fetch company data from LinkedIn using the Proxycurl API, with retry logic
    for status codes 503 (Service Unavailable) and 504 (Gateway Timeout).
    """
    try:
        proxycurl_key = os.getenv("PROXYCURL_API_KEY")
        if not proxycurl_key:
            raise ValueError(
                "Proxycurl API key is missing. Set PROXYCURL_API_KEY in your environment variables."
            )

        headers = {"Authorization": f"Bearer {proxycurl_key}"}

        params = {
            "url": linkedin_url,
            "use_cache": "if-present",
            "fallback_to_cache": "on-error",
        }

        api_url = "https://nubela.co/proxycurl/api/linkedin/company"

        for attempt in range(retries):
            response = requests.get(api_url, headers=headers, params=params)

            if response.status_code == 200:
                company_data = response.json()
                return company_data
            elif response.status_code in [503, 504]:
                print(
                    f"Received status code {response.status_code}. Retrying in {backoff_factor ** attempt} seconds..."
                )
                time.sleep(backoff_factor**attempt)
            else:
                print(
                    f"Failed to fetch company data for {linkedin_url}. Status Code: {response.status_code}, Response: {response.text}"
                )
                return {"error": f"Company fetch error: {response.text}"}

        return {"error": f"Failed after {retries} retries."}

    except Exception as e:
        print(f"Error occurred while fetching company data for {linkedin_url}: {e}")
        return {"error": f"Unexpected error: {str(e)}"}


# Example usage
# linkedin_url = "https://www.linkedin.com/company/23andme/"
# result = fetch_company_data(linkedin_url)
