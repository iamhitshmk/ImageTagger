import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:imgtag/models/user_model.dart';
import 'package:imgtag/screens/Image.dart';
import 'package:imgtag/screens/ProfileScreen.dart';
import 'package:imgtag/screens/blog_screen.dart';
import 'package:imgtag/services/auth_service.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class Home1 extends StatefulWidget {
  static final String id = "home1";
  final String userId;
  final User user;
  Home1({this.user, this.userId});
  @override
  _Home1State createState() => new _Home1State();
}

class _Home1State extends State<Home1> with TickerProviderStateMixin<Home1> {
  List<Asset> images = List<Asset>();
  String _error = 'No Error Dectected';
  AnimationController _hideFabAnimation;
  var currentUserId;
  var list1 = {'name': "Moin Ghadiyali"};

  @override
  initState() {
    super.initState();
    _hideFabAnimation =
        AnimationController(vsync: this, duration: kThemeAnimationDuration);
    _hideFabAnimation.forward();
    currentUserId = widget.userId;
  }

  @override
  void dispose() {
    _hideFabAnimation.dispose();
    super.dispose();
  }

  List<StaggeredTile> _staggeredTiles = const <StaggeredTile>[
    const StaggeredTile.count(2, 2),
    const StaggeredTile.count(2, 1),
    const StaggeredTile.count(1, 2),
    const StaggeredTile.count(1, 1),
    const StaggeredTile.count(2, 2),
    const StaggeredTile.count(1, 2),
    const StaggeredTile.count(1, 1),
    const StaggeredTile.count(2, 2),
    const StaggeredTile.count(2, 1),
    const StaggeredTile.count(1, 2),
    const StaggeredTile.count(1, 1),
    const StaggeredTile.count(2, 2),
    const StaggeredTile.count(1, 2),
    const StaggeredTile.count(1, 1),
  ];

