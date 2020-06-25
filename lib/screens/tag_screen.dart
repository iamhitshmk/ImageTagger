import 'package:flutter/material.dart';
import 'package:ImageTagging/models/user_model.dart';

class TagScreen extends StatefulWidget {
  final User user;
  TagScreen({this.user});
  @override
  _TagScreenState createState() => _TagScreenState();
}

class _TagScreenState extends State<TagScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Tag Screen'),
      ),
    );
  }
}
