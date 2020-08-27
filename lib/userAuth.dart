import 'dart:convert';

import 'package:google_fonts/google_fonts.dart';

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
    var res = await http.post('http://5b83b22353ab.ngrok.io/user/login',
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
    var res = await http.post('http://5b83b22353ab.ngrok.io/user/signup',
        body: jsonEncode(user), headers: {"Content-Type": "application/json"});
    return res.statusCode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                child: Text(
                  'WebMart',
                  style: GoogleFonts.kronaOne(
                    fontSize: 50,
                    color: Colors.white,
                  ),
                ),
                margin: EdgeInsets.fromLTRB(0, 60, 0, 0),
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    TextField(
                      decoration: InputDecoration(labelText: 'Email'),
                      style: TextStyle(fontSize: 20),
                      controller: _emailController,
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: 'Password'),
                      style: TextStyle(fontSize: 20),
                      controller: _passwordController,
                      obscureText: true,
                    ),
                    Container(
                      height: 30,
                    ),
                    Row(
                      children: <Widget>[
                        RaisedButton(
                          child: Text(
                            'Login',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          color: Colors.teal,
                          padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                          onPressed: () async {
                            var jwt = await attemptLogIn(
                                this._emailController.text,
                                this._passwordController.text);
                            if (jwt != null) {
                              storage.write(key: "jwt", value: jwt);
                              storage.write(key:"userId",value: this._emailController.text);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Layout.fromBase64(jwt)));
                            } else {
                              print("No such account exists");
                            }
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(color: Colors.white)),
                        ),
                        RaisedButton(
                          child: Text(
                            'Signup',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          color: Colors.teal,
                          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
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
                              borderRadius: BorderRadius.circular(20.0),
                              side: BorderSide(color: Colors.teal)),
                        ),
                      ],
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                    )
                  ],
                ),
                padding: EdgeInsets.fromLTRB(20, 50, 20, 50),
                margin: EdgeInsets.fromLTRB(40, 80, 40, 80),
                decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(25.0))),
              ),
            ],
          ),
        ),
        height: double.infinity,
        color: Colors.teal,
      ),
    );
  }
}
