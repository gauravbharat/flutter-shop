import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:max_shop/providers/orders.dart' show OrderItem;

class OrderItemWidget extends StatelessWidget {
  final OrderItem order;
  OrderItemWidget(this.order);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10.0),
      child: Column(
        children: [
          ListTile(
            title: Text('\$${order.amount}'),
            subtitle:
                Text(DateFormat('dd/MM/yyyy hh:mm').format(order.dateTime)),
            trailing: IconButton(
              icon: Icon(Icons.expand_more),
              onPressed: () {},
            ),
          )
        ],
      ),
    );
  }
}
