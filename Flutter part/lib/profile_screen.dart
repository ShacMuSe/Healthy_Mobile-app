import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('scanned_products').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          List<Widget> productsList = [];
          snapshot.data!.docs.forEach((doc) {
            productsList.add(ListTile(
              title: Text(doc['productName']),
              subtitle: Text('Classification: ${doc['productClassification']}'),
              leading: Image.network(
                doc['productImage'],
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ));
          });

          return ListView(
            children: productsList,
          );
        },
      ),
    );
  }
}
