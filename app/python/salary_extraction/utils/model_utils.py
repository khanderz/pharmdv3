# app/python/salary_extraction/utils/model_utils.py
import logging 
import os
from transformers import TFAutoModelForTokenClassification
from app.python.salary_extraction.utils.label_mapping import get_label_list

logger = logging.getLogger(__name__)

def load_model(model_save_path, model_name="bert-base-cased", num_labels=None):
    if os.path.exists(model_save_path):
        logger.info("-------------Loading model from checkpoint...")
        model = TFAutoModelForTokenClassification.from_pretrained(model_save_path)
    else:
        logger.info("-------------Initializing a new model...")
        model = TFAutoModelForTokenClassification.from_pretrained(model_name, num_labels=num_labels)
    return model

def save_model(model, model_save_path):
    model.save_pretrained(model_save_path)
    logger.info("Model saved successfully.")
