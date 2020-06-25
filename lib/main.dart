import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ImageTagging/models/user_modal.dart';
import 'package:ImageTagging/screens/LoginScreen.dart';
import 'package:ImageTagging/screens/home1.dart';
import 'package:ImageTagging/screens/home_screen.dart';
import 'package:ImageTagging/screens/splashscreen.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget _getScreenId() {
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          // Provider.of<UserModal>(context).currentUserId = snapshot.data.uid;
          return LandingScreen(
            userId: snapshot.data.uid,
          );
        } else {
          return LoginPage();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _getScreenId(),
      routes: {
        LoginPage.id: (context) => LoginPage(),
        LandingScreen.id: (context) => LandingScreen(),
        HomeScreen.id: (context) => HomeScreen(),
        Home1.id: (context) => Home1(),
      },
    );
  }
}
