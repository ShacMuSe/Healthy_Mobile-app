import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main.dart';


class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim();
      });
    });
  }

  Stream<QuerySnapshot> _getProductsStream() {
    if (_searchQuery.isEmpty) {
      return FirebaseFirestore.instance.collection('scanned_products').snapshots();
    } else {
      return FirebaseFirestore.instance
          .collection('scanned_products')
          .where('productName', isGreaterThanOrEqualTo: _searchQuery)
          .where('productName', isLessThanOrEqualTo: _searchQuery + '\uf8ff')
          .snapshots();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Products'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by product name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _getProductsStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  List<DocumentSnapshot> documents = snapshot.data!.docs;
                  if (documents.isEmpty) {
                    return Text('No products found');
                  }

                  return ListView.builder(
                    itemCount: documents.length,
                    itemBuilder: (context, index) {
                      var doc = documents[index];
                      var product = ScannedProduct(
                        productName: doc['productName'],
                        productCategory: doc['productCategory'],
                        productImage: doc['productImage'],
                        nutritionFacts: List<String>.from(doc['nutritionFacts']),
                        productClassification: doc['productClassification'],
                      );
                      return ListTile(
                        title: Text(product.productName),
                        subtitle: Text('Classification: ${product.productClassification}'),
                        leading: product.productImage.isNotEmpty
                            ? Image.network(
                                product.productImage,
                                width: 50,
                                height: 60,
                                fit: BoxFit.cover,
                              )
                            : Icon(Icons.image_not_supported),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailScreen(product),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductDetailScreen extends StatelessWidget {
  final ScannedProduct product;

  ProductDetailScreen(this.product);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.productName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            product.productImage.isNotEmpty
                ? Center(
                  child: Image.network(
                    product.productImage,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                )
                : SizedBox.shrink(),
            SizedBox(height: 16.0),
            Text(
              'Category: ${product.productCategory}',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            Text(
              'Nutrition Facts:',
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(height: 8.0),
            Expanded(
              child: ListView.builder(
                itemCount: product.nutritionFacts.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      product.nutritionFacts[index],
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Classification: ${product.productClassification}',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
