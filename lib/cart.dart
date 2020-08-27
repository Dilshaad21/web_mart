import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Cart extends StatefulWidget {
  final userId;

  Cart(this.userId);

  @override
  _CartState createState() => _CartState(this.userId);
}

class _CartState extends State<Cart> {
  var orders;
  final userId;
  var totalPrice;
  _CartState(this.userId);

  populateOrders() async {
    var objs =
        await http.get('http://03bdacf8f875.ngrok.io/product/order' + userId);

    setState(() {
      orders = jsonDecode(objs.body);
    });
  }

  performCheckout() async {
    var response = await http
        .get('http://03bdacf8f875.ngrok.io/product/order/checkout' + userId);
    print(response.body);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    populateOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: <Widget>[
        Text('Cart'),
        ListView(
          children: <Widget>[
            ...orders.map((order) {
              setState(() {
                totalPrice = totalPrice + order['price'];
              });
              return Card(
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Image.network(order.imageUrl,
                          fit: BoxFit.cover, width: 150),
                      Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: Text(
                                '\$${order["price"]}',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.purple),
                              ),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.purple, width: 3)),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 10),
                            ),
                            Text(
                              order['p_name'],
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
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
            }),
            Text(totalPrice),
            RaisedButton(
              child: Text(
                'Checkout',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              color: Colors.teal,
              padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
              onPressed: performCheckout,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: Colors.white)),
            ),
          ],
        )
      ],
    ));
  }
}
