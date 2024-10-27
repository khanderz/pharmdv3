import tensorflow as tf
import pandas as pd

def process_data(data):
    dataset = tf.data.Dataset.from_tensor_slices(data)

    return list(dataset.as_numpy_iterator())
