# app/python/salary_extraction/utils/tokenizer_utils.py

from transformers import AutoTokenizer
from app.python.salary_extraction.utils.label_mapping import get_label_to_id


label_to_id = get_label_to_id()

# Initialize tokenizer
model_name = "bert-base-cased"
tokenizer = AutoTokenizer.from_pretrained(model_name)

# Helper function to align labels with tokens
def align_labels_with_tokens(labels, word_ids):
    aligned_labels = []
    previous_word_idx = None
    
    for word_idx in word_ids:
        if word_idx is None:  # For special tokens like [CLS] and [SEP]
            aligned_labels.append(-100)
        elif word_idx != previous_word_idx:  # Start of a new word
            if word_idx < len(labels):  # Ensure index is within bounds
                aligned_labels.append(label_to_id.get(labels[word_idx], -100))
            else:
                aligned_labels.append(-100)
        else:
            # Continuation subwords receive the "inside" label if it's a B- type
            last_label = aligned_labels[-1]
            if last_label != -100 and last_label % 2 == 1:  # Check for B- type
                aligned_labels.append(last_label + 1)  # Convert B- to I- type
            else:
                aligned_labels.append(last_label)
        
        previous_word_idx = word_idx
    
    return aligned_labels


# Tokenize and align labels with tokens
def tokenize_and_align_labels(examples):
    tokenized_inputs = tokenizer(examples["text"], padding=True, truncation=True)
    all_labels = []
    for i, label in enumerate(examples["labels"]):
        word_ids = tokenized_inputs.word_ids(batch_index=i)
        aligned_labels = align_labels_with_tokens(label, word_ids)
        all_labels.append(aligned_labels)

    tokenized_inputs["labels"] = all_labels
    return tokenized_inputs