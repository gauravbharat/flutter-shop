import 'package:flutter/material.dart';
import 'package:max_shop/pages/orders_page.dart';
import 'package:max_shop/providers/orders.dart';
import 'package:max_shop/widgets/cart_item.dart';
import 'package:provider/provider.dart';
import 'package:max_shop/providers/cart_provider.dart' show Cart;

class CartPage extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cartContainer = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15.0),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cartContainer.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  TextButton(
                    onPressed: () {
                      // Set orders object and clear cart
                      // set listen: false, since only dispatch action and no listener here
                      Provider.of<Orders>(context, listen: false).addOrder(
                        cartContainer.items.values.toList(),
                        cartContainer.totalAmount,
                      );
                      cartContainer.clear();
                      Navigator.of(context)
                          .pushReplacementNamed(OrdersPage.routeName);
                    },
                    child: Text('ORDER NOW'),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cartContainer.items.length,
              itemBuilder: (ctx, index) {
                return CartItemWidget(
                  cartContainer.items.keys.toList()[index],
                  cartContainer.items.values.toList()[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
