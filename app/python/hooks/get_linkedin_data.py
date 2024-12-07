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
                return {"error": f"Company fetch error: {response.text}"}

        return {"error": f"Failed after {retries} retries."}

    except Exception as e:
        print(f"Error occurred while fetching company data for {linkedin_url}: {e}")
        return {"error": f"Unexpected error: {str(e)}"}


# Example usage
# linkedin_url = "https://www.linkedin.com/company/23andme/"
# result = fetch_company_data(linkedin_url)


def search_companies(params, retries=3, backoff_factor=2):
    """
    Search for companies using the Proxycurl API with flexible query parameters.
    Includes retry logic for handling transient errors.

    Args:
        params (dict): Query parameters for the API call.
        retries (int): Number of retry attempts for the request.
        backoff_factor (int): Backoff multiplier for retry intervals.

    Returns:
        dict: API response as a JSON object, or an error message.
    """
    try:
        api_key = os.getenv("PROXYCURL_API_KEY")
        if not api_key:
            raise ValueError(
                "Proxycurl API key is missing. Set PROXYCURL_API_KEY in your environment variables."
            )

        headers = {"Authorization": f"Bearer {api_key}"}
        api_endpoint = "https://nubela.co/proxycurl/api/v2/search/company"

        for attempt in range(retries):
            response = requests.get(api_endpoint, params=params, headers=headers)

            if response.status_code == 200:
                return response.json()
            elif response.status_code in [503, 504]:
                print(
                    f"Retryable error ({response.status_code}) encountered. Retrying in {backoff_factor ** attempt} seconds..."
                )
                time.sleep(backoff_factor**attempt)
            else:
                return {
                    "error": f"Search failed with status {response.status_code}: {response.text}"
                }

        return {"error": f"Failed after {retries} retries."}

    except Exception as e:
        return {"error": f"Unexpected error: {str(e)}"}


def filter_healthcare_companies(search_response):
    """
    Filters the search response to include only companies with 'healthcare' in their specialties.

    Args:
        search_response (dict): The JSON response from the company search API.

    Returns:
        list: A list of filtered companies with 'healthcare' in their specialties.
    """
    try:
        results = search_response.get("results", [])
        if not results:
            return {"message": "No results found in the search response."}

        healthcare_companies = []
        for company in results:
            specialties = company.get("profile", {}).get("specialities", [])
            if "healthcare" in [s.lower() for s in specialties]:
                healthcare_companies.append(company)

        if not healthcare_companies:
            return {"message": "No companies with 'healthcare' in specialties."}

        return healthcare_companies

    except Exception as e:
        return {"error": f"Unexpected error: {str(e)}"}
