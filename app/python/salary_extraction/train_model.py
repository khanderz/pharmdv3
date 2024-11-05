#  app/python/salary_extraction/train_model.py
import spacy
import random
from app.python.salary_extraction.entity_processing import process_extracted_entities

nlp = spacy.blank("en")

TRAIN_DATA = [
    (
        "The salary is $100,000 - $120,000 per year",
        {"entities": [(14, 24, "SALARY"), (13, 14, "CURRENCY"), (26, 34, "INTERVAL")]},
    ),
    (
        "The United States guaranteed base salary for this position is $80,000 + equity + benefits",
        {
            "entities": [
                (50, 57, "SALARY"),
                (50, 51, "CURRENCY"),
                (45, 57, "COMMITMENT"),
            ]
        },
    ),
    (
        "The expected total target compensation annually is $102,960",
        {"entities": [(46, 53, "SALARY"), (46, 47, "CURRENCY")]},
    ),
    (
        "The United States compensation for this independent contractor position is $60 per visit hour",
        {"entities": [(65, 67, "SALARY"), (65, 66, "CURRENCY"), (68, 79, "INTERVAL")]},
    ),
    (
        "Zone A: $134,950 - $167,580 + equity + benefits",
        {"entities": [(8, 22, "SALARY"), (8, 9, "CURRENCY")]},
    ),
    (
        "Zone B: $155,193 - $192,717 + equity + benefits",
        {"entities": [(8, 22, "SALARY"), (8, 9, "CURRENCY")]},
    ),
    (
        "Zone C: $168,688 - $209,475 + equity + benefits",
        {"entities": [(8, 22, "SALARY"), (8, 9, "CURRENCY")]},
    ),
    (
        "Zone D: $175,435 - $217,854 + equity + benefits",
        {"entities": [(8, 22, "SALARY"), (8, 9, "CURRENCY")]},
    ),
    (
        "The United States new hire base salary target ranges for this full-time position are: Zone A: $94,070-$122,290 + equity + benefits",
        {
            "entities": [
                (64, 78, "SALARY"),
                (64, 65, "CURRENCY"),
                (39, 49, "COMMITMENT"),
            ]
        },
    ),
    (
        "The United States new hire base salary target ranges for this full-time position are: Zone B: $108,181-$140,634 + equity + benefits",
        {
            "entities": [
                (64, 78, "SALARY"),
                (64, 65, "CURRENCY"),
                (39, 49, "COMMITMENT"),
            ]
        },
    ),
    (
        "The United States new hire base salary target ranges for this full-time position are: Zone C: $117,588-$152,863 + equity + benefits",
        {
            "entities": [
                (64, 78, "SALARY"),
                (64, 65, "CURRENCY"),
                (39, 49, "COMMITMENT"),
            ]
        },
    ),
    (
        "The United States new hire base salary target ranges for this full-time position are: Zone D: $122,291 - $158,977 + equity + benefits",
        {
            "entities": [
                (64, 78, "SALARY"),
                (64, 65, "CURRENCY"),
                (39, 49, "COMMITMENT"),
            ]
        },
    ),
    (
        "Zone A: 161,410 - 228,000 + equity + benefits",
        {"entities": [(8, 23, "SALARY")]},
    ),
    (
        "Zone B: 185,622 - 262,200 + equity + benefits",
        {"entities": [(8, 23, "SALARY")]},
    ),
    (
        "Zone C: 201,763 - 285,000 + equity + benefits",
        {"entities": [(8, 23, "SALARY")]},
    ),
    (
        "Zone D: 209,833 - 296,400 + equity + benefits",
        {"entities": [(8, 23, "SALARY")]},
    ),
]


def train_ner_model():
    ner = nlp.create_pipe("ner")
    nlp.add_pipe("ner")
    ner.add_label("SALARY")
    ner.add_label("CURRENCY")
    ner.add_label("COMMITMENT")
    ner.add_label("INTERVAL")

    optimizer = nlp.begin_training()

    for i in range(10):
        random.shuffle(TRAIN_DATA)
        for text, annotations in TRAIN_DATA:
            nlp.update([text], [annotations], sgd=optimizer)

    output_dir = "app/python/salary_extraction/model/salary_ner_model"
    nlp.to_disk(output_dir)
    print(f"Model saved to {output_dir}")


def test_model():
    text = "The salary is $100,000 - $120,000 per year."
    doc = nlp(text)
    result = process_extracted_entities(doc)
    print("Test Output for range:", result)

    text_single = "The salary is $100,000 annually."
    doc_single = nlp(text_single)
    result_single = process_extracted_entities(doc_single)
    print("Test Output for single value:", result_single)


if __name__ == "__main__":
    train_ner_model()
    test_model()
