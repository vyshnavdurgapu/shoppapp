// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shoppapp/providers/products_provider.dart';
import 'package:shoppapp/screens/cart_screen.dart';
import 'package:shoppapp/widgets/app_drawer.dart';
import '../widgets/productsgrid.dart';
import 'package:provider/provider.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';

enum FilterOptions { Favourites, ALL }

class ProductsOverviewScreen extends StatefulWidget {
  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var showonlyfavourites = false;
  var isinit = true;
  var isloading = false;

  @override
  void initState() {
    // Provider.of<Products>(context).fetchandsetproducts(); wont work
    // Future.delayed(Duration.zero).then((value) {
    //   Provider.of<Products>(context).fetchandsetproducts();
    // }); this can work its like a hack but its not uh that meh
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (isinit) {
      setState(() {
        isloading = true;
      });
      Provider.of<Products>(context).fetchandsetproducts().then((_) {
        setState(() {
          log('done');
          isloading = false;
        });
      }).catchError((error) {
        setState(() {
          log('done');
          isloading = false;
        });
      });
    }
    isinit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<Cart>(context);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: const Text('Ammuku poo!'),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions selectedvalue) {
              setState(() {
                if (selectedvalue == FilterOptions.Favourites) {
                  showonlyfavourites = true;
                } else {
                  showonlyfavourites = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Favourites'),
                value: FilterOptions.Favourites,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.ALL,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: Container(child: ch),
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routename);
              },
            ),
          )
        ],
      ),
      body: isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : productsgrid(showonlyfavourites),
    );
  }
}
