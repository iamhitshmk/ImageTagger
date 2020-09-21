import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:imgtag/models/post_model.dart';
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
  List<Post> _posts = List<Post>();
  User userObj;

  @override
  void initState() {
    super.initState();
    _setupIsFollowing();
    _setupFollowers();
    _setupFollowing();
    _getPosts();
  }

  _getPosts() async {
    List<Post> posts = await DatabaseService.getSelfPosts(widget.userId);
    print(_posts);
    setState(() {
      _posts = posts;
    });
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
                      Colors.deepPurple[300],
                      Colors.indigo[300],
                      Colors.cyan[100]
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
                    'Edit Profile',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                      fontFamily: 'PTSerif',
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

  showAlertDialog(BuildContext context) async {
    Widget cancelButton = FlatButton(
      child: Text("Cancel",
          style: TextStyle(
            fontFamily: 'PTSerif',
          )),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Logout",
          style: TextStyle(
            fontFamily: 'PTSerif',
          )),
      onPressed: () {
        AuthService.logout();
        Navigator.of(context).pop();
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Logout"),
      content: Text("Would you like to logout?",
          style: TextStyle(
            fontFamily: 'PTSerif',
          )),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: false,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.black,
            ),
            onPressed: () => showAlertDialog(context),
          )
        ],
        title: Text(
          'Profile',
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.0,
            fontFamily: 'PTSerif',
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
          userObj = user;

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
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  child: CircleAvatar(
                                    radius: 50.0,
                                    backgroundColor: Colors.grey,
                                    backgroundImage:
                                        user.profileImageUrl.isEmpty
                                            ? AssetImage(
                                                'assets/images/user.jpg',
                                              )
                                            : CachedNetworkImageProvider(
                                                user.profileImageUrl),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                  child: Text(
                                    user.name,
                                    style: TextStyle(
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'PTSerif',
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                user.bio != null || user.bio != ''
                                    ? Text(
                                        user.bio,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline2
                                            .copyWith(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.normal,
                                              fontFamily: 'PTSerif',
                                            ),
                                        textAlign: TextAlign.center,
                                      )
                                    : SizedBox.shrink()
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '${_posts.length}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline2
                                        .copyWith(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.normal,
                                          fontFamily: 'PTSerif',
                                        ),
                                  ),
                                ),
                                Text(
                                  'Photos',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'PTSerif',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    followercount.toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline2
                                        .copyWith(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.normal,
                                          fontFamily: 'PTSerif',
                                        ),
                                  ),
                                ),
                                Text(
                                  'Followers',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontFamily: 'PTSerif',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    followingcount.toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline2
                                        .copyWith(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.normal,
                                          fontFamily: 'PTSerif',
                                        ),
                                  ),
                                ),
                                Text(
                                  'Following',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontFamily: 'PTSerif',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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
                  ],
                ),
              ),
              Divider(),
              Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(width: 0.1),
                    ),
                    child: Center(
                      child: Text(
                        'Photos',
                        style: TextStyle(
                          fontSize: 17,
                          fontFamily: 'PTSerif',
                        ),
                      ),
                    ),
                  ),
                  _posts.length == 0
                      ? Container(
                          height: 200,
                          child: Center(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.event_note,
                                size: 50,
                                color: Colors.deepPurple[300],
                              ),
                              Text(
                                'No Posts',
                                style: TextStyle(
                                  fontFamily: 'PTSerif',
                                ),
                              ),
                            ],
                          )),
                        )
                      : Container(
                        alignment: Alignment.bottomLeft,
                        child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.start,
                            alignment: WrapAlignment.start,
                            direction: Axis.horizontal,
                            children: _posts
                                .map((post) => postCard(context, post))
                                .toList()
                                .cast<Widget>(),
                          ),
                      ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget postCard(BuildContext context, post) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ImageScreen(
                    post.imageUrl,
                    userObj.name,
                    post.location,
                    post.timestamp.toString(),
                    post.tags.split(",")[0],
                    post.tags.split(',')[1],
                    post.device,
                  ))),
      child: Image.network(
        post.imageUrl,
        height: MediaQuery.of(context).size.width / 3,
        width: MediaQuery.of(context).size.width / 3,
        fit: BoxFit.fill,
      ),
    );
  }
} //class
