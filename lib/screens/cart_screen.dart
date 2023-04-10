// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_key_in_widget_constructors, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppapp/providers/orders.dart';
import '../providers/cart.dart' show Cart;
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static final routename = '/cart_screen';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("your Cart."),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$' + cart.totalamount.toStringAsFixed(2),
                      style: TextStyle(
                          color: Theme.of(context)
                              .primaryTextTheme
                              .headline1
                              ?.color),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  FlatButton(
                    onPressed: () {
                      Provider.of<Orders>(context, listen: false).addorder(
                          cart.items.values.toList(), cart.totalamount);
                      cart.clearcart();
                    },
                    child: Text('ORDER NOW!'),
                    textColor: Theme.of(context).primaryColor,
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.itemCount,
              itemBuilder: (ctx, i) {
                return Cart_Item(
                    cart.items.values.toList()[i].id,
                    cart.items.keys.toList()[i],
                    cart.items.values.toList()[i].price,
                    cart.items.values.toList()[i].quantity,
                    cart.items.values.toList()[i].title);
              },
            ),
          )
        ],
      ),
    );
  }
}
