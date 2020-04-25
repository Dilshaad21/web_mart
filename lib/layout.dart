import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './addProduct.dart';
import './home.dart';

class Layout extends StatefulWidget {
  @override
  LayoutState createState() => LayoutState();
}

class LayoutState extends State<Layout> {
  var products;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchProducts();
  }

  _fetchProducts() async {
    var res = await http.get('http://192.168.0.8:3000/home');

    setState(() {
      products = jsonDecode(res.body);
    });
  }

  var navigator = '/home';

  _displayContents(route) {
    print(products);
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
                title: Text('Add Product'),
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
