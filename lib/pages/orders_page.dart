import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:max_shop/widgets/app_drawer.dart';
import 'package:max_shop/providers/orders.dart' show Orders;
import 'package:max_shop/widgets/order_item.dart';

class OrdersPage extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    final ordersContainer = Provider.of<Orders>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text('Your Orders'),
        ),
        drawer: AppDrawer(),
        body: ListView.builder(
          itemCount: ordersContainer.orders.length,
          itemBuilder: (ctx, index) =>
              OrderItemWidget(ordersContainer.orders[index]),
        ));
  }
}
