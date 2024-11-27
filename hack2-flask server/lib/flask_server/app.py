from flask import Flask, request, jsonify
from flask_cors import CORS
import cv2
import numpy as np
import torch  # Assuming YOLOv5

app = Flask(__name__)
CORS(app)

# Load the YOLOv5 model
model = torch.hub.load('ultralytics/yolov5', 'yolov5s')

@app.route('/detect', methods=['POST'])
def detect_objects():
    if 'image' not in request.files:
        return jsonify({'error': 'No image uploaded'}), 400
    
    file = request.files['image']
    image = np.frombuffer(file.read(), np.uint8)
    image = cv2.imdecode(image, cv2.IMREAD_COLOR)

    # Perform object detection
    results = model(image)
    detected_objects = results.pandas().xyxy[0].to_dict(orient="records")

    simplified_results = [
        {
            "name": obj['name'],
            "confidence": round(obj['confidence'], 2),
            "xmin": round(obj['xmin']),
            "ymin": round(obj['ymin']),
            "xmax": round(obj['xmax']),
            "ymax": round(obj['ymax'])
        }
        for obj in detected_objects
    ]
    
    return jsonify(simplified_results)

if __name__ == '__main__':
    app.run(debug=True)
