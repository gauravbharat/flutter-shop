import 'package:flutter/material.dart';
import 'package:max_shop/providers/cart_provider.dart';
import 'package:provider/provider.dart';

import 'package:max_shop/providers/product_provider.dart';
import 'package:max_shop/pages/product_detail_page.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Product is needed on init load only, so set listen: false. Use Consumer down below for fav toggle
    final currentProductItem = Provider.of<Product>(context, listen: false);

    // Not interested in listening to cart here, so don't subscribe to Cart changes
    final cart = Provider.of<Cart>(context, listen: false);

    // Use ClipRRect to add rounded corner on widgets which does not have border radius property
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailPage.routeName,
              arguments: currentProductItem.id,
            );
          },
          child: Image.network(
            currentProductItem.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          // backgroundColor: Colors.black54,
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.87),
          // Use Consumer instead of Provider to listen to data changes and
          // rebuild only select parts on the widget
          leading: Consumer<Product>(
            // any widget passed to child won't be rebuilt inside Consumer
            builder: (ctx, product, child) => IconButton(
              icon: Icon(product.isFavourite
                  ? Icons.favorite
                  : Icons.favorite_outline),
              color: Theme.of(context).accentColor,
              onPressed: Provider.of<Product>(context).toggleFavouriteStatus,
            ),
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            color: Theme.of(context).accentColor,
            onPressed: () {
              cart.addItem(
                currentProductItem.id,
                currentProductItem.price,
                currentProductItem.title,
              );

              // reaches out to nearest Scaffold in the widget tree, the product overview page in this case
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Added item to cart!',
                  ),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      cart.removeCartItem(currentProductItem.id);
                    },
                  ),
                  // backgroundColor: Colors.lightGreen.withOpacity(0.44),
                ),
              );
            },
          ),
          title: Text(
            currentProductItem.title,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
