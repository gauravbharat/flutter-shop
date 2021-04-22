import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:max_shop/widgets/app_drawer.dart';
import 'package:max_shop/providers/orders.dart' show Orders;
import 'package:max_shop/widgets/order_item.dart';

class OrdersPage extends StatefulWidget {
  static const routeName = '/orders';

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _isLoading = true;

    Provider.of<Orders>(context, listen: false).fetchAndSetOrders().then(
          (_) => setState(() {
            _isLoading = false;
          }),
        );
  }

  @override
  Widget build(BuildContext context) {
    final ordersContainer = Provider.of<Orders>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text('Your Orders'),
        ),
        drawer: AppDrawer(),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: ordersContainer.orders.length,
                itemBuilder: (ctx, index) =>
                    OrderItemWidget(ordersContainer.orders[index]),
              ));
  }
}
