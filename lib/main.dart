import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import './layout.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Layout());
  }
}
