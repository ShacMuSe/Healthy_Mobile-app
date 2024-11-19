import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ManualEntryPage extends StatefulWidget {
  final String barcode;
  ManualEntryPage({required this.barcode});

  @override
  _ManualEntryPageState createState() => _ManualEntryPageState();
}

class _ManualEntryPageState extends State<ManualEntryPage> {
  // Define text editing controllers for each text field
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _barcodeController = TextEditingController();
  final TextEditingController _energyController = TextEditingController();
  final TextEditingController _fatController = TextEditingController();
  final TextEditingController _saturatedFatController = TextEditingController();
  final TextEditingController _cholesterolController = TextEditingController();
  final TextEditingController _carbohydratesController =
      TextEditingController();
  final TextEditingController _sugarsController = TextEditingController();
  final TextEditingController _fiberController = TextEditingController();
  final TextEditingController _proteinController = TextEditingController();
  final TextEditingController _saltController = TextEditingController();
  final TextEditingController _sodiumController = TextEditingController();
  final TextEditingController _potassiumController = TextEditingController();
  final TextEditingController _chlorideController = TextEditingController();
  final TextEditingController _calciumController = TextEditingController();
  final TextEditingController _ironController = TextEditingController();
  final TextEditingController _magnesiumController = TextEditingController();
  final TextEditingController _caffeineController = TextEditingController();
  final TextEditingController _fruitsController = TextEditingController();
  final TextEditingController _cocoaController = TextEditingController();

  String? _prediction;

  // Function to reclassify the product
  void _classifyProduct() {
    if (_prediction == '0') {
      _prediction = 'Moderately Healthy';
    } else if (_prediction == '1') {
      _prediction = 'Good';
    } else if (_prediction == '2') {
      _prediction = 'Neutral';
    } else if (_prediction == '3') {
      _prediction = 'Moderately Unhealthy';
    } else if (_prediction == '4') {
      _prediction = 'Unhealthy';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manual Entry'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            SizedBox(
              height: 40,
              child: Text(
                'Barcode: ${widget.barcode}',
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _productNameController,
              decoration: InputDecoration(
                labelText: 'Product Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'Enter Nutrition Facts:',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _energyController,
              decoration: InputDecoration(
                labelText: 'Energy (kcal)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _fatController,
              decoration: InputDecoration(
                labelText: 'Fat (g)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _saturatedFatController,
              decoration: InputDecoration(
                labelText: 'Saturated Fat (g)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _cholesterolController,
              decoration: InputDecoration(
                labelText: 'Cholesterol (mg)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _carbohydratesController,
              decoration: InputDecoration(
                labelText: 'Carbohydrates (g)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _sugarsController,
              decoration: InputDecoration(
                labelText: 'Sugars (g)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _fiberController,
              decoration: InputDecoration(
                labelText: 'Fiber (g)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _proteinController,
              decoration: InputDecoration(
                labelText: 'Protein (g)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _saltController,
              decoration: InputDecoration(
                labelText: 'Salt (g)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _sodiumController,
              decoration: InputDecoration(
                labelText: 'Sodium (mg)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _potassiumController,
              decoration: InputDecoration(
                labelText: 'Potassium (mg)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _chlorideController,
              decoration: InputDecoration(
                labelText: 'Chloride (mg)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _calciumController,
              decoration: InputDecoration(
                labelText: 'Calcium (mg)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _ironController,
              decoration: InputDecoration(
                labelText: 'Iron (mg)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _magnesiumController,
              decoration: InputDecoration(
                labelText: 'Magnesium (mg)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _caffeineController,
              decoration: InputDecoration(
                labelText: 'Caffeine (mg)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _fruitsController,
              decoration: InputDecoration(
                labelText: 'Fruits (%)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _cocoaController,
              decoration: InputDecoration(
                labelText: 'Cocoa (%)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _handlePrediction(context);
              },
              child: Text('Predict'),
            ),
            SizedBox(height: 20.0),
            if (_prediction != null)
              Text(
                'Product Classification: $_prediction',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }

  void _handlePrediction(BuildContext context) async {
    // Get the values entered by the user from the text fields
    String productName = _productNameController.text;
    String barcode = _barcodeController.text;
    String energy = _energyController.text;
    String fat = _fatController.text;
    String saturatedFat = _saturatedFatController.text;
    String cholesterol = _cholesterolController.text;
    String carbohydrates = _carbohydratesController.text;
    String sugars = _sugarsController.text;
    String fiber = _fiberController.text;
    String proteins = _proteinController.text;
    String salt = _saltController.text;
    String sodium = _sodiumController.text;
    String potassium = _potassiumController.text;
    String chloride = _chlorideController.text;
    String calcium = _calciumController.text;
    String iron = _ironController.text;
    String magnesium = _magnesiumController.text;
    String caffeine = _caffeineController.text;
    String fruits = _fruitsController.text;
    String cocoa = _cocoaController.text;

    // Prepare the data to be sent in the POST request
    Map<String, dynamic> requestData = {
      'product_name': productName,
      'barcode': barcode,
    };

    // Add non-empty nutrition facts to requestData
    if (energy.isNotEmpty) {
      requestData['energy'] = double.parse(energy);
    }
    if (fat.isNotEmpty) {
      requestData['fat'] = double.parse(fat);
    }
    if (saturatedFat.isNotEmpty) {
      requestData['saturated_fat'] = double.parse(saturatedFat);
    }
    if (cholesterol.isNotEmpty) {
      requestData['cholesterol'] = double.parse(cholesterol);
    }
    if (carbohydrates.isNotEmpty) {
      requestData['carbohydrates'] = double.parse(carbohydrates);
    }
    if (sugars.isNotEmpty) {
      requestData['sugars'] = double.parse(sugars);
    }
    if (fiber.isNotEmpty) {
      requestData['fiber'] = double.parse(fiber);
    }
    if (proteins.isNotEmpty) {
      requestData['proteins'] = double.parse(proteins);
    }
    if (salt.isNotEmpty) {
      requestData['salt'] = double.parse(salt);
    }
    if (sodium.isNotEmpty) {
      requestData['sodium'] = double.parse(sodium);
    }
    if (potassium.isNotEmpty) {
      requestData['potassium'] = double.parse(potassium);
    }
    if (chloride.isNotEmpty) {
      requestData['chloride'] = double.parse(chloride);
    }
    if (calcium.isNotEmpty) {
      requestData['calcium'] = double.parse(calcium);
    }
    if (iron.isNotEmpty) {
      requestData['iron'] = double.parse(iron);
    }
    if (magnesium.isNotEmpty) {
      requestData['magnesium'] = double.parse(magnesium);
    }
    if (caffeine.isNotEmpty) {
      requestData['caffeine'] = double.parse(caffeine);
    }
    if (fruits.isNotEmpty) {
      requestData['fruits'] = double.parse(fruits);
    }
    if (cocoa.isNotEmpty) {
      requestData['cocoa'] = double.parse(cocoa);
    }

    // Make the prediction API call with the entered values
    var predictionUrl = Uri.parse('http://20.199.9.126:5050/predict');
    var response = await http.post(
      predictionUrl,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(requestData),
    );

    print('Prediction API Response: ${response.statusCode} - ${response.body}');

    if (response.statusCode == 200) {
      // If the prediction is successful, parse the response
      var prediction = json.decode(response.body)['predictions'][0];

      // Update the state with the prediction
      setState(() {
        _prediction = prediction.toString();
        _classifyProduct();
      });
    } else {
      // If there is an error in the prediction API call, display an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Prediction failed. Please try again.'),
        ),
      );
    }
  }
}
