import 'package:flutter/material.dart';
import 'package:shoppapp/providers/products_provider.dart';
import './product_item.dart';
import 'package:provider/provider.dart';

class productsgrid extends StatelessWidget {
  final bool showonlyfavourites;
  productsgrid(this.showonlyfavourites);
  @override
  Widget build(BuildContext context) {
    final productsdata = Provider.of<Products>(context);
    final products =
        showonlyfavourites ? productsdata.favouriteitems : productsdata.items;
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: products[i],
        // create: (context) => products[i],
        child: ProductItem(
            // products[i].id,
            // products[i].title,
            // products[i].imageUrl,
            ),
      ),
      padding: const EdgeInsets.all(10),
      itemCount: products.length,
    );
  }
}
