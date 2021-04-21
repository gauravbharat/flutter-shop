import 'package:flutter/material.dart';
import 'package:max_shop/providers/products_provider.dart';
import 'package:provider/provider.dart';

import 'package:max_shop/widgets/app_drawer.dart';
import 'package:max_shop/pages/cart_page.dart';
import 'package:max_shop/providers/cart_provider.dart';
import 'package:max_shop/widgets/badge.dart';
import 'package:max_shop/widgets/products_grid.dart';

enum FilterOptions { Favourites, All }

class ProductsOverviewPage extends StatefulWidget {
  @override
  _ProductsOverviewPageState createState() => _ProductsOverviewPageState();
}

class _ProductsOverviewPageState extends State<ProductsOverviewPage> {
  bool _showOnlyFavourites = false;
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'MyShop',
        ),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                _showOnlyFavourites =
                    (selectedValue == FilterOptions.Favourites);
              });
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
          ),
          Consumer<Cart>(
            builder: (ctx, cart, child) => Badge(
              child: child,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartPage.routeName);
              },
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(_showOnlyFavourites),
    );
  }
}
