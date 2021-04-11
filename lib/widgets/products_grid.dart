import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:max_shop/providers/product_provider.dart';
import 'package:max_shop/providers/products_provider.dart';
import 'package:max_shop/widgets/product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavourites;
  ProductsGrid(this.showFavourites);

  @override
  Widget build(BuildContext context) {
    final productsContainer = Provider.of<ProductsProvider>(context);
    final List<ProductProvider> loadedProducts = showFavourites
        ? productsContainer.favouriteItems
        : productsContainer.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: loadedProducts.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0),
      // Alternate ChangeNotifierProvider syntax: if context is not required, and object is reused
      // use value instead of builder/create
      itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
        value: loadedProducts[index],
        child: ProductItem(),
      ),
    );
  }
}
