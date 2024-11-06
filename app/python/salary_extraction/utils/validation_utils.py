# app/python/salary_extraction/utils/validation_utils.py
from app.python.salary_extraction.utils.tokenizer_utils import tokenizer, align_labels_with_tokens_fast

def check_token_label_length(data, tokenized_dataset, id_to_label):
#  length check to test for accuracy
    for example in data:
        text = example["text"]
        labels = example["labels"]

        tokenized_inputs = tokenizer(text, padding=True, truncation=True, return_offsets_mapping=True)
        tokens = tokenizer.convert_ids_to_tokens(tokenized_inputs["input_ids"])
        word_ids = tokenized_inputs.word_ids()

        # Align labels with tokens
        aligned_labels = align_labels_with_tokens_fast(labels, word_ids)
        token_count = len(tokens)
        label_count = len(labels)
        aligned_label_count = len(aligned_labels)

        aligned_label_names = [id_to_label[label_id] if label_id != -100 else "PAD" for label_id in aligned_labels]

        
        print(f"Text: {text}")
        print(f"-----------------Tokens ({token_count}): {tokens}")
        print(f"Original Labels ({label_count}): {labels}")
        print(f"--------------Aligned Labels ({aligned_label_count}): {aligned_label_names}")
        # token_count != aligned_label_count and print(f"---------------!!!!Token count ({token_count}) does not match aligned label count ({aligned_label_count})")
        print("-" * 50)

    # Print aligned labels in the tokenized dataset to verify alignment aka checks for PAD tokens
    # for i, example in enumerate(tokenized_dataset):
    #     if i < 3:  # Limit output to first 3 examples
    #         print(f"Tokens: {tokenizer.convert_ids_to_tokens(example['input_ids'])}")
    #         print(f"Aligned Labels: {example['labels']}")
    #         print("-" * 50)


# Function to verify token and label alignment
def check_token_label_alignment(train_data, id_to_label):
    for example in train_data:
        text = example["text"]
        labels = example["labels"]
        tokenized_inputs = tokenizer(
            text, truncation=True, padding=True, return_offsets_mapping=True
        )
        tokens = tokenizer.convert_ids_to_tokens(tokenized_inputs["input_ids"])
        word_ids = tokenized_inputs.word_ids()
        aligned_labels = align_labels_with_tokens_fast(labels, word_ids)

        aligned_label_names = [
            id_to_label[label_id] if label_id != -100 else "PAD" for label_id in aligned_labels
        ]

        print(f"Text: {text}")
        print(f"Tokens: {tokens}")
        print(f"Aligned Labels: {aligned_label_names}")
        print("-" * 50)        
    
        token_count = len(tokens)
        aligned_label_count = len(aligned_labels)
        if token_count != aligned_label_count:
            print(f"!!! Token count ({token_count}) does not match aligned label count ({aligned_label_count})")