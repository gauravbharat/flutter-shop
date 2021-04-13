import 'package:flutter/material.dart';
import 'package:max_shop/pages/orders_page.dart';
import 'package:provider/provider.dart';

import 'package:max_shop/providers/cart_provider.dart' show Cart;
import 'package:max_shop/providers/orders.dart' show Orders;
import 'package:max_shop/providers/products_provider.dart' show Products;

import 'package:max_shop/pages/cart_page.dart';
import 'package:max_shop/pages/product_detail_page.dart';
import 'package:max_shop/pages/products_overview_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Created a group of app level providers
    return MultiProvider(
      providers: [
        // When creating a new class instance i.e. providing a brand new object, use a create CNP pattern
        ChangeNotifierProvider(
          create: (_) => Products(),
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (_) => Orders(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          fontFamily: 'Lato',
          primarySwatch: MaterialColor(
            0xFF005792,
            <int, Color>{
              50: Color.fromRGBO(0, 70, 146, .1),
              100: Color.fromRGBO(0, 70, 146, .2),
              200: Color.fromRGBO(0, 70, 146, .3),
              300: Color.fromRGBO(0, 70, 146, .4),
              400: Color.fromRGBO(0, 70, 146, .5),
              500: Color.fromRGBO(0, 70, 146, .6),
              600: Color.fromRGBO(0, 70, 146, .7),
              700: Color.fromRGBO(0, 70, 146, .8),
              800: Color.fromRGBO(0, 70, 146, .9),
              900: Color.fromRGBO(0, 70, 146, 1),
            },
          ),
          accentColor: Color(0xFFFD5F00),
          cardColor: Color(0xffF6F6E9),
          highlightColor: Color(0xFFFD5F00),
          canvasColor: Color(0xffF6F6E9),
          scaffoldBackgroundColor: Color(0xffF6F6E9),
        ),
        routes: {
          '/': (_) => ProductsOverviewPage(),
          ProductDetailPage.routeName: (_) => ProductDetailPage(),
          CartPage.routeName: (_) => CartPage(),
          OrdersPage.routeName: (_) => OrdersPage(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
