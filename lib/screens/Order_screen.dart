import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppapp/widgets/app_drawer.dart';
import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';

class OrderScreen extends StatelessWidget {
  static final routename = '/orderscreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(
          title: Text('your Orders.'),
        ),
        body: FutureBuilder(
          future: Provider.of<Orders>(context, listen: false).fetchandset(),
          builder: (context, datasnapshot) {
            if (datasnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (datasnapshot.error != null) {
              return Center(
                child: Text('error occured!'),
              );
            } else {
              return Consumer<Orders>(
                builder: (ctx, ordersdata, child) {
                  return ListView.builder(
                    itemBuilder: (context, i) {
                      return OrderItem(ordersdata.orders[i]);
                    },
                    itemCount: ordersdata.orders.length,
                  );
                },
              );
            }
          },
        ));
  }
}
