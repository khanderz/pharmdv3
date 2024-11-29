#  app/python/ai_processing/utils/training_data_processor.py

import json

from app.python.ai_processing.utils.logger import BLUE, RESET

def fix_entity_offsets(training_data, tokenized_output):

    updated_training_data = []

    deconstructed_output = []
    for data in tokenized_output:
        text = data.get('text', '')
        entities = data.get('entities', [])
        
        element = []
        for entity in entities:
            start = entity.get('start', 0)
            end = entity.get('end', 0)
            token = entity.get('token', '')

            token_element = {
                'start': start,
                'end': end,
                'token': token
            }
            element.append(token_element)
          
        deconstructed_output.append({
            'text': text,
            'entities': element
        })

    for train_data, tokenized_data in zip(training_data, deconstructed_output):
        text = train_data.get('text', '')
        entities = train_data.get('entities', [])
        tokenized_text = tokenized_data.get('text', '')
        tokenized_entities = tokenized_data.get('entities', [])
        # print(f" tokenized entities {tokenized_entities}")

        if text == tokenized_text:
            for entity in entities:
                train_start = entity.get('start', 0)
                train_end = entity.get('end', 0)
                token = entity.get('token', '')


            tokenized_sequence = []
            remaining_tokens = token
            print(f"remaining_tokens {remaining_tokens}")

            token_start_index = None
            token_end_index = None
            
            while remaining_tokens:  
                token_found = False   

                for tokenized_entity in tokenized_entities:
                    token_text = tokenized_entity['token']
                    token_start = tokenized_entity['start']
                    token_end = tokenized_entity['end']

                    print(f"tokenized_entity: {token_text}, token_start: {token_start}, token_end: {token_end}")

                    if remaining_tokens.startswith(token_text):
                        if token_start_index is None:
                            token_start_index = token_start 
                        tokenized_sequence.append(tokenized_entity)
                        remaining_tokens = remaining_tokens.replace(token_text, "", 1)
                        print(f"tokenized sequence: {tokenized_sequence}")
                        print(f"remaining_tokens: {remaining_tokens}")
                        token_found = True
                        break  

                if not token_found:
                    print("No matching token found for remaining_tokens:", remaining_tokens)
                    break 

            if not remaining_tokens:
                print("All tokens processed for current entity.")
                if tokenized_sequence:
                    token_end_index = tokenized_sequence[-1]['end']  
                    entity['start'] = token_start_index
                    entity['end'] = token_end_index

                else:
                    print(f"{BLUE}Not all tokens processed, remaining tokens: {remaining_tokens} {RESET}")

            print(f"{BLUE}Updated entity: start {entity['start']}, end {entity['end']}{RESET}")

            updated_training_data.append({
                'text': text,
                'entities': entities
            })

    with open("train1.json", 'w') as outfile:
        json.dump(updated_training_data, outfile, indent=4)
