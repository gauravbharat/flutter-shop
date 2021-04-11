import 'package:flutter/material.dart';
import 'package:max_shop/providers/products_provider.dart';
import 'package:max_shop/widgets/products_grid.dart';
import 'package:provider/provider.dart';

enum FilterOptions { Favourites, All }

class ProductsOverviewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsContainer =
        Provider.of<ProductsProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'MyShop',
        ),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              productsContainer.toggleShowFavouritesOnly(
                (selectedValue == FilterOptions.Favourites),
              );
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Favourites'),
                value: FilterOptions.Favourites,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.All,
              ),
            ],
          )
        ],
      ),
      body: ProductsGrid(),
    );
  }
}
