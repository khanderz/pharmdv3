#  app/python/utils/validation_utils.py



def check_entity_alignment(nlp, text, entities):
    doc = nlp.make_doc(text)
    for start, end, label in entities:
        token_text = text[start:end]
        print(f"Entity '{token_text}' at {start}:{end} - Expected Label: {label}")

    # print(f"CHECKING ALIGNMENT ----------------------------")
    # print(f"Original Text: {text}")
    # print("Tokens: ", [token.text for token in doc])
    # print("Entities provided: ", entities)
    # print("BILUO Tags: ", biluo_tags)