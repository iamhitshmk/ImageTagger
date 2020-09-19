import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:badges/badges.dart';

class ImageScreen extends StatefulWidget {
  ImageScreen(this.iconData);

  final String iconData;
  @override
  _ImageScreenState createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: false,
          title: Text(
            'Post',
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
              fontFamily: 'Billabong',
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Image.network(
                '${widget.iconData}',
                height: MediaQuery.of(context).size.width,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.fill,
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        "Uploaded by: Simran Gupta",
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 17),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => {},
                      child: Container(
                        child: const Icon(
                          Icons.arrow_downward,
                          size: 20,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "Uploaded on: Monday, 10th September, 2020",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Text(
                      "Tags: ",
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 15),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                      child: Chip(
                        backgroundColor: Colors.deepPurple,
                        padding: EdgeInsets.all(5),
                        label: Text('Birthday',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                      child: Chip(
                        backgroundColor: Colors.deepPurple,
                        padding: EdgeInsets.all(5),
                        label: Text('Birthday Pics',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                      child: Chip(
                        backgroundColor: Colors.deepPurple,
                        padding: EdgeInsets.all(5),
                        label: Text('21st Birthday',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Device: Iphone XS Max",
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 17),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  } //widgetbuild
} //class
