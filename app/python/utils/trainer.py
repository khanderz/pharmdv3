# app/python/utils/trainer.py
import random
import os

def train_spacy_model(MODEL_SAVE_PATH, nlp, examples):
    """Train the spaCy model with the given examples."""
    print("\nStarting model training...")
    optimizer = nlp.begin_training()

    for epoch in range(5):
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