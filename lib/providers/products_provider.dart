import 'package:flutter/material.dart';
import 'product.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';

class Products with ChangeNotifier {
  final List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/b/bd/Redshirt.svg/2560px-Redshirt.svg.png',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/b/bd/Redshirt.svg/2560px-Redshirt.svg.png',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];
  var showfavouritesonly = false;
  List<Product> get items {
    // if (showfavouritesonly) {
    //   return _items.where((element) => element.isFavorite).toList();
    // } else
    return [..._items];
  }

  List<Product> get favouriteitems {
    return _items.where((element) => element.isFavorite).toList();
  }

  Product findbyid(String id) {
    return items.firstWhere((prod) => prod.id == id);
  }

  void addproduct(Product product) {
    final url = Uri.parse(
        'https://shopappflutter-26cdc-default-rtdb.firebaseio.com/products.json');
    http.post(url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageurl': product.imageUrl,
          'price': product.price,
          'isfavourite': product.isFavorite
        }));
    final newprproduct = Product(
      title: product.title,
      description: product.description,
      imageUrl: product.imageUrl,
      price: product.price,
      id: DateTime.now().toString(),
    );
    // _items.insert(0, newprproduct);
    _items.add(newprproduct);
    notifyListeners();
  }

  void updateproduct(String id, Product product) {
    final prodindex = _items.indexWhere((element) => element.id == id);
    _items[prodindex] = product;
    notifyListeners();
  }

  void deleteproduct(String id) {
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  // void showfavoritesonly() {
  //   showfavouritesonly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   showfavouritesonly = false;
  //   notifyListeners();
  // }
}
