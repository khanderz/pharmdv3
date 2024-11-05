# app/python/salary_extraction/label_mapping.py

# Define the entity labels for BIO tagging
ENTITY_LABELS = [
    "SALARY_MIN",
    "SALARY_MAX",
    "SALARY_SINGLE",
    "CURRENCY",
    "INTERVAL",
    "COMMITMENT",
    "JOB_COUNTRY",
]

# Generate BIO tags
label_list = ["O"]  # "Outside" tag
for label in ENTITY_LABELS:
    label_list.extend([f"B-{label}", f"I-{label}"])

# Create mappings from label to ID and vice versa
label_to_id = {label: i for i, label in enumerate(label_list)}
id_to_label = {i: label for i, label in enumerate(label_list)}


# Utility functions for accessing the mappings
def get_label_list():
    return label_list


def get_label_to_id():
    return label_to_id


def get_id_to_label():
    return id_to_label
