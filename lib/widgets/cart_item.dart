// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import '../providers/cart.dart';
import 'package:provider/provider.dart';

class Cart_Item extends StatelessWidget {
  final String id;
  final productid;
  final double price;
  final int quantity;
  final String title;

  Cart_Item(this.id, this.productid, this.price, this.quantity, this.title);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      ),
      onDismissed: (directions) {
        Provider.of<Cart>(context, listen: false).removeitem(productid);
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                  padding: EdgeInsets.all(5),
                  child: FittedBox(child: Text('\$${price}'))),
            ),
            title: Text(title),
            subtitle: Text('Total: \$${(price * quantity)}'),
            trailing: Text(quantity.toString() + "X"),
          ),
        ),
      ),
    );
  }
}
