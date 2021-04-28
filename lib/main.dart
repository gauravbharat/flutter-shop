import 'package:flutter/material.dart';
import 'package:max_shop/helpers/custom_page_transition.dart';
import 'package:max_shop/pages/add_edit_product_page.dart';
import 'package:max_shop/pages/auth_screen.dart';
import 'package:max_shop/pages/orders_page.dart';
import 'package:max_shop/pages/splash_screen.dart';
import 'package:max_shop/pages/user_products_page.dart';
import 'package:max_shop/providers/auth_provider.dart';
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
        ChangeNotifierProvider(create: (_) => Auth()),
        //Use proxy provider when a provider depends on another provider
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (ctx, authData, previousProducts) => Products(
            authData,
            previousProducts == null ? [] : previousProducts.items,
          ),
          create: null,
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (ctx, authData, previousOrders) => Orders(
            authData.token,
            authData.userId,
            previousOrders == null ? [] : previousOrders.orders,
          ),
          create: null,
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, authData, _) => MaterialApp(
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
            // Use page transition theme to apply animation to all routes
            pageTransitionsTheme: PageTransitionsTheme(builders: {
              TargetPlatform.android: CustomPageTransitionBuilder(),
              TargetPlatform.iOS: CustomPageTransitionBuilder(),
            }),
          ),
          home: authData.isAuth
              ? ProductsOverviewPage()
              : FutureBuilder(
                  future: authData.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            ProductsOverviewPage.routeName: (_) => ProductsOverviewPage(),
            ProductDetailPage.routeName: (_) => ProductDetailPage(),
            CartPage.routeName: (_) => CartPage(),
            OrdersPage.routeName: (_) => OrdersPage(),
            UserProductsPage.routeName: (_) => UserProductsPage(),
            AddEditProductPage.routeName: (_) => AddEditProductPage(),
          },
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
