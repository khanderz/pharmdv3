# app/python/ai_processing/utils/label_mapping.py

SALARY_ENTITY_LABELS = [
    "SALARY_MIN",
    "SALARY_MAX",
    "SALARY_SINGLE",
    "CURRENCY",
    "INTERVAL",
    "COMMITMENT",
    "JOB_COUNTRY",
]

JOB_DESCRIPTION_ENTITY_LABELS = [
    "DESCRIPTION",
    "JOB_ROLE",
    "JOB_SENIORITY",
    "JOB_DEPT",
    "JOB_TEAM",
    "COMMITMENT",
    "JOB_SETTING",
    "JOB_COUNTRY",
    "JOB_CITY",
    "JOB_STATE",
]

JOB_RESPONSIBILITY_ENTITY_LABELS = [
    "RESPONSIBILITIES",
]

JOB_QUALIFICATION_ENTITY_LABELS = [
    "QUALIFICATIONS",
    "CREDENTIALS",
    "EDUCATION",
    "EXPERIENCE",
]

JOB_BENEFIT_ENTITY_LABELS = [
    "COMMITMENT",
    "JOB_SETTING",
    "JOB_COUNTRY",
    "JOB_CITY",
    "JOB_STATE" "COMPENSATION",
    "RETIREMENT",
    "OFFICE_LIFE",
    "PROFESSIONAL_DEVELOPMENT",
    "WELLNESS",
    "PARENTAL",
    "WORK_LIFE_BALANCE",
    "VISA_SPONSORSHIP",
    "ADDITIONAL_PERKS",
]

# JOB_LOCATION_ENTITY_LABELS = [
#     "JOB_SETTING",
#     "JOB_COUNTRY",
#     "JOB_CITY",
#     "JOB_STATE",
# ]

# JOB_ROLE_ENTITY_LABELS = ["JOB_ROLE", "JOB_SENIORITY", "JOB_DEPT", "JOB_TEAM"]


def generate_label_mappings(entity_type):
    if entity_type == "salary":
        ENTITY_LABELS = SALARY_ENTITY_LABELS
    elif entity_type == "job_description":
        ENTITY_LABELS = JOB_DESCRIPTION_ENTITY_LABELS
    elif entity_type == "job_responsibility":
        ENTITY_LABELS = JOB_RESPONSIBILITY_ENTITY_LABELS
    elif entity_type == "job_qualification":
        ENTITY_LABELS = JOB_QUALIFICATION_ENTITY_LABELS
    elif entity_type == "job_benefit":
        ENTITY_LABELS = JOB_BENEFIT_ENTITY_LABELS
    # elif entity_type == "job_location":
    #     ENTITY_LABELS = JOB_LOCATION_ENTITY_LABELS
    # elif entity_type == "job_role":
    #     ENTITY_LABELS = JOB_ROLE_ENTITY_LABELS
    else:
        raise ValueError(
            f"Invalid entity type {entity_type}. Must pass entity type as argument."
        )

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
