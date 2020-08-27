import 'package:flutter/material.dart';
import 'package:ImageTagging/models/user_model.dart';

class EditProfileScreen extends StatefulWidget {
  final User user;
  EditProfileScreen({this.user});
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Edit Profile Screen'),
      ),
    );
  }
}
