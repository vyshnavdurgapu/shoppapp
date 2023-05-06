// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:shoppapp/providers/cart.dart';
import 'package:shoppapp/providers/orders.dart';
import 'package:shoppapp/screens/Order_screen.dart';
import 'package:shoppapp/screens/cart_screen.dart';
import 'package:shoppapp/screens/edit_product_screen.dart';
import 'package:shoppapp/screens/product_detail_screen.dart';
import './screens/products_overvieew_screen.dart';
import './providers/products_provider.dart';
import 'package:provider/provider.dart';
import './screens/user_products_screen.dart';
import './screens/auth_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Products(),
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (_) => Orders(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            primarySwatch: Colors.cyan,
            accentColor: Colors.redAccent,
            fontFamily: 'Lato'),
        home: AuthScreen(),
        routes: {
          productDetailScreen.routename: (ctx) => productDetailScreen(),
          CartScreen.routename: (ctx) => CartScreen(),
          OrderScreen.routename: (ctx) => OrderScreen(),
          userproductscreen.routename: (ctx) => userproductscreen(),
          EditproductScreen.routename: (ctx) => EditproductScreen(),
          AuthScreen.routeName: (ctx) => AuthScreen(),
        },
      ),
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key, required this.title}) : super(key: key);
//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;

//   void _incrementCounter() {
//     setState(() {
//       _counter++;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headline4,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }
