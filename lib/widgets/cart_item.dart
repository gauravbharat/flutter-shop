import 'package:flutter/material.dart';
import 'package:max_shop/providers/cart_provider.dart';
import 'package:provider/provider.dart';

class CartItemWidget extends StatelessWidget {
  final String productId;
  final CartItem cartItemInstance;
  CartItemWidget(this.productId, this.cartItemInstance);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(cartItemInstance.id),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 4.0,
        ),
      ),
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 4.0,
        ),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: FittedBox(
                  child: Text('\$${cartItemInstance.price}'),
                ),
              ),
            ),
            title: Text(cartItemInstance.title),
            subtitle: Text(
                'Total: \$${cartItemInstance.price * cartItemInstance.quantity}'),
            trailing: Text('${cartItemInstance.quantity} x'),
          ),
        ),
      ),
    );
  }
}
