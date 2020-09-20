import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:imgtag/screens/ProfileScreen.dart';
import 'package:imgtag/screens/SearchScreen.dart';
import 'package:imgtag/screens/NotificationScreen.dart';
import 'package:imgtag/screens/Dashboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final String userId;
  static final String id = 'home_screen';

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
      body: PageView(
        controller: _pageController,
        children: <Widget>[
          Home1(userId: widget.userId),
          SearchScreen(userId: widget.userId),
          NotificationScreen(userId: widget.userId),
          ProfileScreen(userId: widget.userId)
        ],
        onPageChanged: (int index) {
          setState(() {
            _currentTab = index;
          });
        },
      ),
      // FutureBuilder(
      //     future: Firestore.instance
      //         .collection('users')
      //         .document(widget.userId)
      //         .get(),
      //     builder: (BuildContext context, AsyncSnapshot snapshot) {
      //       if (!snapshot.hasData) {
      //         return Center(
      //         child: CircularProgressIndicator(),
      //         );
      //       }
      //        if (snapshot.data == null) {
      //         return Center(
      //           child: Text('no data'),
      //         );
      //       }
      //       User user = User.fromDoc(snapshot.data);
      //       return PageView(
      //         controller: _pageController,
      //         children: <Widget>[
      //           Home1(
      //             user: user,
      //           ),
      //           TagScreen(
      //             user: user,
      //           ),
      //           SearchScreen()
      //         ],
      //         onPageChanged: (int index) {
      //           setState(() {
      //             _currentTab = index;
      //           });
      //         },
      //       );
      //     }),
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
            title: Text('Home',
                style: TextStyle(
                  fontFamily: 'PTSerif',
                )),
            activeColor: Colors.black87,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.search),
            title: Text('Search',
                style: TextStyle(
                  fontFamily: 'PTSerif',
                )),
            activeColor: Colors.black87,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.notifications),
            title: Text('Notifications',
                style: TextStyle(
                  fontFamily: 'PTSerif',
                )),
            activeColor: Colors.black87,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.person),
            title: Text('Profile',
                style: TextStyle(
                  fontFamily: 'PTSerif',
                )),
            activeColor: Colors.black87,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
