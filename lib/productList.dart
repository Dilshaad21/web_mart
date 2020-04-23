import 'package:flutter/material.dart';
import './product.dart';

class ProductList extends StatelessWidget {
  static const products = [
    {'name': 'Laptop', 'price': 23.99, 'rating': 4.0},
    {'name': 'Smart Phone', 'price': 239.99, 'rating': 5.0},
    {'name': 'Dualshock 4', 'price': 59.99, 'rating': 5.0},
  ];

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
