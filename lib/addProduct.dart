import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class AddProduct extends StatefulWidget {

  var products;

  AddProduct(this.products);

  @override
  _AddProductState createState() => _AddProductState(products);
}

class _AddProductState extends State<AddProduct> {
  
  var products;
  _AddProductState(this.products);
  
  final nameController = TextEditingController();
  final priceController = TextEditingController();

  onSubmit() async {
    var obj = {
      'name': nameController.text,
      'price': double.parse(priceController.text),
      'rating': 0.00,
    };

    var object = jsonEncode(obj);
    var res = await http.post('http://192.168.0.8:3000/add-product',
        headers: {"Content-Type": "application/json"}, body: object);
    products.add(obj);
    print(res.statusCode);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Container(
            child: RaisedButton(
              child: Text('Submit',
                  style: TextStyle(fontSize: 20, color: Colors.white)),
              onPressed: onSubmit,
              color: Colors.green,
            ),
            margin: EdgeInsets.symmetric(vertical: 15, horizontal: 0),
          ),
        ],
      ),
      padding: EdgeInsets.all(5),
    );
  }
}