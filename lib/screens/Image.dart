import 'package:flutter/material.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:photo_view/photo_view.dart';
import 'package:badges/badges.dart';
import 'package:imgtag/services/database_service.dart';

class ImageScreen extends StatefulWidget {
  ImageScreen(this.iconData, this.name, this.location, this.date, this.tag1,
      this.tag2, this.device);

  final String iconData;
  final String name;
  final String location;
  final String date;
  final String tag1;
  final String tag2;
  final String device;

  @override
  _ImageScreenState createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  bool _like = false;

  _likePost() async {
    setState(() {
      _like = !_like;
    });
  }

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
              fontFamily: 'PTSerif',
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
                        "Uploaded by: ${widget.name}",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 17,
                          fontFamily: 'PTSerif',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                      child: GestureDetector(
                        onTap: () {
                          _likePost();
                        },
                        child: Container(
                          child: _like == false
                              ? const Icon(
                                  Icons.thumb_up,
                                  size: 24,
                                  color: Colors.black,
                                )
                              : const Icon(
                                  Icons.thumb_up,
                                  size: 24,
                                  color: Colors.deepPurple,
                                ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async => await ImageDownloader.downloadImage(
                          '${widget.iconData}'),
                      child: Container(
                        child: const Icon(
                          Icons.arrow_downward,
                          size: 24,
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
                    "Uploaded on: ${widget.date}",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'PTSerif',
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "Location: ${widget.location}",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'PTSerif',
                    ),
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
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'PTSerif',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
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
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text('${widget.tag1}',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'PTSerif',
                              )),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
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
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text('${widget.tag2}',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'PTSerif',
                              )),
                        ),
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
                        "Device: ${widget.device}",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 17,
                          fontFamily: 'PTSerif',
                        ),
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
