import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:max_shop/providers/products_provider.dart';
import 'package:max_shop/providers/product_provider.dart';

class ProductDetailPage extends StatelessWidget {
  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    // We wish to load the product detail only once when this page is initialized, and don't wish the
    // build method to be called each time the ProductsProvider is updated. Pass a listen: false as
    // the second argument to the Provider.of() method
    final ProductProvider currentProduct = Provider.of<ProductsProvider>(
      context,
      listen: false,
    ).findById(productId);

    return Scaffold(
      appBar: AppBar(
        title: Text(currentProduct.title),
      ),
    );
  }
}
