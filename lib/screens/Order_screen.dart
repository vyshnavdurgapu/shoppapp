import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppapp/widgets/app_drawer.dart';
import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';

class OrderScreen extends StatelessWidget {
  static final routename = '/orderscreen';
  @override
  Widget build(BuildContext context) {
    final ordersdata = Provider.of<Orders>(context);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('your Orders.'),
      ),
      body: ListView.builder(
        itemBuilder: (context, i) {
          return OrderItem(ordersdata.orders[i]);
        },
        itemCount: ordersdata.orders.length,
      ),
    );
  }
}
