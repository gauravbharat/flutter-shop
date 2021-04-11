import 'package:flutter/material.dart';
import 'package:max_shop/providers/cart_provider.dart';

class CartItemWidget extends StatelessWidget {
  final cartItemInstance;
  CartItemWidget(this.cartItemInstance);

  @override
  Widget build(BuildContext context) {
    return Card(
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
    );
  }
}
