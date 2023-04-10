import 'package:flutter/material.dart';
import 'product.dart';

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

  addproduct() {
    // _items.add(value);
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
