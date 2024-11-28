'''using google cloud vision billing needed'''

# from flask import Flask, request, jsonify
# #from google.cloud import vision
# import pytesseract
# import os

# app = Flask(__name__)



# # Route to handle text extraction
# @app.route('/extract-text', methods=['POST'])
# def extract_text():
#     try:
#         # Check if an image is provided in the request
#         if 'image' not in request.files:
#             return jsonify({'error': 'No file provided'}), 400

#         # Save the uploaded image locally
#         image_file = request.files['image']
#         temp_dir = 'temp'
#         if not os.path.exists(temp_dir):  # Ensure the temp directory exists
#             os.makedirs(temp_dir)

#         image_path = os.path.join(temp_dir, image_file.filename)
#         image_file.save(image_path)

#         # Initialize the Google Vision API client
#         #client = vision.ImageAnnotatorClient.from_service_account_json("/home/ondul/Desktop/Artificial-Intelligence-Flutter-/hack3-flask server - Image-to-text convertor app/ai-learning-flutter-29e2d0764fdd.json")


#         # Read the image and process it with Vision API
#         with open(image_path, 'rb') as image:
#             content = image.read()
#             #image_vision = vision.Image(content=content)
#             #response = client.text_detection(image=image_vision)

#         # Extract text from the response
#         texts = response.text_annotations
#         extracted_text = texts[0].description if texts else "No text detected"

#         # Clean up the saved image file
#         os.remove(image_path)

#         # Return the extracted text
#         return jsonify({'text': extracted_text})

#     except Exception as e:
#         # Handle unexpected errors
#         return jsonify({'error': str(e)}), 500


# if __name__ == '__main__':
#     app.run(debug=True)


'''using tesseract free alternative'''
from flask import Flask, request, jsonify
from PIL import Image
import pytesseract
import os

app = Flask(__name__)

@app.route('/extract-text', methods=['POST'])
def extract_text():
    if 'image' not in request.files:
        return "No file provided", 400

    # Save the image locally
    image_file = request.files['image']
    image_path = os.path.join("temp", image_file.filename)
    os.makedirs("temp", exist_ok=True)  # Ensure temp directory exists
    image_file.save(image_path)

    # Use Tesseract OCR to extract text
    try:
        image = Image.open(image_path)
        extracted_text = pytesseract.image_to_string(image)
    except Exception as e:
        extracted_text = f"Error during text extraction: {str(e)}"

    # Clean up
    os.remove(image_path)

    return jsonify({'text': extracted_text})


if __name__ == '__main__':
    app.run(debug=True)

