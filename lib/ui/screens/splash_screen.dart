import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pinkAccent,
      body: Center(
          child: Image.asset(
        "assets/images/logo.png",
        width: 150.0,
        height: 150.0,
      )),
    );
  }
}
