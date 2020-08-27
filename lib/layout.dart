import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './addProduct.dart';
import './home.dart';
import './cart.dart';
import './userAuth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert' show json, base64, ascii;

class Layout extends StatefulWidget {
  Layout(this.jwt, this.payload);

  factory Layout.fromBase64(String jwt) => Layout(
      jwt,
      json.decode(
          ascii.decode(base64.decode(base64.normalize(jwt.split(".")[1])))));

  final String jwt;
  final Map<String, dynamic> payload;

  @override
  LayoutState createState() => LayoutState(this.jwt, this.payload);
}

class LayoutState extends State<Layout> {
  var products;
  final String jwt;
  final payload;
  final storage = FlutterSecureStorage();

  LayoutState(this.jwt, this.payload);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchProducts();
  }

  _fetchProducts() async {
    var res = await http.get('http://5b83b22353ab.ngrok.io/home');

    setState(() {
      products = jsonDecode(res.body);
    });
  }

  var navigator = '/home';

  _displayContents(route) {
    print(products);
    
    var userId = payload['email'];
    switch (route) {
      case '/home':
        return Home(products, userId);
      case '/add-product':
        return AddProduct(products, userId);
      case '/cart':
        return Cart(userId);
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
                child: Text(payload['email']),
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
              ListTile(
                  title: Text('Cart'),
                  onTap: () {
                    setState(() {
                      navigator = '/cart';
                    });
                    Navigator.pop(context);
                  }),
              ListTile(
                  title: Text('Logout'),
                  onTap: () async {
                    await storage.deleteAll();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MaterialApp(
                            home: UserAuth(),
                          ),
                        ));
                  }),
            ],
          ),
        ),
        body: Container(
          child: SingleChildScrollView(
            child: Container(
              child: _displayContents(navigator),
              margin: EdgeInsets.symmetric(vertical: 6, horizontal: 0),
            ),
          ),
          height: MediaQuery.of(context).size.height,
        ));
  }
}
