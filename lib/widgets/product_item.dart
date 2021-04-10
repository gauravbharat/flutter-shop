import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  ProductItem({
    @required this.id,
    @required this.title,
    @required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    // Use ClipRRect to add rounded corner on widgets which does not have border radius property
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: GridTile(
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
        ),
        footer: GridTileBar(
          // backgroundColor: Colors.black54,
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.87),
          leading: IconButton(
            icon: Icon(Icons.favorite),
            color: Theme.of(context).accentColor,
            onPressed: () {},
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            color: Theme.of(context).accentColor,
            onPressed: () {},
          ),
          title: Text(
            title,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
