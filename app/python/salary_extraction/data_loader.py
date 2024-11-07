# app/python/salary_extraction/data_loader.py

# import json
# from datasets import Dataset
# from app.python.salary_extraction.utils.tokenizer_utils import tokenize_and_align_labels

# def load_data(data_path):
#     with open(data_path, "r") as f:
#         return json.load(f)

# def create_tokenized_dataset(data):
#     dataset = Dataset.from_dict({"text": [item["text"] for item in data], "labels": [item["labels"] for item in data]})
#     return dataset.map(tokenize_and_align_labels(data), batched=True)
