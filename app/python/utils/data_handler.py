# app/python/utils/data_handler.py

import json
import os

def generate_path(file_name, folder):
    """Generate a full path to a file in a specified folder."""
    project_root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    return os.path.join(project_root, folder, "data", file_name)

def load_data(json_file, folder):
    """Load JSON data from a specified file in a given folder."""
    train_data_path = generate_path(json_file, os.path.join(folder))

    try:
        with open(train_data_path, "r") as f:
            return json.load(f)
    except (FileNotFoundError, json.JSONDecodeError) as e:
        print(f"Error: {e}")
        return []

# Uncomment if needed
# def create_tokenized_dataset(data):
#     dataset = Dataset.from_dict({
#         "text": [item["text"] for item in data],
#         "labels": [item["labels"] for item in data]
#     })
#     return dataset.map(tokenize_and_align_labels(data), batched=True)
