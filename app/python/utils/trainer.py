# app/python/utils/trainer.py
import random
import os
import spacy
from spacy.tokens import Doc

if not Doc.has_extension("index"):
    Doc.set_extension("index", default=None)

def train_spacy_model(MODEL_SAVE_PATH, nlp, examples):
    """Train the spaCy model with the given examples."""
    print("\nStarting model training...")
    optimizer = nlp.begin_training()
    # print(f"examples: {examples}")
    for epoch in range(10):
        random.shuffle(examples)
        losses = {}

        for example in examples:
            index = example.reference._.get("index")
            if index is not None and index % (len(examples) // 5) == 0:
                print(f"\nTraining example: '{example.reference.text[:50]}...'")

            nlp.update([example], drop=0.2, losses=losses, sgd=optimizer)

        print(f"\nEpoch {epoch + 1}, Losses: {losses}")
        print("----" * 10)

    os.makedirs(MODEL_SAVE_PATH, exist_ok=True)

    nlp.to_disk(MODEL_SAVE_PATH)
    print(f"Model saved to {MODEL_SAVE_PATH}")