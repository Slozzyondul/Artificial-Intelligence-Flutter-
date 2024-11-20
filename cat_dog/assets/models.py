import tensorflow as tf
import numpy as np

# Load the TFLite model
interpreter = tf.lite.Interpreter(model_path="model_unquant.tflite")
interpreter.allocate_tensors()

# Get input details
input_details = interpreter.get_input_details()
output_details = interpreter.get_output_details()

print("Input Details:")
print(input_details)

print("Output Details:")
print(output_details)

# Simulate input
input_shape = input_details[0]['shape']
dummy_input = np.random.rand(*input_shape).astype(input_details[0]['dtype'])

# Run inference
interpreter.set_tensor(input_details[0]['index'], dummy_input)
interpreter.invoke()

# Get output
output = interpreter.get_tensor(output_details[0]['index'])
print("Output:", output)
