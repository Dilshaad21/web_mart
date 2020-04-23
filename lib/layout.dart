import 'package:flutter/material.dart';
import './productList.dart';

class Layout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WebMart'),
      ),
      body: Container(child: Column(children: <Widget>[
        Card(child: Container(height: 100),),
        ProductList(),
      ],),),
    );
  }
}
