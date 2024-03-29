import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppapp/screens/edit_product_screen.dart';
import 'package:shoppapp/widgets/app_drawer.dart';
import '../providers/products_provider.dart';
import '../widgets/user_product_item.dart';

class userproductscreen extends StatelessWidget {
  Future<void> refreshproducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchandsetproducts(true);
  }

  static const routename = 'userproductscreen';
  @override
  Widget build(BuildContext context) {
    // final productsdata = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("your Products."),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditproductScreen.routename);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: refreshproducts(context),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => refreshproducts(context),
                    child: Consumer<Products>(
                      builder: (ctx, productsdata, _) => Padding(
                        padding: EdgeInsets.all(8),
                        child: ListView.builder(
                          itemBuilder: (ctx, i) {
                            return Column(
                              children: [
                                userProductItem(
                                    productsdata.items[i].id,
                                    productsdata.items[i].title,
                                    productsdata.items[i].imageUrl),
                                Divider(),
                              ],
                            );
                          },
                          itemCount: productsdata.items.length,
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
