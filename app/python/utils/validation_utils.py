#  app/python/utils/validation_utils.py
from sklearn.metrics import classification_report
from sklearn.preprocessing import MultiLabelBinarizer
from app.python.utils.logger import RED, GREEN, RESET
from app.python.utils.spacy_utils import print_token_characters


def print_tokenization(doc):
    print("\nTokenization Debugging:")
    for token in doc:
        print(f"Token: '{token.text}', Start: {token.idx}, End: {token.idx + len(token.text)}")

def verify_data_consistency(validation_data):
    for entry in validation_data:
        # print(f"entry : {entry}")
        text = entry["text"]
        for entity in entry["entities"]:
            start = entity["start"]
            end = entity["end"]
            
            if "token" not in entity:
                print(f"Warning: Missing 'token' key in entity {entity}. Skipping consistency check for this entity.")
                continue
            
            assert text[start:end] == entity["token"], f"{RED}{print_token_characters(text)}{RESET}"

def fuzzy_match(true_entities, pred_entities, tolerance=1):
    matched = []
    print(f"True Entities: {true_entities}")
    print(f"Predicted Entities: {pred_entities}")
    for start, end, label in pred_entities:
        for entity in true_entities:
            t_start = entity["start"]
            t_end = entity["end"]
            t_label = entity["label"]
            
            if label == t_label and abs(start - t_start) <= tolerance and abs(end - t_end) <= tolerance:
                matched.append((start, end, label))
                break
    return matched

def evaluate_model(nlp, validation_data):
    """Evaluate the model on the validation dataset and print metrics."""
    true_labels = []
    pred_labels = []
    
    # verify_data_consistency(validation_data)
    for entry in validation_data:
        # doc = nlp(entry["text"])
        # print_tokenization(doc)
        text = entry["text"]
        true_entities = [ent["label"] for ent in entry["entities"]] 

        doc = nlp(text)
        # print_token_characters(text)
        
        # print("\nTokenization:")
        # for token in doc:
        #     print(f"Token: '{token.text}', Start: {token.idx}, End: {token.idx + len(token.text)}")
        for ent in doc.ents:
            print(f"Predicted entity: '{ent.text}', Start: {ent.start_char}, End: {ent.end_char}, Label: {ent.label_}")

        pred_entities = [(ent.start_char, ent.end_char, ent.label_) for ent in doc.ents]
        # fuzzy_matched = fuzzy_match(entry["entities"], pred_entities)
        # print(f"Fuzzy Matched: {fuzzy_matched}") 
        # print(f"\nText: {text}")
        # print(f"True Entities: {true_entities}")
        # print(f"Predicted Entities: {pred_entities}")
        
        true_labels.append(true_entities)
        pred_labels.append(pred_entities)

    mlb = MultiLabelBinarizer()
    true_labels_binary = mlb.fit_transform(true_labels)
    pred_labels_binary = mlb.transform(pred_labels)    

    print(f"\n{GREEN}Validation Performance:{RESET}")
    print(classification_report(true_labels_binary, pred_labels_binary, target_names=mlb.classes_, zero_division=0))

def print_label_token_pairs(data):
    """Prints label and associated token for each entity in the data."""
    print(f"{'Label':<15} {'Token'}")
    print("-" * 30)
    # print(f"data : {data}")  
    for entry in data:
        # print(f"entry : {entry}")
        text = entry["text"]
        for entity in entry["entities"]:
            label = entity["label"]
            token = text[entity["start"]:entity["end"]]
            print(f"{label:<15} {token}")