import 'package:flutter/material.dart';

class AddProduct extends StatefulWidget {

  var products;
  AddProduct(this.products);

  @override
  AddProductState createState() =>
      AddProductState(products);
}

class AddProductState extends State<AddProduct> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  
  var products;

  AddProductState(@required this.products);

  onSubmit() {
    var obj = {
      'name': nameController.text,
      'price': double.parse(priceController.text) ,
      'rating': 0.00,
    };
    setState(() {
      products.add(obj);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: <Widget>[
        TextField(
          decoration: InputDecoration(
            labelText: 'Name',
          ),
          controller: nameController,
        ),
        TextField(
          decoration: InputDecoration(
            labelText: 'Price',
          ),
          controller: priceController,
          keyboardType: TextInputType.number,
        ),
        RaisedButton(
          child: Text('Submit'),
          onPressed: onSubmit,
        )
      ],
    ));
  }
}
