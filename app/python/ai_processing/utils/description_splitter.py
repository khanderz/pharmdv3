#  app/python/ai_processing/utils/description_splitter.py

import sys
import base64
import json
from html import unescape
import re
from typing import Dict
from bs4 import BeautifulSoup


def strip_html_tags(text):
    """
    Removes HTML tags and extracts plain text from the input string.
    """
    soup = BeautifulSoup(text, "html.parser")
    return soup.get_text()


def recursive_html_decode(text, max_iterations=10):
    """
    Recursively decode HTML entities in the text until no further decoding is needed
    or a maximum number of iterations is reached.
    """
    print("Running recursive_html_decode...", file=sys.stderr)
    for _ in range(max_iterations):
        decoded_text = unescape(text)
        if decoded_text == text:
            break
        text = decoded_text
    return strip_html_tags(text)


def split_job_description(text: str) -> Dict[str, str]:
    """
    Splits a job description into sections based on specific keywords (including aliases).

    Args:
        text (str): The job description text to be split.

    Returns:
        Dict[str, str]: A dictionary with keys 'responsibilities', 'qualifications', and 'benefits'.
    """

    sections = {
        "summary": [
            "summary",
            "overview",
            "position summary",
            "role",
            "role description",
            "about the role",
        ],
        "responsibilities": [
            "responsibilities",
            "duties",
            "key responsibilities",
            "what you'll do",
        ],
        "qualifications": [
            "qualifications",
            "requirements",
            "skills required",
            "about you",
        ],
        "benefits": [
            "benefits",
            "perks",
            "compensation",
            "what you get",
            "what we offer",
        ],
    }

    all_sections = [
        alias for section_list in sections.values() for alias in section_list
    ]

    section_regex = re.compile(r"(?i)\b(" + "|".join(all_sections) + r")\b:?\s*")

    split_text = section_regex.split(text)

    result = {
        "summary": "",
        "responsibilities": "",
        "qualifications": "",
        "benefits": "",
    }

    current_section = None

    for part in split_text:
        header_match = section_regex.match(part.strip())
        
        if header_match:
            # print("Header match:", header_match, file=sys.stderr)
            matched_section = header_match.group(1).lower().replace(" ", "_")
            # print(f"Matched alias: {matched_alias}", file=sys.stderr)
            if matched_section in result and (current_section is None or list(result.keys()).index(matched_section) > list(result.keys()).index(current_section)):
                current_section = matched_section
                result[current_section] = ""
        elif current_section:
            result[current_section] += part.strip() + " "
            # print(f"Current section '{current_section}': {result[current_section]}", file=sys.stderr)

    for key in result:
        result[key] = result[key].strip()
        # print(f"------------Section '{key}': {result[key]}", file=sys.stderr)    
    # print("Split job description:", result, file=sys.stderr)
    return result


def print_readable_output(split_result: Dict[str, str]):
    """
    Prints the split job description in a readable format.

    Args:
        split_result (Dict[str, str]): The dictionary of split job description sections.
    """
    print("\nJob Description Breakdown:")
    print("=" * 50)
    for section, content in split_result.items():
        print(f"{section.replace('_', ' ').title()}:\n")
        print(content)
        print("-" * 50)


