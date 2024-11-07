#  app/python/utils/validation_utils.py

from spacy.training.iob_utils import offsets_to_biluo_tags


def check_entity_alignment(nlp, text, entities):
    doc = nlp.make_doc(text)
    biluo_tags = offsets_to_biluo_tags(doc, entities)

    print(f"CHECKING ALIGNMENT ----------------------------")
    print(f"Original Text: {text}")
    print("Tokens: ", [token.text for token in doc])
    print("Entities provided: ", entities)
    print("BILUO Tags: ", biluo_tags)