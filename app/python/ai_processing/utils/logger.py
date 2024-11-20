# app/python/utils/logger.py

import warnings
import logging

RED = "\033[31m"
GREEN = "\033[32m"
BLUE = "\033[34m"
RESET = "\033[0m"


def configure_warnings():
    warnings.filterwarnings("ignore", message="`resume_download` is deprecated")
    warnings.filterwarnings(
        "ignore",
        message="Some weights of the model checkpoint at roberta-base were not used",
    )
    warnings.filterwarnings(
        "ignore",
        message="Some weights of RobertaModel were not initialized from the model checkpoint",
    )
    warnings.simplefilter(action="ignore", category=FutureWarning)
    warnings.filterwarnings("ignore", category=UserWarning)


def configure_logging():
    logging.getLogger("transformers").setLevel(logging.WARNING)
    logging.getLogger("torch").setLevel(logging.WARNING)
    logging.getLogger("transformers").setLevel(logging.ERROR)
    logging.getLogger("torch").setLevel(logging.ERROR)
