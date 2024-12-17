
import gc
import torch
from app.python.ai_processing.utils.logger import (
    BLUE,
    RED,
    RESET,
    configure_logging,
    configure_warnings,
)
from transformers import LongformerTokenizer, LongformerModel
from spacy.training import iob_to_biluo

from app.python.ai_processing.utils.trainer import train_spacy_model

configure_warnings()
configure_logging()

tokenizer = LongformerTokenizer.from_pretrained("allenai/longformer-base-4096")
transformer = LongformerModel.from_pretrained("allenai/longformer-base-4096")

MAX_SEQ_LENGTH = 4096

def return_paths(attribute_type):
    if attribute_type == "job_qualifications":
        from app.python.ai_processing.job_qualifications.train_job_qualifications import (
            qualifications_nlp,
            QUALIFICATIONS_MODEL_SAVE_PATH,
            qualification_examples,
        )

        return (
            qualifications_nlp,
            QUALIFICATIONS_MODEL_SAVE_PATH,
            qualification_examples,
        )
    elif attribute_type == "job_description":
        from app.python.ai_processing.job_description.train_job_description import (
            description_nlp,
            DESCRIPTION_MODEL_SAVE_PATH,
            description_examples,
        )

        return (
            description_nlp,
            DESCRIPTION_MODEL_SAVE_PATH,
            description_examples,
        )
    elif attribute_type == "job_responsibilities":
        from app.python.ai_processing.job_responsibilities.train_responsibilities import (
            responsibilities_nlp,
            RESPONSIBILITIES_MODEL_SAVE_PATH,
            responsibilities_examples,
        )

        return (
            responsibilities_nlp,
            RESPONSIBILITIES_MODEL_SAVE_PATH,
            responsibilities_examples,
        )
    elif attribute_type == "job_benefits":
        from app.python.ai_processing.job_benefits.train_job_benefits import (
            benefits_nlp,
            BENEFITS_MODEL_SAVE_PATH,
            benefits_examples,
        )

        return (
            benefits_nlp,
            BENEFITS_MODEL_SAVE_PATH,
            benefits_examples,
        )
    elif attribute_type == "salary":
        from app.python.ai_processing.salary.train_salary import (
            salary_nlp,
            SALARY_MODEL_SAVE_PATH,
            salary_examples,
        )

        return (
            salary_nlp,
            SALARY_MODEL_SAVE_PATH,
            salary_examples,
        )
    else:
        raise ValueError("Invalid attribute type provided.")


def convert_example_to_biluo(text, nlp, attribute_type):
    """Convert model predictions for the given text to BILUO format."""

    if attribute_type != "salary":
        tokens = tokenizer(
            text,
            max_length=MAX_SEQ_LENGTH,
            truncation=True,
            padding="max_length",
            return_tensors="pt",
        )

        decoded_text = tokenizer.decode(
            tokens["input_ids"][0], skip_special_tokens=True
        )

        doc = nlp(decoded_text)

        iob_tags = [
            token.ent_iob_ + "-" + token.ent_type_ if token.ent_type_ else "O"
            for token in doc
        ]
        biluo_tags = iob_to_biluo(iob_tags)
    else:
        doc = nlp(text)

        iob_tags = [
            token.ent_iob_ + "-" + token.ent_type_ if token.ent_type_ else "O"
            for token in doc
        ]
        biluo_tags = iob_to_biluo(iob_tags)

    return doc, biluo_tags



def train_models_sequentially():
    """
    Train each model one at a time to avoid overloading memory.
    """
    attribute_types = [
        "job_qualifications",
        "job_description",
        "job_responsibilities",
        "job_benefits",
        "salary",
    ]

    for attribute_type in attribute_types:
        print(f"{BLUE}Training model for {attribute_type}...{RESET}")

        nlp_model, model_save_path, examples = return_paths(attribute_type)

        try:
            train_spacy_model(model_save_path, nlp_model, examples, resume=False)
        except Exception as e:
            print(f"{RED}Error during training {attribute_type}: {str(e)}{RESET}")


        print(f"{BLUE}Saving model to {model_save_path}{RESET}")
        nlp_model.to_disk(model_save_path)

        del nlp_model
        torch.cuda.empty_cache()
        gc.collect()
        print(f"{BLUE}Finished training for {attribute_type}.\n{RESET}")


if __name__ == "__main__":
    train_models_sequentially()