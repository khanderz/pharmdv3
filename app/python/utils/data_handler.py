# app/python/utils/data_handler.py

import json
import os
from datasets import Dataset
# from app.python.utils.tokenizer_utils import tokenize_and_align_labels

def generate_path(file_name, folder):
    script_dir = os.path.dirname(os.path.abspath(__file__))
    project_root = os.path.dirname(script_dir)
    
    return os.path.join(project_root, folder, file_name)

def load_data(json_file, folder):
    data_path = folder + "/data"
    train_data_path = generate_path(json_file, data_path)

    try:
        with open(train_data_path, "r") as f:
            return json.load(f)
    except FileNotFoundError:
        print(f"Error: The file at {train_data_path} was not found.")
        return []
    except json.JSONDecodeError:
        print(f"Error: The file at {train_data_path} is not a valid JSON.")
        return []


# def create_tokenized_dataset(data):
#     dataset = Dataset.from_dict({"text": [item["text"] for item in data], "labels": [item["labels"] for item in data]})
#     return dataset.map(tokenize_and_align_labels(data), batched=True)

