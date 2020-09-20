import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:imgtag/models/post_model.dart';
import 'package:imgtag/models/user_model.dart';
import 'package:imgtag/utilities/constants.dart';

class DatabaseService {
  static void updateUser(User user) {
    usersRef.document(user.id).updateData({
      'name': user.name,
      'profileImageUrl': user.profileImageUrl,
      'bio': user.bio,
      'private': user.private
    });
  }

  static Future<QuerySnapshot> searchUsers(String name) {
    Future<QuerySnapshot> users =
        usersRef.where('name', isGreaterThanOrEqualTo: name).getDocuments();
    return users;
  }

  static void createPost(Post post) {
    postsRef.document(post.authorId).collection('usersPosts').add({
      'imageUrl': post.imageUrl,
      'tags': post.tags,
      'likes': post.likes,
      'authorId': post.authorId,
      'timestamp': post.timestamp,
      'device': post.device,
      'location': post.location
    });
  }

  static void likePost(
      String currentUserId, String postId, bool likeStatus) async {
    DocumentSnapshot likePost = await likesRef
        .document(currentUserId)
        .collection('postLike')
        .document(postId)
        .get();

    if (likePost.exists != true) {
      likesRef
          .document(currentUserId)
          .collection('postLike')
          .document(postId)
          .updateData({
        "like": likeStatus,
        'timestamp': DateTime.now(),
      });
    } else {
      likesRef
          .document(currentUserId)
          .collection('postLike')
          .document(postId)
          .setData({
        "like": likeStatus,
        'timestamp': DateTime.now(),
      });
    }
  }

  static void followUser({String currentUserId, String userId}) {
    // add user to current user's following collection
    followingRef
        .document(currentUserId)
        .collection('userFollowing')
        .document(userId)
        .setData({});
    // add current user to user's followers collection
    followersRef
        .document(userId)
        .collection('userFollowers')
        .document(currentUserId)
        .setData({});

    notificationsRef.add({
      'userId': currentUserId,
      'responderId': userId,
      'type': 1,
      'timestamp': DateTime.now()
    });
  }

  static void unfollowUser({String currentUserId, String userId}) {
    // remove user from current user's following collection
    followingRef
        .document(currentUserId)
        .collection('userFollowing')
        .document(userId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    // remove current user from user's followers collection
    followersRef
        .document(userId)
        .collection('userFollowers')
        .document(currentUserId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  static notifications(String currentUserId) async {
    QuerySnapshot notificationSnap = await notificationsRef
        .where({'responderId': currentUserId}).getDocuments();
    return notificationSnap;
  }

  static Future<bool> isFollowingUser(
      {String currentUserId, String userId}) async {
    DocumentSnapshot followingDoc = await followersRef
        .document(userId)
        .collection('userFollowers')
        .document(currentUserId)
        .get();
    return followingDoc.exists;
  }

  static Future<int> numFollowing(String userId) async {
    QuerySnapshot followingSnapshot = await followingRef
        .document(userId)
        .collection('userFollowing')
        .getDocuments();
    return followingSnapshot.documents.length;
  }

  static Future<int> numFollowers(String userId) async {
    QuerySnapshot followersSnapshot = await followersRef
        .document(userId)
        .collection('userFollowers')
        .getDocuments();
    return followersSnapshot.documents.length;
  }

  static Future<List<Post>> getSelfPosts(String userId) async {
    QuerySnapshot postsSnapShot = await postsRef
        .document(userId)
        .collection('usersPosts')
        .orderBy('timestamp', descending: true)
        .getDocuments();

    List<Post> posts =
        postsSnapShot.documents.map((doc) => Post.fromDoc(doc)).toList();
    return posts;
  }

  static Future<List<Post>> getFeedPosts(String userId) async {
    QuerySnapshot feedSnapshot = await feedsRef
        .document(userId)
        .collection('userFeed')
        .orderBy('timestamp', descending: true)
        .getDocuments();
    List<Post> posts =
        feedSnapshot.documents.map((doc) => Post.fromDoc(doc)).toList();
    return posts;
  }

  static Future<User> getUserWithId(String userId) async {
    DocumentSnapshot userDocSnapshot = await usersRef.document(userId).get();
    if (userDocSnapshot.exists) {
      return User.fromDoc(userDocSnapshot);
    }
    return User();
  }
}