# test_texts = [
#     """&lt;div class=&quot;content-intro&quot;&gt;&lt;p&gt;&lt;strong&gt;&lt;em&gt;Attention recruitment agencies:&lt;/em&gt;&lt;/strong&gt;&lt;em&gt; 4DMT is a clinical-stage biotherapeutics company harnessing the power of directed evolution for targeted genetic medicines. We seek to unlock the full potential of gene therapy using our platform, Therapeutic Vector Evolution (TVE), which combines the power of directed evolution with our approximately one billion synthetic AAV capsid-derived sequences to invent evolved vectors for use in our products. We believe key features of our targeted and evolved vectors will help us create targeted product candidates with improved therapeutic profiles. These profiles will allow us to treat a broad range of large market diseases, unlike most current genetic medicines that generally focus on rare or small market diseases. &amp;nbsp;&lt;/p&gt;\n&lt;p&gt;Company Differentiators:&amp;nbsp;&lt;/p&gt;\n&lt;p&gt;• &amp;nbsp; &amp;nbsp;Fully integrated clinical-phase company with internal manufacturing&lt;br&gt;• &amp;nbsp; &amp;nbsp;Demonstrated ability to move rapidly from idea to IND&lt;br&gt;• &amp;nbsp; &amp;nbsp;Five candidate products in the clinic and two declared pre-clinical programs&lt;br&gt;• &amp;nbsp; &amp;nbsp;Robust technology and IP foundation, including our TVE and manufacturing platforms&lt;br&gt;• &amp;nbsp; &amp;nbsp;Initial product safety and efficacy data substantiates the value of our platforms&lt;br&gt;• &amp;nbsp; &amp;nbsp;Opportunities to expand to other indications and modalities within genetic medicine&lt;/p&gt;&lt;/div&gt;&lt;p&gt;&lt;strong&gt;Position Summary:&amp;nbsp;&lt;/strong&gt;&amp;nbsp;&lt;/p&gt;\n&lt;p&gt;The Associate Director of Clinical Quality Assurance (CQA) will be responsible for supporting Quality Assurance oversight of 4DMT sponsored clinical studies, ensuring studies are executed in compliance with all applicable international regulatory requirements for Good Clinical Practice (GCP).&amp;nbsp;&amp;nbsp;This position reports to the Senior Director, GCP Compliance and Quality Systems and contributes to the development, implementation, and successful execution of the CQA mission, objectives, and strategic plan.&lt;/p&gt;\n&lt;p&gt;&lt;strong&gt;Responsibilities:&lt;/strong&gt;&amp;nbsp;&lt;/p&gt;\n&lt;p&gt;&lt;strong&gt;Provide Quality oversight for multiple 4DMT Clinical Studies, including the following study-specific activities:&lt;/strong&gt;&lt;/p&gt;\n&lt;ul&gt;\n&lt;li&gt;Partner with Clinical stakeholder to support timely identification, escalation, investigation, documentation, and resolution of GCP-related quality events, acting at all times with an appropriate sense of urgency.&lt;/li&gt;\n&lt;li&gt;Provide GCP guidance to clinical study teams, including via attendance at Study team meetings, with support from Sr. Director GCP Compliance.&lt;/li&gt;\n&lt;li&gt;Ensure principles of Risk Management are applied to Clinical Studies per ICH E6&lt;/li&gt;\n&lt;li&gt;Coordinate GCP Compliance audits of high-risk clinical vendors/sites, including clinical investigator sites.&lt;/li&gt;\n&lt;li&gt;Ensure audit findings are communicated to audit stakeholders and collaborate with auditees and vendors to track, review, approve, and assess the adequacy of&lt;/li&gt;\n&lt;li&gt;Perform Clinical Document reviews, ensuring the quality, accuracy and completeness of various documents, including as applicable Clinical Protocols, IBs, DSURs, Module 2.6 Tabulated and Written Summaries, and Integrated&lt;/li&gt;\n&lt;/ul&gt;\n&lt;p&gt;&lt;strong&gt;Support investigation and management of specific Clinical Study Quality Events as assigned:&lt;/strong&gt;&lt;/p&gt;\n&lt;ul&gt;\n&lt;li&gt;Monitor, track, and facilitate the completion of formal corrective and preventive actions (CAPAs) to address identified&amp;nbsp;Clinical Study Quality Events, including potential serious breaches of GCP.&amp;nbsp;&lt;/li&gt;\n&lt;/ul&gt;\n&lt;p&gt;&lt;strong&gt;Support a quality-focused work environment in Clinical that fosters learning, respect, open communication, collaboration, integration, and teamwork:&lt;/strong&gt;&lt;/p&gt;\n&lt;ul&gt;\n&lt;li&gt;Drive the development and continuous improvement of the Clinical Quality Management System through the development / refinement of Clinical QA processes / initiatives as assigned&lt;/li&gt;\n&lt;/ul&gt;\n&lt;p&gt;&lt;strong&gt;Partner with GMP Quality and Clinical Operations teams to facilitate the investigation of clinical supply quality issues such as temperature excursions, product complaints and deviations reported from clinical sites.&lt;/strong&gt;&lt;/p&gt;\n&lt;p&gt;&lt;strong&gt;&amp;nbsp;&lt;/strong&gt;&lt;/p&gt;\n&lt;p&gt;&lt;strong&gt;&lt;u&gt;QUALIFICATIONS:&amp;nbsp;&lt;/u&gt;&lt;/strong&gt;&lt;/p&gt;\n&lt;ul&gt;\n&lt;li&gt;B.S./B.A. in a science or related life science field or equivalent; advanced scientific degree preferred.&lt;/li&gt;\n&lt;li&gt;8+ years working within a regulated environment such as Regulatory, Quality, Pharmacovigilance or Clinical Development / Operations within the Biotech or similar industry&lt;/li&gt;\n&lt;li&gt;Proven experience with GCP Quality Management Systems, audit support, and quality oversight of global clinical studies, including knowledge of quality investigation / root cause analysis techniques&lt;/li&gt;\n&lt;li&gt;Minimum of 4 years of experience in a role including responsibility for providing GCP oversight of clinical study activities, preferably at a clinical study sponsor&lt;/li&gt;\n&lt;li&gt;In-depth understanding of GCP requirements for investigational products&lt;/li&gt;\n&lt;li&gt;Extensive practical experience and understanding of clinical quality assurance as applied throughout the clinical development life-cycle&lt;/li&gt;\n&lt;li&gt;Excellent communication skills, both oral and written&lt;/li&gt;\n&lt;li&gt;Excellent interpersonal skills, collaborative approach essential&lt;/li&gt;\n&lt;li&gt;Comfortable in a fast-paced small company environment with minimal direction and able to adjust workload based upon changing priorities&lt;/li&gt;\n&lt;/ul&gt;\n&lt;p&gt;Base salary compensation range: $152,000 - $199,000&lt;/p&gt;\n&lt;p&gt;"""
# ]

# if __name__ == "__main__":
#     for i, text in enumerate(test_texts):
#         print(f"\nTest {i + 1} Results:\n")
#         clean_text = recursive_html_decode(text)
#         split_result = split_job_description(clean_text)
#         print_readable_output(split_result)


def main():
    """Main entry point of the script."""
    if len(sys.argv) < 2:
        print(json.dumps({"error": "No input provided to the script"}))
        sys.exit(1)

    try:
        encoded_data = sys.argv[1]
        input_data = json.loads(base64.b64decode(encoded_data))
        job_description = input_data.get("text", "")

        decoded_text = recursive_html_decode(job_description)
        split_result = split_job_description(decoded_text)

        print(json.dumps(split_result))

    except Exception as e:
        print(json.dumps({"error": str(e)}))
        sys.exit(1)


if __name__ == "__main__":
    main()
