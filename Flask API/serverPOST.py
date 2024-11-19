from flask import Flask, request, jsonify
import requests
import joblib
import json
from flask_cors import CORS

app = Flask(__name__)
CORS(app)  # This will enable CORS for all routes

@app.route('/predict', methods=['POST'])
def predict():
    # Parse JSON data from the request body
    request_data = request.get_json()
    print(request_data)

    # Extract individual nutrition values
    x1 = float(request_data.get('energy', 0))
    x2 = float(request_data.get('fat', 0))
    x3 = float(request_data.get('saturated_fat', 0))
    x4 = float(request_data.get('cholesterol', 0))
    x5 = float(request_data.get('carbohydrates', 0))
    x6 = float(request_data.get('sugars', 0))
    x7 = float(request_data.get('fiber', 0))
    x8 = float(request_data.get('proteins', 0))
    x9 = float(request_data.get('salt', 0))
    x10 = float(request_data.get('sodium', 0))
    x11 = float(request_data.get('potassium', 0))
    x12 = float(request_data.get('chloride', 0))
    x13 = float(request_data.get('calcium', 0))
    x14 = float(request_data.get('iron', 0))
    x15 = float(request_data.get('magnesium', 0))
    x16 = float(request_data.get('caffeine', 0))
    x17 = float(request_data.get('fruits', 0))
    x18 = float(request_data.get('cocoa', 0))

    # Prepare example data for prediction
    example_data = [[x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18]]
    print(example_data)
    # Load the joblib model
    model = joblib.load('C:/Users/dali_/OneDrive/Bureau/5edma/PFA/xgboost_model18.joblib')

    # Make predictions using the loaded model
    predictions = model.predict(example_data)

    return jsonify({'predictions': predictions.tolist()})


if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True, port=5000)
