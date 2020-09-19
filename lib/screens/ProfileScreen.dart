import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:imgtag/models/user_data.dart';
import 'package:imgtag/models/user_model.dart';
import 'package:imgtag/screens/EditProfile.dart';
import 'package:imgtag/screens/Image.dart';
import 'package:imgtag/services/auth_service.dart';
import 'package:imgtag/services/database_service.dart';
import 'package:imgtag/utilities/constants.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  static final String id = 'profile_screen';
  final String currentUserId;
  final String userId;

  ProfileScreen({this.currentUserId, this.userId});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isFollowing = false;
  int followercount = 0;
  int followingcount = 0;

  @override
  void initState() {
    super.initState();
    _setupIsFollowing();
    _setupFollowers();
    _setupFollowing();
  }

  _setupIsFollowing() async {
    bool isFollowingUser = await DatabaseService.isFollowingUser(
      currentUserId: widget.currentUserId,
      userId: widget.userId,
    );
    setState(() {
      isFollowing = isFollowingUser;
    });
  }

  _setupFollowers() async {
    int userFollowerCount = await DatabaseService.numFollowers(widget.userId);
    setState(() {
      followercount = userFollowerCount;
    });
  }

  _setupFollowing() async {
    int userFollowingCount = await DatabaseService.numFollowing(widget.userId);
    setState(() {
      followingcount = userFollowingCount;
    });
  }

  _followorUnfollow() {
    if (isFollowing) {
      _unfollowUser();
    } else {
      _followUser();
    }
  }

  _unfollowUser() {
    DatabaseService.unfollowUser(
      currentUserId: widget.currentUserId,
      userId: widget.userId,
    );
    setState(() {
      isFollowing = false;
      followercount--;
    });
  }

  _followUser() {
    DatabaseService.followUser(
      currentUserId: widget.currentUserId,
      userId: widget.userId,
    );
    setState(() {
      isFollowing = true;
      followercount++;
    });
  }

  _displayButton(User user) {
    return user.id == Provider.of<UserData>(context).currentUserId
        ? Container(
            child: Expanded(
              child: Container(
                margin: EdgeInsets.all(7.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Color(0xff5c27fe),
                      Color(0xffc165dd),
                    ],
                  ),
                  borderRadius: BorderRadiusDirectional.circular(15.0),
                ),
                child: FlatButton(
                  padding: EdgeInsets.all(10.0),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditProfileScreen(
                        user: user,
                      ),
                    ),
                  ),
                  child: Text(
                    'Update Profile',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          )
        : Container(
            child: Expanded(
              child: Container(
                margin: EdgeInsets.all(7.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Color(0xff5c27fe),
                      Color(0xffc165dd),
                    ],
                  ),
                  borderRadius: BorderRadiusDirectional.circular(15.0),
                ),
                child: FlatButton(
                  padding: EdgeInsets.all(15.0),
                  onPressed: _followorUnfollow,
                  child: Text(
                    isFollowing ? 'Unfollow' : 'Follow',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: isFollowing ? Colors.white : Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: Text(
          'Profile',
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.0,
            fontFamily: 'Billabong',
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: usersRef.document(widget.userId).get(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          User user = User.fromDoc(snapshot.data);

          return ListView(
            children: <Widget>[
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 10.0,
                margin: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                ListTile(
                                  title: Text(
                                    user.name,
                                    style: TextStyle(
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  subtitle: Text(
                                    user.bio,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline2
                                        .copyWith(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.normal,
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                  isThreeLine: true,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: CircleAvatar(
                              radius: 55.0,
                              backgroundColor: Colors.grey[350],
                              child: CircleAvatar(
                                radius: 50.0,
                                backgroundColor: Colors.grey,
                                backgroundImage: user.profileImageUrl.isEmpty
                                    ? AssetImage(
                                        'assets/images/user-placeholder.jpg')
                                    : CachedNetworkImageProvider(
                                        user.profileImageUrl),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 15, 0, 5),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    'Posts',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '0',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline2
                                        .copyWith(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.normal,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    'Followers',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    followercount.toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline2
                                        .copyWith(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.normal,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    'Following',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    followingcount.toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline2
                                        .copyWith(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.normal,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 18.0),
                child: Row(
                  children: <Widget>[
                    _displayButton(user),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.all(7.0),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                              Color(0xff5c27fe),
                              Color(0xffc165dd),
                            ],
                          ),
                          borderRadius: BorderRadiusDirectional.circular(15.0),
                        ),
                        child: FlatButton(
                          padding: EdgeInsets.all(10.0),
                          onPressed: AuthService.logout,
                          child: Text(
                            'Logout',
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        postCard(context),
                        postCard(context),
                        postCard(context),
                      ],
                    ),
                    Row(
                      children: [
                        postCard(context),
                        postCard(context),
                        postCard(context),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  } //widgetbuild

  Widget postCard(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ImageScreen(
                    'https://resize.indiatvnews.com/en/resize/newbucket/1200_-/2020/05/pjimage-5-1589546097.jpg'))),
        child: new Card(
          color: Colors.blueAccent,
          child: Image.network(
            'https://resize.indiatvnews.com/en/resize/newbucket/1200_-/2020/05/pjimage-5-1589546097.jpg',
            height: MediaQuery.of(context).size.width / 3,
            width: MediaQuery.of(context).size.width / 3,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
} //class
