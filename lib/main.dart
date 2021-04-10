import 'package:flutter/material.dart';
import 'package:max_shop/pages/products_overview_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
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
        cardColor: Color(0xFF99bcd3),
        highlightColor: Color(0xFFFD5F00),
        canvasColor: Color(0xffF6F6E9),
        scaffoldBackgroundColor: Color(0xffF6F6E9),
      ),
      home: ProductsOverviewPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
