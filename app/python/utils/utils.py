# app/python/utils/utils.py
import re

def clean_text(text):
    """
    Cleans text by removing unnecessary whitespace and special characters.
    """
    return re.sub(r"\s+", " ", text).strip()

def print_token_characters(tokens):
    text = ''.join(tokens)
    
    for idx, char in enumerate(text):
        print(f"{char} {idx}")

def print_side_by_side(arr1, arr2):
    max_len = max(len(arr1), len(arr2))

    for i in range(max_len):
        elem1 = arr1[i] if i < len(arr1) else ""
        elem2 = arr2[i] if i < len(arr2) else ""
        
        print(f"{elem1}\t{elem2}")        

def add_space_to_tokens(tokens, labels, no_space_entities, punctuations):
    is_bio_format = all(label.startswith("B-") or label.startswith("I-") or label == "O" for label in labels)
    # print(f"tokens: {tokens}, labels: {labels}, is_bio_format: {is_bio_format}")
    all_tokens = []
    all_labels = []
    # print(f"is bio format: {is_bio_format}, labels : {labels}")

    for i, token in enumerate(tokens):
        all_tokens.append(token)
        all_labels.append(labels[i])  

        # print(f" 1 Token: {token}, Label: {labels[i]}")
 
        if i < len(tokens) - 1:
            next_token, next_label = tokens[i + 1], labels[i + 1]
            current_label_type = labels[i][2:] if is_bio_format and labels[i] != "O" else labels[i]
            next_label_type = next_label[2:] if is_bio_format and next_label != "O" else next_label

            # print(f" 2 Token: {token} Next Token: {next_token}, Next Label: {next_label}, Current Label Type: {current_label_type}, Next Label Type: {next_label_type}")

            if (re.match(r'^\$|\€|\£|\₹|\¥$', token) and re.match(r'^\d[\d,]*$', next_token)): 
            # or token == '-':
                # print(f"3 Token: {token}, Next Token: {next_token}")
                continue   

            if is_bio_format:
                if labels[i].startswith("B-") and next_label.startswith("I-") and current_label_type == next_label_type:
                    # print(f"4 Token: {token}, Next Token: {next_token}")
                    if current_label_type not in no_space_entities: 
                        all_tokens.append(" ")  
                        all_labels.append("O")

                if next_label.startswith("I-") and current_label_type == next_label_type:
                    # print(f"5 Token: {token}, Next Token: {next_token}")
                    continue

                if token == "-":
                    # print(f"5a {RED} HYPHEN-- Token: {token}, Next Token: {next_token}, next label type: {next_label_type} {RESET}")
                    # if next_label_type in no_space_entities:
                    #     continue

                    all_tokens.append(" ")  
                    all_labels.append("O")                   

                elif next_token not in punctuations:
                    # print(f"6 Token: {token}, Next Token: {next_token}")
                    all_tokens.append(" ")
                    all_labels.append("O")

            else:
                # print(f"6 Token: {token}, current_label_type: {current_label_type}, next_label_type: {next_label_type}")
                if current_label_type == next_label_type:
                    # print(f"7 Next Token: {next_token}")
                    if current_label_type not in no_space_entities and token != "," and next_token != ":":
                        # print(f"8 Token: {token}, Next Token: {next_token}")
                        all_tokens.append(" ")
                        all_labels.append("O")


                elif next_token not in punctuations:
                    # print(f"9 Token: {token}, Next Token: {next_token}")
                    all_tokens.append(" ")
                    all_labels.append("O")
    # print(f"all_tokens: {all_tokens}, all_labels: {all_labels}")
    return all_tokens, all_labels        