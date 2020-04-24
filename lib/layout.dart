import 'package:flutter/material.dart';

import './addProduct.dart';
import './home.dart';

class Layout extends StatefulWidget {
  @override
  LayoutState createState() => LayoutState();
}

class LayoutState extends State<Layout> {
  final products = [
    {'name': 'Laptop', 'price': 23.99, 'rating': 4.0},
    {'name': 'Smart Phone', 'price': 239.99, 'rating': 5.0},
    {'name': 'Dualshock 4', 'price': 59.99, 'rating': 5.0},
  ];

  var navigator = '/home';

  _displayContents(route) {
    switch (route) {
      case '/home':
        return Home(products);
      case '/add-product':
        return AddProduct(products);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WebMart'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('User'),
              decoration: BoxDecoration(color: Colors.blue),
            ),
            ListTile(
                title: Text('Home'),
                onTap: () {
                  setState(() {
                    navigator = '/home';
                  });
                  Navigator.pop(context);
                }),
            ListTile(
                title: Text('Add-Product'),
                onTap: () {
                  setState(() {
                    navigator = '/add-product';
                  });
                  Navigator.pop(context);
                }),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: _displayContents(navigator),
          margin: EdgeInsets.symmetric(vertical: 6, horizontal: 0),
        ),
      ),
    );
  }
}
