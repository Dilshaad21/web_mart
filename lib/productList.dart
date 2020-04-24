import 'package:flutter/material.dart';
import './product.dart';

class ProductList extends StatelessWidget {
  final List<Map<String,Object>> products;

  ProductList(@required this.products);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          ...products.map((p) {
            return Product(
              name: p['name'],
              price: p['price'],
              rating: p['rating'],
            );
          }).toList()
        ],
      ),
    );
  }
}
