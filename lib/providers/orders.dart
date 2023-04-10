import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime datetime;

  OrderItem(
      {required this.id,
      required this.amount,
      required this.products,
      required this.datetime});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  void addorder(List<CartItem> cartproducts, double total) {
    _orders.insert(
        0,
        OrderItem(
            id: DateTime.now().toString(),
            amount: total,
            products: cartproducts,
            datetime: DateTime.now()));
    notifyListeners();
  }
}
