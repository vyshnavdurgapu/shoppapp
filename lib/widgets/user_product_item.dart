// ignore_for_file: use_key_in_widget_constructors, camel_case_types, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:shoppapp/providers/products_provider.dart';
import 'package:shoppapp/screens/edit_product_screen.dart';
import 'package:provider/provider.dart';

class userProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageurl;

  userProductItem(this.id, this.title, this.imageurl);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageurl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            // Text("hello may"),
            IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditproductScreen.routename, arguments: id);
              },
              icon: Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              onPressed: () {
                Provider.of<Products>(context, listen: false).deleteproduct(id);
              },
              icon: Icon(Icons.delete),
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
