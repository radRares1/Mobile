import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthScreen extends StatefulWidget {
  AuthScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  @override
  Widget build(BuildContext context) {
    TextEditingController ctr = TextEditingController();
    var emailField = CupertinoTextField(
      obscureText: false,
      controller: ctr,
    );
    final loginButon = Material(
      borderRadius: BorderRadius.circular(10.0),
      color: Colors.grey,
      child: CupertinoButton(
        onPressed: () {
          addStringToSF(ctr.text);
        },
        child: Text("Input Level",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 45.0),
                emailField,
                SizedBox(height: 25.0),
                SizedBox(
                  height: 35.0,
                ),
                loginButon,
                SizedBox(
                  height: 15.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  addStringToSF(String name) async {
    print("RECV NAME: " + name);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('name', name);
  }
}
