import 'package:flutter/material.dart';
import './userAuth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import './layout.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert' show json, base64, ascii;

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  final storage = FlutterSecureStorage();

  Future<String> get jwtOrEmpty async {
    var jwt = await storage.read(key: "jwt");
    if (jwt == null) return "";
    return jwt;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder(
        future: jwtOrEmpty,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          if (snapshot.data != "") {
            var str = snapshot.data;
            var jwt = str.split(".");

            if (jwt.length != 3) {
              return UserAuth();
            } else {
              var payload = json.decode(
                  ascii.decode(base64.decode(base64.normalize(jwt[1]))));
              if (DateTime.fromMillisecondsSinceEpoch(payload["exp"] * 1000)
                  .isAfter(DateTime.now())) {
                return Layout(str, payload);
              } else {
                return UserAuth();
              }
            }
          } else {
            return UserAuth();
          }
        },
      ),
    );
  }
}
