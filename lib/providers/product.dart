import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product extends ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product(
      {required this.id,
      required this.title,
      required this.description,
      required this.price,
      required this.imageUrl,
      this.isFavorite = false});

  void _setfavvalue(bool value) {
    isFavorite = value;
    notifyListeners();
  }

  Future<void> togglefavoritestatus() async {
    final oldstatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url = Uri.parse(
        'https://shopappflutter-26cdc-default-rtdb.firebaseio.com/products/$id');
    try {
      final response =
          await http.patch(url, body: json.encode({'isfavourite': isFavorite}));
      if (response.statusCode >= 400) {
        _setfavvalue(oldstatus);
      }
    } catch (error) {
      _setfavvalue(oldstatus);
    }
  }
}
