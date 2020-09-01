// import 'package:ImageTagging/screens/SignupScreen.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ImageTagging/screens/LoginScreen.dart';
import 'package:ImageTagging/screens/SearchScreen.dart';
// import 'package:ImageTagging/screens/home1.dart';
// import 'package:ImageTagging/screens/HomeScreen.dart';
// import 'package:ImageTagging/screens/splashscreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Widget _getScreenId() {
  //   return StreamBuilder<FirebaseUser>(
  //     stream: FirebaseAuth.instance.onAuthStateChanged,
  //     builder: (BuildContext context, snapshot) {
  //       if (snapshot.hasData) {
  //         // Provider.of<UserModal>(context).currentUserId = snapshot.data.uid;
  //         return LandingScreen(
  //           userId: snapshot.data.uid,
  //         );
  //       } else {
  //         return SignupScreen();
  //       }
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(),
      debugShowCheckedModeBanner: false,
      // routes: {
      //   LoginScreen.id: (context) => LoginScreen(),
      //   SignupScreen.id: (context) => SignupScreen(),
      //   LandingScreen.id: (context) => LandingScreen(),
      //   HomeScreen.id: (context) => HomeScreen(),
      //   Home1.id: (context) => Home1(),
      // },
    );
  }
}
