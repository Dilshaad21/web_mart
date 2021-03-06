import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import './product.model.dart';

class Product extends StatelessWidget {
  final ProductModel product;
  
  Product({this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        child: Row( 
          children: <Widget>[
            Image.network(product.imageUrl,fit: BoxFit.cover,width:150),
            Container(
              child: Column(
                children: <Widget>[
                  Container(
                    child: Text(
                      '\$${product.price}',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple),
                    ),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.purple, width: 3)),
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  ),
                  Text(
                    product.name,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  RatingBarIndicator(
                      rating: product.rating,
                      itemBuilder: (context, index) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                      itemCount: 5,
                      itemSize: 30.0,
                      direction: Axis.horizontal)
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
              width: 200,
            )
          ],
          mainAxisAlignment: MainAxisAlignment.spaceAround,
        ),
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 20),
      ),
      elevation: 8,
      margin: EdgeInsets.fromLTRB(18, 5, 18, 5),
    );
  }
}
