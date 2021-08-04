// import Flutter Dependences
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import Utils
import 'package:shop/utils/app_routes.dart';
// import Providers
import 'package:shop/provider/cart.dart';
import 'package:shop/provider/orders.dart';
import 'package:shop/provider/products.dart';
// import Views
import 'package:shop/view/cart_screen.dart';
import 'package:shop/view/orders_screen.dart';
import 'package:shop/view/product_detail_screen.dart';
import 'package:shop/view/product_form_screen.dart';
import 'package:shop/view/products_overview_screen.dart';
import 'package:shop/view/products_sreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => new Products(),
        ),
        ChangeNotifierProvider(
          create: (_) => new Cart(),
        ),
        ChangeNotifierProvider(
          create: (_) => new Orders(),
        ),
      ],
      child: MaterialApp(
        title: 'Minha Loja',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        routes: {
          AppRoutes.HOME: (ctx) => ProductOverviewScreen(),
          AppRoutes.PRODUCT_DATAIL: (ctx) => ProductDetailScreen(),
          AppRoutes.CART: (ctx) => CartScreen(),
          AppRoutes.ORDERS: (ctx) => OrdersScreem(),
          AppRoutes.PRODUCTS: (ctx) => ProductsScreen(),
          AppRoutes.PRODUCT_FORM: (ctx) => ProductFormScreen(),
        },
      ),
    );
  }
}
