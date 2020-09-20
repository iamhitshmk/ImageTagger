import 'package:cloud_firestore/cloud_firestore.dart';

class Post{
final String id;
final String imageUrl;
final String tags;
final String location;
final dynamic likes;
final String authorId;
final String device;
final Timestamp timestamp;

Post({
this.id,
this.imageUrl,
this.tags,
this.location,
this.likes,
this.authorId,
this.device,
this.timestamp,
});

factory Post.fromDoc(DocumentSnapshot doc){
  return Post(
    id: doc.documentID,
    imageUrl: doc['imageUrl'],
    tags: doc['tags'],
    location: doc['location'],
    likes: doc['likes'],
    authorId: doc['authorId'],
    device: doc['device'],
    timestamp: doc['timestamp'],
  );
}
}