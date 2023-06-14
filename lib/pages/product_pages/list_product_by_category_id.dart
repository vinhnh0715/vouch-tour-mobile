import 'package:flutter/material.dart';

class ListProductByCategoryId extends StatelessWidget {
  final String categoryId;

  const ListProductByCategoryId({required this.categoryId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Category Details'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate back and send a result
            Navigator.pop(context, true);
          },
        ),
      ),
      body: Center(
        child: Text('Category ID: $categoryId'),
      ),
    );
  }
}