  List<Widget> _tiles = const <Widget>[
    const ImageTile(
        Colors.green,
        "https://images.unsplash.com/photo-1585595043051-3a6e3da2de6a?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=667&q=80",
        "Simran Gupta",
        "Manali",
        "Monday, 8th September, 2020",
        "ManaliVibes",
        "Industrial visit",
        "One Plus"),
    const ImageTile(
        Colors.green,
        "https://images.unsplash.com/photo-1593926365674-ac277753ab76?ixlib=rb-1.2.1&auto=format&fit=crop&w=1533&q=80",
        "Sheetal Sharma",
        "Hyderabad",
        "Monday, 9th June, 2020",
        "SocialClub",
        "Night",
        "Micromax"),
    const ImageTile(
        Colors.indigo,
        "https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
        "Shubham Lokhande",
        "Igatpuri",
        "Monday, 8th May, 2020",
        "Nature",
        "Photography",
        "OppoF9"),
    const ImageTile(
        Colors.green,
        "https://upload.wikimedia.org/wikipedia/commons/3/33/Mr._Bean_2011.jpg",
        "Hritik Vejare",
        "tilak Nagar",
        "Monday, 8th July, 2020",
        "Comedian",
        "Television",
        "OppoF9"),
    const ImageTile(
        Colors.green,
        "https://images.unsplash.com/photo-1470043201067-764120126eb4?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
        "Jyoti Gupta",
        "LONAVALA",
        "Monday, 8th Dec, 2020",
        "RiverSide",
        "Nature",
        "OppoA5"),
    const ImageTile(
        Colors.amber,
        "https://media.gettyimages.com/photos/cricket-batsman-hitting-ball-during-cricket-match-in-stadium-picture-id518022060?s=2048x2048",
        "Jay haria",
        "Pune",
        "Tuesday, 5th Oct, 2020",
        "Sports Day",
        "Sport Club",
        "Samsung Galaxy Z Fold2"),
    const ImageTile(
        Colors.amber,
        "https://static2.tripoto.com/media/filter/nxl/img/256471/TripDocument/1460114416_create_nightclub_3_54_990x660.jpg",
        "Jyoti Shah",
        "Mumbai",
        "Saturday,3th January,2019",
        "Party",
        "Bachelor party",
        "Apple iPhone XS"),
    const ImageTile(
        Colors.green,
        "https://images.unsplash.com/photo-1468234847176-28606331216a?ixlib=rb-1.2.1&auto=format&fit=crop&w=1015&q=80",
        "Purnima Gupta",
        "festival",
        "Wednesday,15th March,2017",
        "Festival",
        "Holi festival",
        "Realme 7 Pro"),
    const ImageTile(
        Colors.lightBlue,
        "https://images.unsplash.com/photo-1554332049-a72a6671ab7f?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=334&q=80",
        "Zeel Shah",
        "Domivli",
        "Thursday, 4th July, 2002",
        "Travel",
        "Camping",
        "Redmi Note 9 Pro Max"),
    const ImageTile(
        Colors.amber,
        "https://images.unsplash.com/photo-1599687349320-469385c7e429?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=334&q=80",
        "Tanvi Patel",
        "Vashi",
        "Monday,14th August,2019",
        "Candid",
        " Workaholic",
        "Apple iPhone 6"),
    const ImageTile(
        Colors.indigo,
        "https://images.pexels.com/photos/33443/pexels-photo.jpg?cs=srgb&dl=pexels-donald-tong-33443.jpg&fm=jpg",
        "Rohit Patle",
        "Goa",
        "Sunday,15th May,2018",
        "Adventure",
        "Skydivers ",
        "Realme 6"),
    const ImageTile(
        Colors.green,
        "https://images.unsplash.com/photo-1599855796261-da055682563c?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max",
        "Amit Verma",
        "Thane",
        "Tuesday,11th June,2004",
        "Photo Shoot ",
        "Photography",
        "Oppo F17 Pro"),
    const ImageTile(
        Colors.lightBlue,
        "https://images.unsplash.com/photo-1549531061-c6fa9092ba8b?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=334&q=80",
        "Dev Roy",
        "Andheri",
        "Sunday,12th February,2015",
        "Cars",
        "Portrait Cars",
        "apple iphone 11pro max"),
    const ImageTile(
        Colors.amber,
        "https://resize.indiatvnews.com/en/resize/newbucket/1200_-/2020/05/pjimage-5-1589546097.jpg",
        "Moin Ghadiyali",
        "Mumbra",
        "Monday, 12th September, 2020",
        "hritik",
        "roshan",
        "Nokia 6.1 Plus"),
  ];

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification.depth == 0) {
      if (notification is UserScrollNotification) {
        final UserScrollNotification userScroll = notification;
        switch (userScroll.direction) {
          case ScrollDirection.forward:
            if (userScroll.metrics.maxScrollExtent !=
                userScroll.metrics.minScrollExtent) {
              _hideFabAnimation.forward();
            }
            break;
          case ScrollDirection.reverse:
            if (userScroll.metrics.maxScrollExtent !=
                userScroll.metrics.minScrollExtent) {
              _hideFabAnimation.reverse();
            }
            break;
          case ScrollDirection.idle:
            break;
        }
      }
    }
    return false;
  }

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return AssetThumb(
          asset: asset,
          width: 300,
          height: 300,
        );
      }),
    );
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }
    if (!mounted) return;

    setState(() {
      images = resultList;
      _error = error;
    });
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          leading: GestureDetector(
            onTap: AuthService.logout,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(
                  'https://in.bmscdn.com/iedb/artist/images/website/poster/large/hrithik_roshan_833_09-08-2016_05-24-02.jpg',
                  height: 40,
                  width: 40,
                ),
              ),
            ),
          ),
          elevation: 1,
          title: Text(
            'Photified',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 30.0,
              fontFamily: 'DancingScript',
            ),
          ),
        ),
        body: CustomRefreshIndicator(
            onRefresh: () => Future.delayed(const Duration(seconds: 1)),
            child: new StaggeredGridView.count(
              crossAxisCount: 4,
              staggeredTiles: _staggeredTiles,
              children: _tiles,
              mainAxisSpacing: 3.0,
              crossAxisSpacing: 3.0,
              padding: const EdgeInsets.all(4.0),
            ),
            builder: (
              BuildContext context,
              Widget child,
              IndicatorController controller,
            ) {
              return AnimatedBuilder(
                animation: controller,
                builder: (BuildContext context, _) {
                  return Stack(
                    alignment: Alignment.topCenter,
                    children: <Widget>[
                      if (!controller.isIdle)
                        Positioned(
                          top: 35.0 * controller.value,
                          child: SizedBox(
                            height: 30,
                            width: 30,
                            child: CircularProgressIndicator(
                              value: !controller.isLoading
                                  ? controller.value.clamp(0.0, 1.0)
                                  : null,
                            ),
                          ),
                        ),
                      Transform.translate(
                        offset: Offset(0, 100.0 * controller.value),
                        child: child,
                      ),
                    ],
                  );
                },
              );
            }),
        floatingActionButton: ScaleTransition(
          scale: _hideFabAnimation,
          child: Container(
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
              borderRadius: BorderRadiusDirectional.circular(50.0),
            ),
            child: FloatingActionButton(
              backgroundColor: Colors.transparent,
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => BlogScreen())),
              child: Icon(Icons.add_a_photo),
            ),
          ),
        ),
      ),
    );
  }
}

class ImageTile extends StatelessWidget {
  const ImageTile(this.backgroundColor, this.iconData, this.name, this.location,
      this.date, this.tag1, this.tag2, this.device);

  final Color backgroundColor;
  final String iconData;
  final String name;
  final String location;
  final String date;
  final String tag1;
  final String tag2;
  final String device;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ImageScreen(
                    this.iconData,
                    this.name,
                    this.location,
                    this.date,
                    this.tag1,
                    this.tag2,
                    this.device,
                  ))),
      child: new Card(
        color: backgroundColor,
        child: Image.network(
          '$iconData',
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
