import 'package:flutter/material.dart';

class ProductDetailPage extends StatelessWidget {
  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    // ... get all pdocut data for the id

    return Scaffold(
      appBar: AppBar(
        title: Text('title'),
      ),
    );
  }
}
