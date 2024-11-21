# app/python/ai_processing/company_extraction/label_mapping.py
from app.python.hooks.get_hc_domains import fetch_hc_domains
from app.python.hooks.get_company_specialties import fetch_company_specialties

hc_domain_data = fetch_hc_domains()
company_specialty_data = fetch_company_specialties()

COMPANY_ENTITY_LABELS =[
    "COMPANY_CITY",
    "COMPANY_COUNTRY",
    "COMPANY_STATE",
    "COMPANY_SETTING",
    "COMPANY_FUNDING",
    "COMPANY_ATS_TYPE"
]

HEALTHCARE_DOMAIN_ENTITY_LABELS = []

if hc_domain_data:
    HEALTHCARE_DOMAIN_ENTITY_LABELS = [hc_domain["key"] for hc_domain in hc_domain_data]
else: 
    print("Error fetching healthcare domains")

COMPANY_SPECIALTY_ENTITY_LABELS = []    
if company_specialty_data:
    COMPANY_SPECIALTY_ENTITY_LABELS = [specialty["key"] for specialty in company_specialty_data]
else:
    print("Warning: No company specialty data fetched.")
 
#  def get_entity_labels_by_domain(selected_domain):
#     """
#     Populate entity labels based on the selected healthcare domain.

#     Args:
#         selected_domain (str): The selected healthcare domain.

#     Returns:
#         list: A list of specialty keys for the selected domain.
#     """
#     if selected_domain in company_specialty_data:
#         # Fetch company_specialty_data for the selected domain
#         return [specialty["key"] for specialty in company_specialty_data[selected_domain]]
#     else:
#         print(f"Domain '{selected_domain}' not found.")
#         return []

# # Example Usage
# selected_hc_domain = "cardiology"
# COMPANY_SPECIALTY_ENTITY_LABELS = get_entity_labels_by_domain(selected_hc_domain)
# print(COMPANY_SPECIALTY_ENTITY_LABELS)

def generate_label_mappings(entity_type):
    if entity_type == "company":
        ENTITY_LABELS = COMPANY_ENTITY_LABELS
    elif entity_type == "healthcare_domain":
        ENTITY_LABELS = HEALTHCARE_DOMAIN_ENTITY_LABELS
    elif entity_type == "company_specialty":
        ENTITY_LABELS = COMPANY_SPECIALTY_ENTITY_LABELS
    else:
        raise ValueError(f"Unknown entity type: {entity_type}")
    
    label_list = ["O"]
    for label in ENTITY_LABELS:
        label_list.extend([f"B-{label}", f"I-{label}", f"L-{label}", f"U-{label}"])

    label_to_id = {label: i for i, label in enumerate(label_list)}
    id_to_label = {i: label for i, label in enumerate(label_list)}

    return label_list, label_to_id, id_to_label


# Utils
def get_label_list(entity_type):
    label_list, _, _ = generate_label_mappings(entity_type)
    return label_list


def get_label_to_id(entity_type):
    _, label_to_id, _ = generate_label_mappings(entity_type)
    return label_to_id        