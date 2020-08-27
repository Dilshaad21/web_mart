import 'package:flutter/foundation.dart';

class ProductModel {
  final String name;
  final double price;
  final double rating;
  final String description;
  final String imageUrl;
  final String sellerID;

  ProductModel(
      {@required this.name,
      @required this.price,
      @required this.rating,
      @required this.description,
      @required this.imageUrl,
      @required this.sellerID});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'rating': rating,
      'description': description,
      'imageUrl': imageUrl,
      'sellerID': sellerID,
    };
  }
}
