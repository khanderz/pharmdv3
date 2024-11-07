# app/python/salary_extraction/train_model.py

import spacy
import random
import spacy_transformers  

from app.python.utils.label_mapping import get_label_list, get_label_to_id, get_id_to_label
from app.python.utils.data_handler import  generate_path, load_data
from app.python.utils.spacy_utils import bio_to_offset, convert_bio_to_spacy_format,  convert_to_spacy_format

folder = "salary_extraction"
train_data_path = "train_data.json"
converted_data_path = generate_path( "train_data_spacy.json", folder)
model_save_path = "app/python/salary_extraction/model/spacy_salary_ner_model"

data = load_data(train_data_path, folder)

# Load a blank spaCy model n' add transformer and NER pipeline
nlp = spacy.blank("en")
transformer_config = {
    "model": {
        "@architectures": "spacy-transformers.TransformerModel.v1",
        "name": "roberta-base",
        "get_spans": {
            "@span_getters": "spacy-transformers.doc_spans.v1"
        }
    }
}
transformer = nlp.add_pipe("transformer", config=transformer_config)
ner = nlp.add_pipe("ner")

convert_bio_to_spacy_format(train_data_path, converted_data_path, folder, nlp)


ENTITY_LABELS = get_label_list()

for label in ENTITY_LABELS:
    ner.add_label(label)


# Register extension for Doc to store indices
spacy.tokens.Doc.set_extension("index", default=None)

train_data = load_data(converted_data_path, folder)
# tokenized_dataset = create_tokenized_dataset(train_data)
doc_bin, examples = convert_to_spacy_format(train_data)
doc_bin.to_disk("app/python/salary_extraction/data/train.spacy")

def train_spacy_model():
    print("\nStarting model training...")
    optimizer = nlp.begin_training()
    
    for epoch in range(5):  
        losses = {}
        random.shuffle(examples)
        
        for example in examples:
            text = example.reference.text
            ents = example.reference.ents
            
            index = example.reference._.get("index")
            
            if index is not None and index % (len(examples) // 5) == 0:  
                print(f"\nTraining with example text: '{text[:50]}...'")
                print(f"Example annotations (sample): {[ent.text for ent in ents[:3]]}") 
            
            nlp.update([example], drop=0.2, losses=losses, sgd=optimizer)
        
        print(f"\nEpoch {epoch + 1}, Losses: {losses}")
        print("----" * 10)

    nlp.to_disk(model_save_path)
    print(f"Model saved to {model_save_path}")


train_spacy_model()

nlp = spacy.load(model_save_path)

def inspect_model_predictions(text):
    doc = nlp(text)
    print("\nOriginal Text:")
    print(f"'{text}'\n")
    print("Token Predictions:")
    print(f"{'Token':<15}{'Predicted Label':<20}")
    print("-" * 50)
    for token in doc:
        label = token.ent_type_ if token.ent_type_ else "O"
        print(f"{token.text:<15}{label:<20}")

print("\nExample Prediction:")
inspect_model_predictions("The salary is expected to be $100,000 annually in USD.")

test_texts = [
    "The annual salary is expected to be $120,000 USD.",
    "Compensation ranges from €50,000 to €70,000 annually.",
    "Base pay in Canada is CAD 60,000 per year.",
    "This position offers a minimum salary of £45,000.",
    "Contractor role with hourly rate of 25 AUD."
]

for text in test_texts:
    print(f"\nTesting text: '{text}'")
    inspect_model_predictions(text)
