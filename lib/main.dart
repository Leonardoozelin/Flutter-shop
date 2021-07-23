import 'package:flutter/material.dart';
import 'package:shop/provider/products.dart';
import 'package:shop/utils/app_routes.dart';
import 'package:shop/view/product_detail_screen.dart';
import 'package:shop/view/products_overview_screen.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => new Products(),
      child: MaterialApp(
        title: 'Minha Loja',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        home: ProductOverviewScreen(),
        routes: {
          AppRoutes.PRODUCT_DATAIL: (ctx) => ProductDetailScreen(),
        },
      ),
    );
  }
}
