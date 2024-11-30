# app/python/hooks/get_ats_types.py

import requests


def fetch_ats_types():
    """
    Fetches the ATS types and appends domain matching URLs to each entry.
    """
    try:
        response = requests.get("http://localhost:3000/api/ats_types")
        response.raise_for_status()
        ats_types = response.json()

        domain_matched_urls = {
            "ASHBYHQ": "https://jobs.ashbyhq.com/*",
            "BAMBOOHR": "https://*.bamboohr.com/careers",
            "BREEZYHR": "https://*.breezy.hr",
            # "BUILTIN": "https://builtin.com/company/*/jobs",
            "DOVER": "https://app.dover.com/*/careers/",
            "EIGHTFOLD": "https://*.eightfold.ai/careers",
            "FOUNTAIN": "https://*.fountain.com/",
            "GREENHOUSE": "https://job-boards.greenhouse.io/*",
            # "ICIMS": "https://careers.*.icims.com",
            "JAZZHR": "https://*.applytojob.com",
            "LEVER": "https://jobs.lever.co/*",
            # "MYWORKDAY": "https://*.wd1.myworkdayjobs.com/*",
            "PINPOINTHQ": "https://*.pinpointhq.com",
            # "PROPRIETARY": None,
            "RIPPLING": "https://ats.rippling.com/*",
            "SMARTRECRUITERS": "https://careers.smartrecruiters.com/*",
            # "TALEO": "https://*.taleo.net", # redirects to auth
            # "WELLFOUND": "https://wellfound.com/company/*/jobs",
            "WORKABLE": "https://apply.workable.com/*",  # "https://apply.workable.com/*/#jobs",
            "YCOMBINATOR": "https://ycombinator.com/companies/*/jobs",
            "HRM_DIRECT": "https://*.hrmdirect.com",
            "SCREENLOOP": "https://app.screenloop.com/careers/*",
            "GEM": "https://jobs.gem.com/*",
            # "GUSTO": "https://jobs.gusto.com/boards/*",
        }

        ats_homepages = {
            "ASHBYHQ": "https://ashbyhq.com/",
            "BAMBOOHR": "https://www.bamboohr.com/",
            "BREEZYHR": "https://breezy.hr/",
            # "BUILTIN": "https://builtin.com/",
            "DOVER": "https://dover.com/",
            "EIGHTFOLD": "https://eightfold.ai/",
            "FOUNTAIN": "https://fountain.com/",
            "GREENHOUSE": "https://www.greenhouse.io/",
            # "ICIMS": "https://www.icims.com/",
            "JAZZHR": "https://info.jazzhr.com/job-seekers.html",
            "LEVER": "https://www.lever.co/",
            # "MYWORKDAY": "https://www.workday.com/",
            "PINPOINTHQ": "https://www.pinpointhq.com/",
            # "PROPRIETARY": None,
            "RIPPLING": "https://www.rippling.com/",
            "SMARTRECRUITERS": "https://jobs.smartrecruiters.com/",
            # "TALEO": "https://www.oracle.com/taleo/",
            # "WELLFOUND": "https://wellfound.com/",
            "WORKABLE": "https://www.workable.com/",
            "YCOMBINATOR": "https://www.ycombinator.com/",
            "HRM_DIRECT": "https://www.hrmdirect.com/",
            "SCREENLOOP": "https://app.screenloop.com/auth/sign_in",
            "GEM": "https://gem.com/",
        }

        for ats in ats_types:
            ats["domain_matching_url"] = domain_matched_urls.get(
                ats["ats_type_code"], None
            )
            ats["homepage"] = ats_homepages.get(ats["ats_type_code"], None)

        return ats_types
    except requests.exceptions.RequestException as e:
        print(f"Error fetching ATS types: {e}")
        return None


ats_type_data = fetch_ats_types()


def get_ats_type_by_code(ats_type_code):
    """
    Fetches the ATS type entry by ats_type_code.
    """
    if not ats_type_data:
        return None

    for ats_type in ats_type_data:
        if ats_type["ats_type_code"] == ats_type_code:
            return ats_type
    return None
