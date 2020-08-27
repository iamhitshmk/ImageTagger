import 'package:flutter/material.dart';
import 'package:ImageTagging/models/user_model.dart';

class NotificationScreen extends StatefulWidget {
  final User user;
  NotificationScreen({this.user});
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Notification Screen'),
      ),
    );
  }
}
