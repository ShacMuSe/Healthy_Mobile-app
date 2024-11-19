import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TextStorage extends StatelessWidget {
  final TextEditingController _textController = TextEditingController();

  Future<void> _addText() async {
    try {
      await FirebaseFirestore.instance.collection('texts').add({
        'text': _textController.text,
        'timestamp': DateTime.now(),
      });
      _textController.clear();
    } catch (e) {
      print('Error adding text: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Firestore Text Storage'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                labelText: 'Enter Text',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _addText,
              child: Text('Save Text'),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('texts').orderBy('timestamp', descending: true).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Center(child: CircularProgressIndicator());
                    default:
                      if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                        return Text('No texts available');
                      }
                      return ListView(
                        children: snapshot.data!.docs.map((DocumentSnapshot document) {
                          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                          return ListTile(
                            title: Text(data['text']),
                            subtitle: Text(data['timestamp'].toString()),
                          );
                        }).toList(),
                      );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
