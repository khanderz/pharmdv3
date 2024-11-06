# app/python/salary_extraction/utils/tokenizer_utils.py

from transformers import AutoTokenizer
from app.python.salary_extraction.utils.label_mapping import get_label_to_id, get_id_to_label


label_to_id = get_label_to_id()
id_to_label = get_id_to_label()

# Initialize tokenizer
model_name = "bert-base-cased"
tokenizer = AutoTokenizer.from_pretrained(model_name)

# Custom helper function to align labels with tokens
def align_labels_with_tokens(labels, word_ids):
    aligned_labels = []
    previous_word_idx = None
    
    for word_idx in word_ids:
        if word_idx is None:  # Handle special tokens like [CLS] and [SEP]
            aligned_labels.append(-100)
        elif word_idx != previous_word_idx:  # Start of a new word
            # Ensure index is within bounds for label alignment
            aligned_labels.append(label_to_id.get(labels[word_idx], -100) if word_idx < len(labels) else -100)
        else:
            # Continuation of a subword token, propagate the "I-" label
            last_label = aligned_labels[-1]
            if last_label != -100 and id_to_label.get(last_label, "").startswith("B-"):
                # Convert to I- by checking the actual label string
                aligned_labels.append(label_to_id.get("I" + id_to_label[last_label][1:], -100))
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