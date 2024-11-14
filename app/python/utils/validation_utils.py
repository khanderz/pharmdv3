#  app/python/utils/validation_utils.py
from sklearn.metrics import classification_report
from sklearn.preprocessing import MultiLabelBinarizer
from app.python.utils.spacy_utils import print_token_characters

RED = "\033[31m"
GREEN = "\033[32m"
BLUE = "\033[34m"
RESET = "\033[0m"

def evaluate_model(nlp, validation_data):
    """Evaluate the model on the validation dataset and print metrics."""
    true_labels = []
    pred_labels = []
    
    for entry in validation_data:
        text = entry["text"]
        true_entities = [ent["label"] for ent in entry["entities"]] 

        doc = nlp(text)
        print_token_characters(text)
        print("\nTokenization:")
        for token in doc:
            print(f"Token: '{token.text}', Start: {token.idx}, End: {token.idx + len(token.text)}")
       
        pred_entities = [(ent.start_char, ent.end_char, ent.label_) for ent in doc.ents]

        print(f"\nText: {text}")
        print(f"True Entities: {true_entities}")
        print(f"Predicted Entities: {pred_entities}")
        
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