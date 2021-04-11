import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:max_shop/providers/product.dart';
import 'package:max_shop/pages/product_detail_page.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentProductItem = Provider.of<ProductProvider>(context);

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
          leading: IconButton(
            icon: Icon(currentProductItem.isFavourite
                ? Icons.favorite
                : Icons.favorite_outline),
            color: Theme.of(context).accentColor,
            onPressed:
                Provider.of<ProductProvider>(context).toggleFavouriteStatus,
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            color: Theme.of(context).accentColor,
            onPressed: () {},
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
