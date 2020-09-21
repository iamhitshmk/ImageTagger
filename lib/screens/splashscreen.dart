import 'dart:async';

import 'package:flutter/material.dart';
import 'package:imgtag/screens/LoginScreen.dart';

class LandingScreen extends StatefulWidget {
  static final String id = 'splash_screen';
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {

  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 3),
        () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginScreen())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Expanded(
            child: Image.asset(
              'assets/images/logo.jpeg',
              height: 150,
              width: 150,
            ),
          ),
        ),
        Center(
            child: Expanded(
          child: Text(
            'Photified',
            style: TextStyle(
                color: Colors.black,
                fontSize: 45.0,
                fontFamily: 'DancingScript',
                fontWeight: FontWeight.bold),
          ),
        ))
      ],
    )));
  }
}
