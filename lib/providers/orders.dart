import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
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
  final String authtoken;
  final String userid;

  Orders(this.authtoken, this.userid, this._orders);

  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchandset() async {
    final url = Uri.parse(
        'https://shopappflutter-26cdc-default-rtdb.firebaseio.com/orders/$userid.json?auth=$authtoken');
    final response = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderid, orderdata) {
      loadedOrders.add(OrderItem(
        id: orderid,
        amount: orderdata['amount'],
        datetime: DateTime.parse(orderdata['datetime']),
        products: (orderdata['products'] as List<dynamic>)
            .map(
                (e) => CartItem(e['id'], e['title'], e['quantity'], e['price']))
            .toList(),
      ));
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addorder(List<CartItem> cartproducts, double total) async {
    final url = Uri.parse(
        'https://shopappflutter-26cdc-default-rtdb.firebaseio.com/orders/$userid.json?auth=$authtoken');
    final timestamp = DateTime.now();
    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'datetime': timestamp.toIso8601String(),
          'products': cartproducts.map((e) {
            return {
              'id': e.id,
              'title': e.title,
              'quantity': e.quantity,
              'price': e.price
            };
          }).toList()
        }));
    _orders.insert(
        0,
        OrderItem(
            id: json.decode(response.body)['name'],
            amount: total,
            products: cartproducts,
            datetime: timestamp));
    notifyListeners();
  }
}
