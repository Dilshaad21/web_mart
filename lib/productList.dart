import 'dart:io';

import 'package:flutter/material.dart';
import './product.dart';
import './productDetails.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import './product.model.dart';

class ProductList extends StatelessWidget {
  final List<dynamic> products;
  final String userID;
  // var uId;
  var storage = FlutterSecureStorage();
  ProductList(@required this.products, @required this.userID);

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
                        sellerID: p['sellerID'],
                      ),
                    ),
                    onTap: () {
                      var show = false;
                      if (p['sellerID'] == userID) {
                        show = true;
                      }
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
                              sellerID: p['sellerID'],
                            ),
                            userID: userID,
                            p_id: p['_id'],
                            showEditButton: show,
                          ),
                        ),
                      );
                    },
                  );
                }).toList()
              ]
            : [Container()],
      ),
    );
  }
}
