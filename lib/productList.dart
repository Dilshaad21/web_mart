import 'package:flutter/material.dart';
import './product.dart';

class ProductList extends StatelessWidget {
  final List<dynamic> products;

  ProductList(@required this.products);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: products != null
            ? [
                ...products.map((p) {
                  return Product(
                    name: p['name'],
                    price: p['price'] / 1.0,
                    rating: p['rating'] / 1.0,
                  );
                }).toList()
              ]
            : [Container()],
      ),
    );
  }
}
