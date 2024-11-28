from flask import Flask, request, jsonify
from google.cloud import vision
import os

app = Flask(__name__)

@app.route('/extract-text', methods=['POST'])
def extract_text():
    if 'image' not in request.files:
        return "No file provided", 400

    # Save the image locally
    image_file = request.files['image']
    image_path = os.path.join("temp", image_file.filename)
    image_file.save(image_path)

    # Initialize Vision API client
    client = vision.ImageAnnotatorClient()

    # Read the image and process it
    with open(image_path, 'rb') as image:
        content = image.read()
        image_vision = vision.Image(content=content)
        response = client.text_detection(image=image_vision)

    # Extract text
    texts = response.text_annotations
    if texts:
        extracted_text = texts[0].description
    else:
        extracted_text = "No text detected"

    # Clean up
    os.remove(image_path)

    return jsonify({'text': extracted_text})


if __name__ == '__main__':
    app.run(debug=True)
