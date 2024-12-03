# app/python/ai_processing/utils/spacy_utils.py

import os
import spacy
import torch
from spacy.tokens import DocBin
from spacy.training import Example
from app.python.ai_processing.utils.data_handler import (
    generate_path,
    hash_train_data,
    load_data,
)
from app.python.ai_processing.utils.logger import BLUE, RED, RESET


# ------------------- LOAD/CONVERT SPACY TO BILUO -------------------
def handle_spacy_data(
    SPACY_DATA_PATH,
    CONVERTED_FILE,
    FOLDER,
    nlp,
    tokenizer=None,
    MAX_SEQ_LENGTH=None,
    longformer_model=None,
):
    last_hash_path = generate_path("last_train_data_hash.txt", FOLDER)
    examples = []

    current_hash = hash_train_data(FOLDER, CONVERTED_FILE)
    last_hash = None

    if os.path.exists(SPACY_DATA_PATH):
        try:
            with open(last_hash_path, "r") as f:
                last_hash = f.read().strip()
                print(f"{BLUE}Last hash for converted file found: {last_hash}{RESET}")
        except FileNotFoundError:
            print(
                f"{RED}Warning: last_converted_file_hash.txt not found. Assuming no prior hash.{RESET}"
            )

        if current_hash == last_hash:
            print(
                f"{BLUE}Training data has not changed. Loading existing data...{RESET}"
            )

            doc_bin = DocBin().from_disk(SPACY_DATA_PATH)
            docs = list(doc_bin.get_docs(nlp.vocab))

            if docs:
                print(f"{BLUE}Loaded {len(docs)} documents from doc_bin.{RESET}")

                examples = []
                for doc in docs:
                    entities = [
                        (ent.start_char, ent.end_char, ent.label_) for ent in doc.ents
                    ]
                    examples.append(Example.from_dict(doc, {"entities": entities}))

            else:
                print(f"{RED}No documents loaded from doc_bin.{RESET}")

            return doc_bin, examples
        else:
            print(f"{BLUE}Training data has changed. Converting data now...{RESET}")
            train_data = load_data(CONVERTED_FILE, FOLDER)
            doc_bin, examples = convert_to_spacy_format(
                train_data,
                SPACY_DATA_PATH,
                nlp,
                tokenizer,
                MAX_SEQ_LENGTH,
                longformer_model,
            )

            try:
                doc_bin.to_disk(SPACY_DATA_PATH)
                print(f"{BLUE}Data saved to {SPACY_DATA_PATH}{RESET}")

                with open(last_hash_path, "w") as f:
                    f.write(current_hash)
            except Exception as e:
                print(f"{RED}Error saving doc_bin: {e}{RESET}")

    else:
        print(
            f"{BLUE}Converted to spacy data does not exist. Converting data now...{RESET}"
        )
        train_data = load_data(CONVERTED_FILE, FOLDER)
        doc_bin, examples = convert_to_spacy_format(
            train_data,
            SPACY_DATA_PATH,
            nlp,
            tokenizer,
            MAX_SEQ_LENGTH,
            longformer_model,
        )

        try:
            doc_bin.to_disk(SPACY_DATA_PATH)
            print(f"{BLUE}Data saved to {SPACY_DATA_PATH}{RESET}")

            with open(last_hash_path, "w") as f:
                f.write(current_hash)
        except Exception as e:
            print(f"{RED}Error saving doc_bin: {e} {RESET}")

    return doc_bin, examples


def convert_to_spacy_format(
    train_data,
    SPACY_DATA_PATH,
    nlp,
    tokenizer=None,
    MAX_SEQ_LENGTH=None,
    longformer_model=None,
):
    """Convert training data to spaCy format with BILUO alignment."""
    db = DocBin()
    nlp = spacy.blank("en")

    print(f"---------------CONVERTING TRAIN DATA TO SPACY FORMAT...")

    examples = []
    for _, entry in enumerate(train_data):
        text = entry["text"]
        entities = entry.get("entities", [])
        doc = nlp(text)
        # print(f"entities: {entities}")
        example_entities = [
            (int(ent["start"]), int(ent["end"]), ent["label"]) for ent in entities
        ]

        spans = [
            doc.char_span(start, end, label=label)
            for start, end, label in example_entities
        ]

        spans = [span for span in spans if span is not None]
        doc.ents = spans

        example = Example.from_dict(doc, {"entities": example_entities})
        db.add(doc)
        examples.append(example)

    if tokenizer and MAX_SEQ_LENGTH and longformer_model:
        print(f"Processing embeddings for {len(examples)} examples...")
        batch_size = 8
 
        for i in range(0, len(examples), batch_size):
            batch_docs = examples[i : i + batch_size]
            batch_texts = [example.reference.text for example in batch_docs]
            print(f"Processing batch {i + 1} - {i + len(batch_docs)}...")
            batch_inputs = tokenizer(
                batch_texts,
                max_length=MAX_SEQ_LENGTH,
                truncation=True,
                padding="max_length",
                return_tensors="pt",
            )
            outputs = longformer_model(**batch_inputs)
            batch_embeddings = outputs.last_hidden_state.cpu().detach().numpy()

            for j, example in enumerate(batch_docs):
                doc = example.reference
                entities = [
                    (ent.start_char, ent.end_char, ent.label_) for ent in doc.ents
                ]
                examples[i + j] = Example.from_dict(doc, {"entities": entities})
        
            del batch_inputs, outputs, batch_embeddings
            torch.cuda.empty_cache()
    print(f"---------------CONVERSION COMPLETE.")
    db.to_disk(SPACY_DATA_PATH)
    loaded_db = DocBin().from_disk(SPACY_DATA_PATH)
    loaded_docs = list(loaded_db.get_docs(nlp.vocab))

    if not list(loaded_db.get_docs(nlp.vocab)):
        print(f"{RED}Warning: No documents were added to `doc_bin`.{RESET}")
    else:
        print(f"{BLUE}{len(loaded_docs)} documents saved/added to `doc_bin`.{RESET}")

    return db, examples
