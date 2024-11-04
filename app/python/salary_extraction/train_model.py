# app/python/salary_extraction/train_model.py
import spacy
import random

nlp = spacy.blank("en")

TRAIN_DATA = [
    ("The salary is $100,000 - $120,000 per year", {"entities": [(14, 24, "SALARY")]}),
    # TODO: Add more training examples
]

def train_ner_model():
    ner = nlp.create_pipe("ner")
    nlp.add_pipe("ner")
    ner.add_label("SALARY")

    optimizer = nlp.begin_training()

    for i in range(10):
        random.shuffle(TRAIN_DATA)
        for text, annotations in TRAIN_DATA:
            nlp.update([text], [annotations], sgd=optimizer)

    output_dir = "app/python/salary_extraction/model/salary_ner_model"
    nlp.to_disk(output_dir)
    print(f"Model saved to {output_dir}")

if __name__ == "__main__":
    train_ner_model()
