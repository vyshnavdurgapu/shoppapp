import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class CartItem {
  final id;
  final title;
  final price;
  int quantity = 1;

  CartItem(
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
  );
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items == null ? 0 : _items.length;
  }

  double get totalamount {
    var total = 0.0;
    _items.forEach((key, value) {
      total += value.quantity * value.price;
    });
    return total;
  }

  void addItem(String id, double price, String title) {
    if (_items.containsKey(id)) {
      _items.update(
          id, (ex) => CartItem(ex.id, ex.title, ex.quantity + 1, ex.price));
    } else {
      _items.putIfAbsent(
          id, () => CartItem(DateTime.now().toString(), title, 1, price));
    }
    notifyListeners();
  }

  void removeitem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void clearcart() {
    _items = {};
    notifyListeners();
  }
}
