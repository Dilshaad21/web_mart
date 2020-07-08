import 'dart:convert';

import './layout.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserAuth extends StatefulWidget {
  @override
  _UserAuthState createState() => _UserAuthState();
}

class _UserAuthState extends State<UserAuth> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  var storage = FlutterSecureStorage();

  Future<String> attemptLogIn(String email, String password) async {
    var user = {
      'email': email,
      'password': password,
    };
    var res = await http.post('http://a244dae0ac7b.ngrok.io/login',
        body: jsonEncode(user), headers: {"Content-Type": "application/json"});
    if (res.statusCode == 200)
      return res.body;
    else
      return null;
  }

  Future<int> attemptSignup(String email, String password) async {
    var user = {
      'email': email,
      'password': password,
    };
    print(user);
    var res = await http.post('http://a244dae0ac7b.ngrok.io/signup',
        body: jsonEncode(user), headers: {"Content-Type": "application/json"});
    return res.statusCode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(labelText: 'Email'),
                  style: TextStyle(fontSize: 18),
                  controller: _emailController,
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Password'),
                  style: TextStyle(fontSize: 18),
                  controller: _passwordController,
                ),
                RaisedButton(
                  child: Text('Login'),
                  onPressed: () async {
                    var jwt = await attemptLogIn(this._emailController.text,
                        this._passwordController.text);
                    if (jwt != null) {
                      storage.write(key: "jwt", value: jwt);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Layout.fromBase64(jwt)));
                    } else {
                      print("No such account exists");
                    }
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.teal)),
                ),
                RaisedButton(
                  child: Text('Signup'),
                  onPressed: () async {
                    var resStatusCode = await attemptSignup(
                        this._emailController.text,
                        this._passwordController.text);
                    if (resStatusCode == 201) {
                      print('Signup successful');
                    } else if (resStatusCode == 409) {
                      print('userName already registered');
                    } else {
                      print('some unknown error occured');
                    }
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.teal)),
                ),
              ],
            ),
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            color: Colors.white,
            margin: EdgeInsets.fromLTRB(40, 200, 40, 200),
          ),
        ),
        height: double.infinity,
        color: Colors.teal,
      ),
    );
  }
}
