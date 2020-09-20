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
        Colors.green, "https://static.toiimg.com/photo/73173811.cms"),
    const ImageTile(Colors.lightBlue,
        "https://papers.co/wallpaper/papers.co-nh93-mountain-sky-river-nature-scenery-summer-flare-8-wallpaper.jpg"),
    const ImageTile(Colors.amber,
        "https://i.pinimg.com/originals/8a/42/04/8a42043b7d18ca343faa4cea47f5f3ac.jpg"),
    const ImageTile(Colors.indigo,
        "https://resize.indiatvnews.com/en/resize/newbucket/1200_-/2020/05/pjimage-5-1589546097.jpg"),
    const ImageTile(Colors.green,
        "https://resize.indiatvnews.com/en/resize/newbucket/1200_-/2020/05/pjimage-5-1589546097.jpg"),
    const ImageTile(Colors.lightBlue,
        "https://resize.indiatvnews.com/en/resize/newbucket/1200_-/2020/05/pjimage-5-1589546097.jpg"),
    const ImageTile(Colors.amber,
        "https://resize.indiatvnews.com/en/resize/newbucket/1200_-/2020/05/pjimage-5-1589546097.jpg"),
    const ImageTile(Colors.amber,
        "https://resize.indiatvnews.com/en/resize/newbucket/1200_-/2020/05/pjimage-5-1589546097.jpg"),
    const ImageTile(Colors.green,
        "https://resize.indiatvnews.com/en/resize/newbucket/1200_-/2020/05/pjimage-5-1589546097.jpg"),
    const ImageTile(Colors.lightBlue,
        "https://resize.indiatvnews.com/en/resize/newbucket/1200_-/2020/05/pjimage-5-1589546097.jpg"),
    const ImageTile(Colors.amber,
        "https://resize.indiatvnews.com/en/resize/newbucket/1200_-/2020/05/pjimage-5-1589546097.jpg"),
    const ImageTile(Colors.indigo,
        "https://resize.indiatvnews.com/en/resize/newbucket/1200_-/2020/05/pjimage-5-1589546097.jpg"),
    const ImageTile(Colors.green,
        "https://resize.indiatvnews.com/en/resize/newbucket/1200_-/2020/05/pjimage-5-1589546097.jpg"),
    const ImageTile(Colors.lightBlue,
        "https://resize.indiatvnews.com/en/resize/newbucket/1200_-/2020/05/pjimage-5-1589546097.jpg"),
    const ImageTile(Colors.amber,
        "https://resize.indiatvnews.com/en/resize/newbucket/1200_-/2020/05/pjimage-5-1589546097.jpg"),
    const ImageTile(Colors.amber,
        "https://resize.indiatvnews.com/en/resize/newbucket/1200_-/2020/05/pjimage-5-1589546097.jpg"),
  ];

  @override
  initState() {
    super.initState();
    _hideFabAnimation =
        AnimationController(vsync: this, duration: kThemeAnimationDuration);
    _hideFabAnimation.forward();
  }

  @override
  void dispose() {
    _hideFabAnimation.dispose();
    super.dispose();
  }

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
              fontSize: 20.0,
              fontFamily: 'Billabong',
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
  const ImageTile(this.backgroundColor, this.iconData);

  final Color backgroundColor;
  final String iconData;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (context) => ImageScreen(this.iconData))),
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
