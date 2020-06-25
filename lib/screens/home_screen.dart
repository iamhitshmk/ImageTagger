import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ImageTagging/models/user_model.dart';
import 'package:ImageTagging/screens/home1.dart';
import 'package:ImageTagging/screens/search_screen.dart';
import 'package:ImageTagging/screens/tag_screen.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';

class HomeScreen extends StatefulWidget {
  static final String id = "home_screen";
  final String userId;
  HomeScreen({this.userId});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentTab = 0;
  PageController _pageController;
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Image Tagging',
          style: TextStyle(
            color: Colors.purple,
            fontSize: 35.0,
            fontFamily: 'Billabong',
          ),
        ),
      ),
      body: FutureBuilder(
          future: Firestore.instance
              .collection('users')
              .document(widget.userId)
              .get(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(
              child: CircularProgressIndicator(),
              );
            }
             if (snapshot.data == null) {
              return Center(
                child: Text('no data'),
              );
            }
            User user = User.fromDoc(snapshot.data);
            return PageView(
              controller: _pageController,
              children: <Widget>[
                Home1(
                  user: user,
                ),
                TagScreen(
                  user: user,
                ),
                SearchScreen()
              ],
              onPageChanged: (int index) {
                setState(() {
                  _currentTab = index;
                });
              },
            );
          }),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentTab,
        showElevation: true,
        itemCornerRadius: 8,
        curve: Curves.easeInBack,
        onItemSelected: (int index) {
          setState(() {
            _currentTab = index;
          });
          _pageController.animateToPage(
            index,
            duration: Duration(milliseconds: 200),
            curve: Curves.easeIn,
          );
        },
        items: [
          BottomNavyBarItem(
            icon: Icon(Icons.apps),
            title: Text('Home'),
            activeColor: Colors.red,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.tag_faces),
            title: Text('Tags'),
            activeColor: Colors.purpleAccent,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.search),
            title: Text(
              ('Search'),
            ),
            activeColor: Colors.pink,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
