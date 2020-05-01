import 'package:flutter/material.dart';
import './product.dart';
import './productDetails.dart';

import './product.model.dart';

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
                  return InkWell(
                    child: Product(
                      product: ProductModel(
                        name: p['name'],
                        price: p['price'] / 1.0,
                        rating: p['rating'] / 1.0,
                        description: p['description'],
                        imageUrl: p['imageUrl'],
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProductDetails(
                                    product: ProductModel(
                                      name: p['name'],
                                      price: p['price'] / 1.0,
                                      rating: p['rating'] / 1.0,
                                      description: p['description'],
                                      imageUrl: p['imageUrl'],
                                    ),
                                    p_id: p['_id'],
                                  )));
                    },
                  );
                }).toList()
              ]
            : [Container()],
      ),
    );
  }
}
