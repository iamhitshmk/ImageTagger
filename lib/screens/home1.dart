import 'package:flutter/material.dart';
import 'dart:async';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:ImageTagging/models/user_model.dart';

class Home1 extends StatefulWidget {
  static final String id = "home1";
  final User user;
  Home1({this.user});
  @override
  _Home1State createState() => new _Home1State();
}

class _Home1State extends State<Home1> {
  List<Asset> images = List<Asset>();

  Future<String> createDialogBox(BuildContext context) {
    TextEditingController customcontroller = TextEditingController();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Add Tag Name'),
            content: TextField(
              controller: customcontroller,
            ),
            actions: <Widget>[
              MaterialButton(
                child: Text('CANCEL'),
                onPressed: _onCancelTap,
              ),
              MaterialButton(
                child: Text('OK'),
                onPressed: () {},
              )
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
  }

  void _onCancelTap() {
    Navigator.pop(context);
  }

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return Stack(
          children: <Widget>[
            AssetThumb(
              asset: asset,
              width: 300,
              height: 300,
            ),
            IconButton(
              icon: Icon(Icons.more_vert, color: Colors.white),
              onPressed: () {
                createDialogBox(context).then((onValue) {
                  SnackBar mysnackbar =
                      SnackBar(content: Text("Tagged Successfully"));
                  Scaffold.of(context).showSnackBar(mysnackbar);
                });
              },
            )
          ],
        );
      }),
    );
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();

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
    } on Exception catch (e) {}

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          RaisedButton(
            child: Text("Select images from Gallery"),
            onPressed: loadAssets,
          ),
          Container(
            child: Text(widget.user.id),
          ),
          Expanded(
            child: buildGridView(),
          )
        ],
      ),
    );
  }
}
