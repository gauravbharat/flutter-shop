import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:max_shop/providers/product.dart';
import 'package:max_shop/providers/products_provider.dart';
import 'package:max_shop/widgets/product_item.dart';

class ProductsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<ProductProvider> loadedProducts =
        Provider.of<ProductsProvider>(context).items;

    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: loadedProducts.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0),
      itemBuilder: (ctx, index) => ChangeNotifierProvider(
        create: (_) => loadedProducts[index],
        child: ProductItem(),
      ),
    );
  }
}
