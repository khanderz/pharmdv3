# app/python/salary_extraction/utils/model_utils.py

import os
from transformers import TFAutoModelForTokenClassification
from app.python.salary_extraction.utils.label_mapping import get_label_list

def load_model(model_path, model_name="bert-base-cased"):
    #  check to see if the model exists
    if os.path.exists(model_path):
        print("-------------Loading model from checkpoint...")
        return TFAutoModelForTokenClassification.from_pretrained(model_path)
    else:
        print("-------------Initializing a new model...")
        return TFAutoModelForTokenClassification.from_pretrained(
            model_name, num_labels=len(get_label_list())
        )

def save_model(model, model_path):
    model.save_pretrained(model_path)
    print("Model saved successfully.")
