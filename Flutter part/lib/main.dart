import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'ManualEntryPage.dart';
import 'SearchScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.green),
      home: HomeScreen(),
    );
  }
}

class ScannedProduct {
  final String productName;
  final String productCategory;
  final String productImage;
  final List<String> nutritionFacts;
  final String productClassification;

  ScannedProduct({
    required this.productName,
    required this.productImage,
    required this.productCategory,
    required this.nutritionFacts,
    required this.productClassification,
  });

  // Convert scanned product to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'productName': productName,
      'productImage': productImage,
      'productCategory': productCategory,
      'nutritionFacts': nutritionFacts,
      'productClassification': productClassification,
    };
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _barcodeController = TextEditingController();
  TextEditingController _energyController = TextEditingController();
  TextEditingController _fatController = TextEditingController();
  TextEditingController _saturatedFatController = TextEditingController();
  TextEditingController _cholesterolController = TextEditingController();
  TextEditingController _carbohydratesController = TextEditingController();
  TextEditingController _sugarsController = TextEditingController();
  TextEditingController _fiberController = TextEditingController();
  TextEditingController _proteinController = TextEditingController();
  TextEditingController _saltController = TextEditingController();
  TextEditingController _sodiumController = TextEditingController();
  TextEditingController _potassiumController = TextEditingController();
  TextEditingController _chlorideController = TextEditingController();
  TextEditingController _calciumController = TextEditingController();
  TextEditingController _ironController = TextEditingController();
  TextEditingController _magnesiumController = TextEditingController();
  TextEditingController _caffeineController = TextEditingController();
  TextEditingController _fruitsController = TextEditingController();
  TextEditingController _cocoaController = TextEditingController();
  List<String> _nutritionFacts = [];
  List<String> _nutritionElementNames = [
    "Energy",
    "Fat",
    "Saturated Fat",
    "Cholesterol",
    "Carbohydrates",
    "Sugars",
    "Fiber",
    "Proteins",
    "Salt",
    "Sodium",
    "Potassium",
    "Chloride",
    "Calcium",
    "Iron",
    "Magnesium",
    "Caffeine",
    "Fruits, Vegetables, Nuts",
    "Cocoa",
  ];
  String _productName = '';
  String _productImage = '';
  String _productClassification = '';
  String _scanBarcodeResult = '';
  String _productCategory = '';
  String _apiResponse = '';

  double? _parseDouble(String? value) {
    // Check if the value is not null and not empty before parsing to double
    if (value != null && value.isNotEmpty) {
      return double.tryParse(value);
    }
    // Return null if the value is null or empty
    return null;
  }

  Future<void> fetchData() async {
    try {
      // Check Firestore for existing barcode data
      ScannedProduct? existingProduct =
          await fetchProductFromFirestore(_scanBarcodeResult);

      if (existingProduct != null) {
        // If the product exists in Firestore, update the state with the retrieved data
        setState(() {
          _productName = existingProduct.productName;
          _productImage = existingProduct.productImage;
          _productCategory = existingProduct.productCategory;
          _nutritionFacts = existingProduct.nutritionFacts;
          _productClassification = existingProduct.productClassification;
        });
        _fetchRecommendedProductsIfNeeded();
        return;
      }

      // If the product does not exist in Firestore, fetch data from the API
      String barcode = _barcodeController.text.trim();
      String apiUrl =
          'https://world.openfoodfacts.org/api/v3/product/$_scanBarcodeResult.json';

      try {
        // Send a GET request to the server
        http.Response response = await http.get(Uri.parse(apiUrl));

        if (response.statusCode == 200) {
          // Decode the response JSON
          Map<String, dynamic> responseData = jsonDecode(response.body);
          Map<String, dynamic> product = responseData['product']['nutriments'];

          // Extract values and assign '0' to null ones
          String energy =
              product['energy-kcal_value_computed']?.toString() ?? '0';
          String fat = product['fat_value']?.toString() ?? '0';
          String saturated_fat =
              product['saturated-fat_value']?.toString() ?? '0';
          String cholesterol = product['cholesterol_value']?.toString() ?? '0';
          String carbohydrates =
              product['carbohydrates_value']?.toString() ?? '0';
          String sugars = product['sugars_value']?.toString() ?? '0';
          String fiber = product['fiber_value']?.toString() ?? '0';
          String proteins = product['proteins_value']?.toString() ?? '0';
          String salt = product['salt_value']?.toString() ?? '0';
          String sodium = product['sodium_value']?.toString() ?? '0';
          String potassium = product['potassium_value']?.toString() ?? '0';
          String chloride = product['chloride_value']?.toString() ?? '0';
          String calcium = product['calcium_value']?.toString() ?? '0';
          String iron = product['iron_value']?.toString() ?? '0';
          String magnesium = product['magnesium_value']?.toString() ?? '0';
          String caffeine = product['caffeine_value']?.toString() ?? '0';
          String fruits =
              product['fruits-vegetables-nuts_value']?.toString() ?? '0';
          String cocoa = product['cocoa_value']?.toString() ?? '0';

          // Extract nutrition facts from the API response
          setState(() {
            _nutritionFacts = [
              "Energy: $energy",
              "Fat: $fat g",
              "Saturated Fat: $saturated_fat g",
              "Cholesterol: $cholesterol mg",
              "Carbohydrates: $carbohydrates g",
              "Sugars: $sugars g",
              "Fiber: $fiber g",
              "Proteins: $proteins g",
              "Salt: $salt g",
              "Sodium: $sodium mg",
              "Potassium: $potassium mg",
              "Chloride: $chloride mg",
              "Calcium: $calcium mg",
              "Iron: $iron mg",
              "Magnesium: $magnesium mg",
              "Caffeine: $caffeine mg",
              "Fruits, Vegetables, Nuts: $fruits g",
              "Cocoa: $cocoa mg",
            ];

            // Set product name and image
            _productName = responseData['product']['product_name'];
            _productImage = responseData['product']['image_url'];
            _productCategory = responseData['product']['categories'];
          });

          // Construct the JSON payload
          Map<String, dynamic> payload = {
            'energy': energy,
            'fat': fat,
            'saturated_fat': saturated_fat,
            'cholesterol': cholesterol,
            'carbohydrates': carbohydrates,
            'sugars': sugars,
            'fiber': fiber,
            'proteins': proteins,
            'salt': salt,
            'sodium': sodium,
            'potassium': potassium,
            'chloride': chloride,
            'calcium': calcium,
            'iron': iron,
            'magnesium': magnesium,
            'caffeine': caffeine,
            'fruits': fruits,
            'cocoa': cocoa,
          };

          try {
            // Send a POST request to the server
            http.Response postResponse = await http.post(
              Uri.parse('http://20.199.9.126:5050/predict'),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode(payload),
            );

            if (postResponse.statusCode == 200) {
              // Decode the response JSON
              Map<String, dynamic> postResponseData =
                  jsonDecode(postResponse.body);

              // Retrieve the value of the predictions field
              List<dynamic> predictions = postResponseData['predictions'];

              // Assuming you want to convert the list to a string for display
              String pred = predictions.join(', ');

              setState(() {
                _productClassification = '$pred';
              });

              // Classify the product
              _classifyProduct();
              _fetchRecommendedProductsIfNeeded();
              // Save scanned product to Firestore
              ScannedProduct scannedProduct = ScannedProduct(
                productName: _productName,
                productCategory: _productCategory,
                productImage: _productImage,
                nutritionFacts: _nutritionFacts,
                productClassification: _productClassification,
              );
              saveScannedProductToFirestore(scannedProduct, _scanBarcodeResult);
            } else {
              throw Exception(
                  'Failed to fetch predictions. Status code: ${postResponse.statusCode}');
            }
          } catch (e) {
            print('Error: $e');
          }

          setState(() {
            _apiResponse = 'nutirments :\n'
                'Energy : $energy\n'
                'Fat : $fat\n'
                'Saturated Fat : $saturated_fat\n'
                'Cholesterol : $cholesterol\n'
                'Carbohydrates : $carbohydrates\n'
                'Sugars : $sugars\n'
                'Fiber : $fiber\n'
                'Proteins : $proteins\n'
                'Salt : $salt\n'
                'Sodium : $sodium\n'
                'Potassium : $potassium\n'
                'Chloride : $chloride\n'
                'Calcium : $calcium\n'
                'Iron : $iron\n'
                'Magnesium : $magnesium\n'
                'Caffeine : $caffeine\n'
                'Fruits : $fruits\n'
                'Cocoa : $cocoa\n\n';
          });
        } else {
          // If no data fetched from API, navigate to second page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ManualEntryPage(barcode: _scanBarcodeResult),
            ),
          );
          throw Exception(
              'Failed to fetch predictions. Status code: ${response.statusCode}');
        }
      } catch (e) {
        print('Error: $e');
      }
    } catch (error) {
      print('Error: $error');
      // Display error message as a Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load data. Please try again later.'),
        ),
      );
    }
  }

  Future<List<ScannedProduct>> fetchProductsByCategory(String category) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('scanned_products')
          .where('productCategory', isEqualTo: category)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.map((doc) {
          return ScannedProduct(
            productName: doc['productName'],
            productCategory: doc['productCategory'],
            productImage: doc['productImage'],
            nutritionFacts: List<String>.from(doc['nutritionFacts']),
            productClassification: doc['productClassification'],
          );
        }).toList();
      }
      return [];
    } catch (e) {
      print('Error fetching products by category: $e');
      return [];
    }
  }

  List<ScannedProduct> _recommendedProducts = [];

