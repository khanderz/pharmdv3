#  app/python/ai_processing/utils/training_data_processor.py

import json
import re

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

                print(f"start {train_start} end {train_end} token {token}----------------------")

                remaining_tokens = token.strip()
                print(f"remaining_tokens {remaining_tokens}")

                token_start_index = None
                token_end_index = None

                sub_tokens = remaining_tokens.split()
                print(f"Sub-tokens: {sub_tokens}")
                
                matched_tokens = []
                current_sub_token_index = 0

                while remaining_tokens and current_sub_token_index < len(sub_tokens):
                    token_found = False  
                    print(f"Matching sub-token '{sub_tokens[current_sub_token_index]}' against remaining_tokens")
                      

                    for tokenized_entity in tokenized_entities:
                        if tokenized_entity.get('token') == sub_tokens[current_sub_token_index]:

                            token_text = tokenized_entity['token'].strip()
                            token_start = tokenized_entity['start']

                            match = re.match(re.escape(sub_tokens[current_sub_token_index]), remaining_tokens)
                            if match:
                                if token_start_index is None:
                                    token_start_index = token_start

                                matched_tokens.append(tokenized_entity)
                                remaining_tokens = remaining_tokens[len(match.group(0)):].strip()  
                                print(f"Matched token: {token_text}, remaining_tokens: {remaining_tokens}")


                                token_found = True
                                current_sub_token_index += 1
                                break

                    if not token_found:
                        print(f"No matching token found for remaining_tokens: '{remaining_tokens}'")
                        break

                if current_sub_token_index >= len(sub_tokens) and not remaining_tokens:
                    print("All tokens processed for current entity.")
                    print(f"{BLUE} not remaining_tokens {remaining_tokens}{RESET}")
                    if matched_tokens:
                        token_end_index = matched_tokens[-1]['end']   
                        entity['start'] = token_start_index
                        entity['end'] = token_end_index
                else:
                    print(f"{BLUE}Not all tokens processed, remaining tokens: {remaining_tokens} {RESET}")
                print(f"{BLUE}new end and new start: {entity['start']} {entity['end']} {RESET}")
            updated_training_data.append({
                'text': text,
                'entities': entities
            })

    with open("train1.json", 'w') as outfile:
        json.dump(updated_training_data, outfile, indent=4)
