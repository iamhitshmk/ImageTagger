import 'package:flutter/material.dart';
import 'package:ImageTagging/models/user_model.dart';

class ProfileScreen extends StatefulWidget {
  final User user;
  ProfileScreen({this.user});
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Profile Screen'),
      ),
    );
  }
}
