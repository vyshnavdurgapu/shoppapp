import 'dart:developer';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:shoppapp/models/http_exception.dart';
import 'product.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/b/bd/Redshirt.svg/2560px-Redshirt.svg.png',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/b/bd/Redshirt.svg/2560px-Redshirt.svg.png',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  final String authtoken;
  final String userid;

  Products(this.authtoken, this.userid, this._items);

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

  Future<void> addproduct(Product product) async {
    log('the function has been called');
    final url = Uri.parse(
        'https://shopappflutter-26cdc-default-rtdb.firebaseio.com/products.json?auth=$authtoken');
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageurl': product.imageUrl,
            'price': product.price,
            'creatorid': userid,
          }));
      final newprproduct = Product(
        title: product.title,
        description: product.description,
        imageUrl: product.imageUrl,
        price: product.price,
        id: json.decode(response.body)['name'],
      );
      // _items.insert(0, newprproduct);
      _items.add(newprproduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateproduct(String id, Product product) async {
    final prodindex = _items.indexWhere((element) => element.id == id);
    if (prodindex >= 0) {
      final url = Uri.parse(
          'https://shopappflutter-26cdc-default-rtdb.firebaseio.com/products/$id.json?auth=$authtoken');
      await http.patch(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageurl': product.imageUrl,
            'price': product.price,
          }));

      _items[prodindex] = product;
      notifyListeners();
    } else {}
    return Future.value();
  }

  Future<void> deleteproduct(String id) async {
    final url = Uri.parse(
        'https://shopappflutter-26cdc-default-rtdb.firebaseio.com/products/$id.json?auth=$authtoken');
    final existingproductindex =
        _items.indexWhere((element) => element.id == id);
    Product? existingproduct = _items[existingproductindex];
    _items.removeAt(existingproductindex);
    notifyListeners();
    final value = await http.delete(url);
    if (value.statusCode >= 400) {
      _items.insert(existingproductindex, existingproduct);

      notifyListeners();
      throw Httpexception('Could not delete product');
    }
    existingproduct = null;
  }

  Future<Void> fetchandsetproducts([bool filterbyuser = false]) async {
    final filterstring =
        filterbyuser ? '&orderBy="creatorid"&equalTo="$userid"' : "";
    var url = Uri.parse(
        'https://shopappflutter-26cdc-default-rtdb.firebaseio.com/products.json?auth=$authtoken$filterstring');
    try {
      final response = await http.get(url);
      final extracteddata = json.decode(response.body) as Map<String, dynamic>;
      if (extracteddata == null) {
        return Future.value();
      }
      url = Uri.parse(
          'https://shopappflutter-26cdc-default-rtdb.firebaseio.com/userFavorites/$userid.json?auth=$authtoken');
      final favouritesresponse = await http.get(url);
      print(favouritesresponse.body);
      final favouritesdata = json.decode(favouritesresponse.body);
      final List<Product> loadedproducts = [];
      extracteddata.forEach((key, value) {
        print("yo");
        loadedproducts.add(Product(
            id: key,
            title: value['title'],
            description: value['description'],
            price: value['price'],
            isFavorite:
                favouritesdata == null ? false : favouritesdata[key] ?? false,
            imageUrl: value['imageurl']));
      });
      _items = loadedproducts;
      notifyListeners();
    } catch (error) {
      print("error ra babu $error");
      throw (error);
    }
    return Future.value();
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
