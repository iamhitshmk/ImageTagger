import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';


class AuthService {
  static final _auth = FirebaseAuth.instance;
  static final _firestore = Firestore.instance;

  static void signUpUser(
      BuildContext context, String name, String email, String phone, String password) async {
    try {
      AuthResult authResult = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      FirebaseUser signedInUser = authResult.user;
      if (signedInUser != null) {
        _firestore.collection('/users').document(signedInUser.uid).setData({
          'name': name,
          'email': email,
          'phone': phone,
          'profileImageUrl': '',
        });
        Navigator.pop(context);
      }
    } catch (e) {
      print(e);
    }
  }

  static void logout() {
    _auth.signOut();
  }

  
  static void sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      if (e is PlatformException) {
        if (e.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
          Fluttertoast.showToast(
            msg: "Email Already in Use",
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Color(0xffd9d9d9),
          );
        } else if (e.code == 'ERROR_INVALID_EMAIL') {
          Fluttertoast.showToast(
            msg: "Invalid Email Address",
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Color(0xffd9d9d9),
          );
        } else {
          Fluttertoast.showToast(
            msg: "User Does Not Exist",
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Color(0xffd9d9d9),
          );
        }
      }
      print(e);
    }
  }
  

  static void login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      if (e is PlatformException) {
        if (e.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
          Fluttertoast.showToast(
            msg: "Email Already in Use",
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Color(0xffd9d9d9),
          );
        } else if (e.code == 'ERROR_INVALID_EMAIL') {
          Fluttertoast.showToast(
            msg: "Invalid Email Address",
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Color(0xffd9d9d9),
          );
        } else if (e.code == 'ERROR_WRONG_PASSWORD') {
          Fluttertoast.showToast(
            msg: "Wrong Password",
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Color(0xffd9d9d9),
          );
        } else if (e.code == 'ERROR_USER_NOT_FOUND') {
          Fluttertoast.showToast(
            msg: "User Not Found",
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Color(0xffd9d9d9),
          );
        } else if (e.code == 'ERROR_USER_DISABLED') {
          Fluttertoast.showToast(
            msg: "User Disabled",
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Color(0xffd9d9d9),
          );
        } else if (e.code == 'ERROR_TOO_MANY_REQUESTS') {
          Fluttertoast.showToast(
            msg: "Too Many Request Please Wait",
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Color(0xffd9d9d9),
          );
        } else {
          Fluttertoast.showToast(
            msg: "Operation not Allowed",
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Color(0xffd9d9d9),
          );
        }
      }
      print(e);
    }
  }
}
