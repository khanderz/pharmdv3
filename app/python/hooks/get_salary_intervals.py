#  app/python/hooks/get_currencies.py
import requests

def fetch_salary_intervals():
    try:
        response = requests.get("http://localhost:3000/job_salary_intervals.json")
        response.raise_for_status()  
        return response.json()
    except requests.exceptions.RequestException as e:
        print(f"Error fetching salary intervals: {e}")
        return None
    
salary_interval_data = fetch_salary_intervals()

def get_salary_interval(interval_text):
    if not salary_interval_data:
        return None
    
    for interval in salary_interval_data:
        if interval["interval"] == interval_text:
            return interval["id"]
    return None
