import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop/models/product.dart';
import 'package:shop/provider/products.dart';
import 'package:shop/widgets/product_item.dart';

class ProductGrid extends StatelessWidget {
  ProductGrid(this.showFavoriteOnly);

  final bool showFavoriteOnly;

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<Products>(context);

    final products = showFavoriteOnly
        ? productProvider.favoriteItems
        : productProvider.items;

    return products.isEmpty
        ? Center(
          child: Column(
            children: [
              Image.network('https://static.thenounproject.com/png/632851-200.png'),
              Text(
                  'Não possui nenhum item favorito',
                  style: TextStyle(fontSize: 20),
                ),
            ],
          ),
        )
        : GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
              value: products[index],
              child: ProductItem(),
            ),
            itemCount: products.length,
          );
  }
}
