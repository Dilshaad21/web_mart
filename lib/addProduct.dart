import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import './product.model.dart';
import './layout.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AddProduct extends StatefulWidget {
  var products;

  AddProduct(this.products);

  @override
  _AddProductState createState() => _AddProductState(products);
}

class _AddProductState extends State<AddProduct> {
  var products;
  _AddProductState(this.products);
  var storage = FlutterSecureStorage();
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final descpController = TextEditingController();
  final imageController = TextEditingController();

  onSubmit(context) async {
    var product = ProductModel(
        name: nameController.text,
        price: double.parse(priceController.text),
        rating: 0.00,
        imageUrl: imageController.text,
        description: descpController.text);

    var object = jsonEncode(product.toMap());
    var res = await http.post('http://0110ac49221d.ngrok.io/add-product',
        headers: {"Content-Type": "application/json"}, body: object);
    products.add(product.toMap());
    print(res);
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
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Text(
              'Add Product',
              style: TextStyle(fontSize: 34),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Name',
              ),
              style: TextStyle(fontSize: 20),
              controller: nameController,
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Price',
              ),
              controller: priceController,
              style: TextStyle(fontSize: 20),
              keyboardType: TextInputType.number,
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Description',
              ),
              style: TextStyle(fontSize: 20),
              controller: descpController,
              minLines: 5,
              maxLines: 5,
              keyboardType: TextInputType.multiline,
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Image Url',
              ),
              style: TextStyle(fontSize: 20),
              controller: imageController,
            ),
            Container(
              child: RaisedButton(
                child: Text('Submit',
                    style: TextStyle(fontSize: 20, color: Colors.white)),
                onPressed: () => onSubmit(context),
                color: Colors.green,
              ),
              margin: EdgeInsets.symmetric(vertical: 15, horizontal: 0),
            ),
          ],
        ),
      ),
      padding: EdgeInsets.all(5),
    );
  }
}
