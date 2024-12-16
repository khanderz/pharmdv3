# app/python/utils/trainer.py
import random
import os
from spacy.tokens import Doc
import logging

if not Doc.has_extension("index"):
    Doc.set_extension("index", default=None)


def train_spacy_model(MODEL_SAVE_PATH, nlp, examples, resume=False):
    """Train the spaCy model with the given examples."""
    if examples is None:
        raise ValueError("No examples provided to train the model.")

    if resume:
        print("\nResuming training from the last saved model...")
        logging.info("Resuming training from the last saved model...")
        optimizer = nlp.resume_training()
    else:
        print("\nStarting new model training...")
        logging.info("Starting new model training...")
        optimizer = nlp.begin_training()

    best_loss = float("inf")
    patience = 3
    epochs_without_improvement = 0

    for epoch in range(50):
        random.shuffle(examples)
        losses = {}

        for example in examples:
            index = example.reference._.get("index")
            if index is not None and index % (len(examples) // 5) == 0:
                print(f"\nTraining example: '{example.reference.text[:50]}...'")
                logging.info(f"Training example: '{example.reference.text[:50]}...'")

            nlp.update([example], drop=0.2, losses=losses, sgd=optimizer)

        current_loss = losses.get("ner", 0)
        if current_loss < best_loss:
            best_loss = current_loss
            epochs_without_improvement = 0
        else:
            epochs_without_improvement += 1

        print(f"\nEpoch {epoch + 1}, Losses: {losses}")
        print("----" * 10)

        logging.info(f"Epoch {epoch + 1}, Losses: {losses}")
        logging.info("----" * 10)

        if epochs_without_improvement >= patience:
            print("Early stopping triggered. No improvement after several epochs.")
            logging.info("Early stopping triggered. No improvement after several epochs.")
            break

    os.makedirs(MODEL_SAVE_PATH, exist_ok=True)

    nlp.to_disk(MODEL_SAVE_PATH)
    print(f"Model saved to {MODEL_SAVE_PATH}")
    logging.info(f"Model saved to {MODEL_SAVE_PATH}")
