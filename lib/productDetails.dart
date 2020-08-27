import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import './product.model.dart';
import './layout.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProductDetails extends StatefulWidget {
  final ProductModel product;
  final String p_id;
  final String userID;
  final showEditButton;
  ProductDetails({this.product, this.p_id, this.userID, this.showEditButton});

  @override
  _ProductDetailsState createState() => _ProductDetailsState(
      product: product,
      p_id: p_id,
      userID: userID,
      showEditButton: showEditButton);
}

class _ProductDetailsState extends State<ProductDetails> {
  ProductModel product;
  final String p_id;
  ProductModel newProduct;
  final String userID;
  final showEditButton;
  var storage = FlutterSecureStorage();

  _ProductDetailsState({
    @required this.product,
    @required this.p_id,
    @required this.userID,
    @required this.showEditButton,
  });

  Future<String> get fetchUserId async {
    var val = await storage.read(key: "userId");
    return val;
  }

  editProduct(context) async {
    setState(() {
      newProduct = ProductModel(
        name: nameController.text,
        description: descriptionController.text,
        imageUrl: product.imageUrl,
        price: product.price,
        rating: product.rating,
        sellerID: product.sellerID,
      );
    });
    var response = await http.put(
        'http://5b83b22353ab.ngrok.io/product/edit-product/' + p_id,
        body: jsonEncode(newProduct.toMap()),
        headers: {"Content-Type": "application/json"});
    print(response.body);
    var jwt = await storage.read(key: "jwt");
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MaterialApp(
            home: Layout.fromBase64(jwt),
          ),
        ));
  }

  var nameController = TextEditingController();
  var descriptionController = TextEditingController();
  // var priceController = TextEditingController(text: product.price.toString());

  openEditModal(BuildContext context, ProductModel product) {
    Dialog simpleDialog = Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        height: 300.0,
        width: 300.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(15.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
                style: TextStyle(fontSize: 20),
                controller: nameController,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
                style: TextStyle(fontSize: 20),
                controller: descriptionController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  RaisedButton(
                    color: Colors.blue,
                    onPressed: () => editProduct(context),
                    child: Text(
                      'Edit',
                      style: TextStyle(fontSize: 18.0, color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  RaisedButton(
                    color: Colors.red,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(fontSize: 18.0, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    showDialog(
        context: context, builder: (BuildContext context) => simpleDialog);
  }

  addToCart() async {
    var obj = {
      'p_id': p_id,
      'p_name': product.name,
      'p_price': product.price,
      'status': 'standby',
      'buyerId': userID,
    };

    var response = await http.post(
      'http://5b83b22353ab.ngrok.io/product/order',
      body: jsonEncode(obj),
      headers: {"Content-Type": "application/json"},
    );
    
    print(response);
    var jwt = await storage.read(key: "jwt");
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MaterialApp(
            home: Layout.fromBase64(jwt),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
        actions: <Widget>[
          showEditButton
              ? RaisedButton(
                  onPressed: () => openEditModal(context, product),
                  child: Text(
                    'EDIT',
                    style: TextStyle(
                        color: Colors.white, fontSize: 18, letterSpacing: 2),
                  ),
                  color: Colors.blue,
                )
              : Container(),
          RaisedButton(
            onPressed: addToCart,
            child: Text(
              'ADD TO CART',
              style: TextStyle(
                  color: Colors.white, fontSize: 18, letterSpacing: 2),
            ),
            color: Colors.blue,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                child: Row(
                  children: <Widget>[
                    Text(
                      product.name,
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    RatingBarIndicator(
                        rating: product.rating,
                        itemBuilder: (context, index) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                        itemCount: 5,
                        itemSize: 20.0,
                        direction: Axis.horizontal),
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
                padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                margin: EdgeInsets.fromLTRB(8, 0, 0, 8),
              ),
              Container(
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.contain,
                ),
                margin: EdgeInsets.fromLTRB(10, 0, 10, 5),
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    Text(
                      '\$${product.price}',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple),
                    ),
                    Text(
                      product.description,
                      style: TextStyle(
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                ),
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                height: 130,
              )
            ],
          ),
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 20),
        ),
      ),
    );
  }
}
