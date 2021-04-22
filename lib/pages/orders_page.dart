import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:max_shop/widgets/app_drawer.dart';
import 'package:max_shop/providers/orders.dart' show Orders;
import 'package:max_shop/widgets/order_item.dart';

class OrdersPage extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      // use FutureBuilder only when there is not other state changing logic which would re-execute
      //build method, rebuilding the widget, and in turn call the future again
      body: FutureBuilder(
          future:
              Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (dataSnapshot.error != null) {
                //  error handling
                return Center(child: Text('An error occurred'));
              } else {
                return Consumer<Orders>(
                  builder: (ctx, orderData, child) => ListView.builder(
                    itemCount: orderData.orders.length,
                    itemBuilder: (ctx, index) =>
                        OrderItemWidget(orderData.orders[index]),
                  ),
                );
              }
            }
          }),
    );
  }
}
