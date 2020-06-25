import 'package:cloud_firestore/cloud_firestore.dart';

class User{
  final String id;
  final String tagname;

  User({
    this.id,
    this.tagname,
  });
  factory User.fromDoc(DocumentSnapshot doc){
    return User(
      id : doc.documentID,
      // tagname: doc['TagName'],
    );
  }
}