// Method to fetch and filter recommended products
  void _fetchRecommendedProducts(String category) {
    fetchProductsByCategory(category).then((products) {
      // Filter products with classification 'Healthy' or 'Moderately Healthy'
      _recommendedProducts = products
          .where((product) => product.productClassification == 'Healthy'
          //|| product.productClassification == 'Moderately Healthy'
        )
          .toList();
      setState(() {});
    });
  }

// Call this method when the product classification meets the criteria
  void _fetchRecommendedProductsIfNeeded() {
    if (_productClassification == 'Unhealthy' ||
        _productClassification == 'Moderately Unhealthy' ||
        _productClassification == 'Moderately Healthy' ||
        _productClassification == 'Neutral') {
      _fetchRecommendedProducts(_productCategory);
    }
  }

  String classifyNutrient(String nutrient, String nutrientName) {
    try {
      switch (nutrientName) {
        case 'Fat':
          double fatValue =
              double.parse(nutrient.split(" ")[1].replaceAll('g', ''));
          if (fatValue <= 10) {
            return 'Good';
          } else if (fatValue > 20) {
            return 'Bad';
          }
          break;
        case 'Saturated Fat':
          double saturatedFatValue =
              double.parse(nutrient.split(" ")[2].replaceAll('g', ''));
          if (saturatedFatValue <= 5) {
            return 'Good';
          } else if (saturatedFatValue > 10) {
            return 'Bad';
          }
          break;
        case 'Sugars':
          double sugarsValue =
              double.parse(nutrient.split(" ")[1].replaceAll('g', ''));
          if (sugarsValue <= 5) {
            return 'Good';
          } else if (sugarsValue > 15) {
            return 'Bad';
          }
          break;
        case 'Protein':
          double proteinValue =
              double.parse(nutrient.split(" ")[1].replaceAll('g', ''));
          if (proteinValue >= 10) {
            return 'Good';
          }
          break;
        case 'Fiber':
          double fiberValue =
              double.parse(nutrient.split(" ")[1].replaceAll('g', ''));
          if (fiberValue >= 5) {
            return 'Good';
          }
          break;
        case 'Vitamin C':
          double vitaminCValue =
              double.parse(nutrient.split(" ")[1].replaceAll('mg', ''));
          if (vitaminCValue >= 30) {
            return 'Good';
          }
          break;
        case 'Calcium':
          double calciumValue =
              double.parse(nutrient.split(" ")[1].replaceAll('mg', ''));
          if (calciumValue >= 200) {
            return 'Good';
          }
          break;
      }
      return 'Unknown';
    } catch (e) {
      print('Error parsing nutrient string: $nutrient');
      print(e);
      return 'Unknown';
    }
  }

  // Function to get the color for the circle based on nutrient classification
  Color getColorForNutrientClassification(String classification) {
    switch (classification) {
      case 'Good':
        return Colors.green;
      case 'Bad':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Function to reclassify the product
  void _classifyProduct() {
    if (_productClassification == '0') {
      _productClassification = 'Healthy';
    } else if (_productClassification == '1') {
      _productClassification = 'Moderately Healthy';
    } else if (_productClassification == '2') {
      _productClassification = 'Neutral';
    } else if (_productClassification == '3') {
      _productClassification = 'Moderately Unhealthy';
    } else if (_productClassification == '4') {
      _productClassification = 'Unhealthy';
    }
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6656',
        'Cancel',
        true,
        ScanMode.BARCODE,
      );
      debugPrint(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;

    if (barcodeScanRes.isNotEmpty) {
      setState(() {
        _scanBarcodeResult = barcodeScanRes;
        // Reset other product details to empty or default values
        _productName = '';
        _productImage = '';
        _productCategory = '';
        _nutritionFacts.clear();
        _productClassification = '';
        _recommendedProducts = [];
      });
      // Fetch data for the new barcode
      fetchData();
    }
  }

  // Method to save scanned product to Firestore
  Future<void> saveScannedProductToFirestore(
      ScannedProduct product, String barcode) async {
    try {
      await FirebaseFirestore.instance.collection('scanned_products').add({
        ...product.toMap(),
        'barcode': barcode,
      });
    } catch (e) {
      print('Error saving product: $e');
    }
  }

  //Methode to Check Firestore for an Existing Barcode
  Future<ScannedProduct?> fetchProductFromFirestore(String barcode) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('scanned_products')
        .where('barcode', isEqualTo: barcode)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final doc = querySnapshot.docs.first;
      return ScannedProduct(
        productName: doc['productName'],
        productCategory: doc['productCategory'],
        productImage: doc['productImage'],
        nutritionFacts: List<String>.from(doc['nutritionFacts']),
        productClassification: doc['productClassification'],
      );
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Information'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _productImage.isNotEmpty
                ? Center(
                  child: Image.network(
                    _productImage,
                    width: 130,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                )
                : SizedBox.shrink(),
            SizedBox(height: 5.0),
            Text(
              'Product Name: $_productName',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5.0),
            Text(
              'Extracted Nutrition Facts:',
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(height: 4.0),
            Expanded(
              child: ListView.builder(
                itemCount: _nutritionFacts.length,
                itemBuilder: (context, index) {
                  // Classify each nutrition element
                  String classification = classifyNutrient(
                      _nutritionFacts[index], _nutritionElementNames[index]);

                  // Get color for the circle based on classification
                  Color circleColor =
                      getColorForNutrientClassification(classification);

                  return Column(
                    children: [
                      ListTile(
                        leading: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: circleColor,
                          ),
                        ),
                        title: Text(
                          _nutritionFacts[index],
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ),
                      Divider(),
                    ],
                  );
                },
              ),
            ),
            SizedBox(height: 0.1),
            Text(
              'Product Classification: $_productClassification',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            // Recommended products section
            if (_recommendedProducts.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 1.0),
                  Text(
                    'Recommended Products',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 1.0),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      height: 100.0, // Adjust height as needed
                      child: Row(
                        children: _recommendedProducts.map((product) {
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Image.network(
                                  product.productImage,
                                  width: 40,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                                SizedBox(height: 1.0),
                                Text(
                                  product.productName,
                                  style: TextStyle(fontSize: 8.0),
                                ),
                                Text(
                                  product.productClassification,
                                  style: TextStyle(fontSize: 8.0),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.barcode_reader),
            label: 'Scan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud_done_rounded),
            label: 'DataBase',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              scanBarcodeNormal();
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchScreen()),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
              break;
          }
        },
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Database'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('scanned_products')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          List<ScannedProduct> scannedProducts = [];
          snapshot.data!.docs.forEach((doc) {
            scannedProducts.add(ScannedProduct(
              productName: doc['productName'],
              productCategory: doc['productCategory'],
              productImage: doc['productImage'],
              nutritionFacts: List<String>.from(doc['nutritionFacts']),
              productClassification: doc['productClassification'],
            ));
          });

          return ListView.builder(
            itemCount: scannedProducts.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(scannedProducts[index].productName),
                subtitle: Text(
                    'Classification: ${scannedProducts[index].productClassification}'),
                leading: Image.network(
                  scannedProducts[index].productImage,
                  width: 40,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
