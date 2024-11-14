# app/python/salary_extraction/utils/tokenizer_utils.py

# ------- for BIO format




# from transformers import AutoTokenizer
# from app.python.salary_extraction.utils.label_mapping import get_label_to_id, get_id_to_label

# label_to_id = get_label_to_id()
# id_to_label = get_id_to_label()

# # Initialize
# tokenizer = AutoTokenizer.from_pretrained("bert-base-cased", use_fast=True)

# # Custom helper function to align labels with tokens
# def align_labels_with_tokens_fast(labels, word_ids):
#     aligned_labels = []
#     previous_word_idx = None

#     for word_idx in word_ids:
#         if word_idx is None:  # Handle special tokens like [CLS] and [SEP]
#             aligned_labels.append(-100)
#         elif word_idx != previous_word_idx:  # Start of a new word
#             # Get label for the new word, ensuring bounds
#             new_label_id = label_to_id.get(labels[word_idx], -100) if word_idx < len(labels) else -100
#             aligned_labels.append(new_label_id)
#         else:
#             # Continuation of the same word (subword token)
#             # Get the previous label and convert it to "I-" if it was a "B-"
#             last_label_id = aligned_labels[-1]
#             if last_label_id != -100 and id_to_label[last_label_id].startswith("B-"):
#                 new_label = "I" + id_to_label[last_label_id][1:]
#                 new_label_id = label_to_id.get(new_label, -100)
#                 aligned_labels.append(new_label_id)
#             else:
#                 # No "B-" label, propagate the last label directly
#                 aligned_labels.append(last_label_id)

#         previous_word_idx = word_idx

#     return aligned_labels

# # Tokenize and align labels with tokens
# def tokenize_and_align_labels(examples):
#     tokenized_inputs = tokenizer(examples["text"], padding=True, truncation=True)
#     all_labels = []

#     for i, label in enumerate(examples["labels"]):
#         word_ids = tokenized_inputs.word_ids(batch_index=i)
#         aligned_labels = align_labels_with_tokens_fast(label, word_ids)
#         all_labels.append(aligned_labels)

#     tokenized_inputs["labels"] = all_labels
#     return tokenized_inputs
