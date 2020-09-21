import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:imgtag/models/post_model.dart';
import 'package:imgtag/models/user_data.dart';
import 'package:imgtag/screens/HomeScreen.dart';
import 'package:imgtag/services/database_service.dart';
import 'package:imgtag/services/storage_service.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:device_info/device_info.dart';

class BlogScreen extends StatefulWidget {
  final String userId;

  BlogScreen(this.userId);
  @override
  _BlogScreenState createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  File _image;
  TextEditingController _tagsController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _deviceController = TextEditingController();
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  String _tags = '';
  String _location = '';
  String _deviceName = '';
  bool _isLoading = false;
  Position _currentPosition;
  String _currentAddress;
  var device;

  info() async {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    setState(() {
      _deviceController.text = androidInfo.model;
    });
    print('Running on ${androidInfo.model}');
    return androidInfo.model;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _deviceController.text = info();
    });
  }

  _getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });

      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
            "${place.locality}, ${place.postalCode}, ${place.country}";
        _locationController.text = _currentAddress;
      });
    } catch (e) {
      print(e);
    }
  }

  _showSelectImageDialog() {
    return !Platform.isIOS ? _iosBottomSheet() : _androidDialog();
  }

  _iosBottomSheet() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            title: Text('Add Photo'),
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: Text('Take Photo'),
                onPressed: () => _handleImage(ImageSource.camera),
              ),
              CupertinoActionSheetAction(
                child: Text('Choose from Gallery'),
                onPressed: () => _handleImage(ImageSource.gallery),
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              child: Text('cancel'),
              onPressed: () => Navigator.pop(context),
            ),
          );
        });
  }

  _androidDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('Add Photo'),
          children: <Widget>[
            SimpleDialogOption(
              child: Text('Take Photo'),
              onPressed: () => _handleImage(ImageSource.camera),
            ),
            SimpleDialogOption(
              child: Text('Choose from Gallery'),
              onPressed: () => _handleImage(ImageSource.gallery),
            ),
            SimpleDialogOption(
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.redAccent,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  _cropImage(File imageFile) async {
    File cropped = await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
    );
    return cropped;
  }

  _handleImage(ImageSource source) async {
    Navigator.pop(context);
    final picker = ImagePicker();
    PickedFile imageFile = await picker.getImage(source: source);
    File file = File(imageFile.path);
    if (file != null) {
      file = await _cropImage(file);
      setState(() {
        _image = file;
      });
    }
  }

// _handleImage(ImageSource source) async {
//   Navigator.pop(context);
//   File imageFile = await ImagePicker.pickImage(source: source);
//   if (imageFile != null){
// //    imageFile= await _cropImage(imageFile);
//     setState(() {
//       _image = imageFile;
//     });
//   }
// }
//_cropImage(File imageFile) async {
//File croppedImage = await ImageCropper.cropImage(
  //sourcePath: imageFile.path,
  //aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
//);
//return croppedImage;

//}

  _submit() async {
    if (!_isLoading && _image != null && _tags.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });

      //create post
      String imageUrl = await StorageService.uploadPost(_image);
      Post post = Post(
        imageUrl: imageUrl,
        tags: _tags,
        location: _locationController.text,
        device: _deviceController.text,
        likes: 0,
        authorId: Provider.of<UserData>(context, listen: false).currentUserId,
        timestamp: Timestamp.fromDate(DateTime.now()),
      );
      DatabaseService.createPost(post);
      //Reset data
      _tagsController.clear();

      setState(() {
        _tags = '';
        _image = null;
        _isLoading = false;
      });

      Navigator.pop(context);
    }
  }

  _clearLocation() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _locationController.clear());
    _locationController.clear();
  }

  _clearDevice() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _deviceController.clear());
    _deviceController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Create Post',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'PTSerif',
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.publish,
              color: Colors.deepPurple[300],
              size: 30,
            ),
            //    onPressed: _submit(),
            onPressed: _submit,
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Container(
            height: height,
            child: Column(
              children: <Widget>[
                _isLoading
                    ? Padding(
                        padding: EdgeInsets.only(bottom: 10.0),
                        child: LinearProgressIndicator(
                          backgroundColor: Colors.blue[200],
                          valueColor: AlwaysStoppedAnimation(Colors.blue),
                        ),
                      )
                    : SizedBox.shrink(),
                GestureDetector(
                  onTap: _showSelectImageDialog,
                  child: Container(
                      height: width,
                      width: width,
                      color: Colors.grey[300],
                      child: _image == null
                          ? Icon(
                              Icons.add_a_photo,
                              color: Colors.white70,
                              size: 150.0,
                            )
                          : Image(
                              image: FileImage(_image),
                              fit: BoxFit.cover,
                            )),
                ),
                SizedBox(height: 20.0),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _tagsController,
                        style: TextStyle(
                          fontSize: 15.0,
                          fontFamily: 'PTSerif',
                        ),
                        decoration: InputDecoration(
                          labelText: 'Tags Eg. birthday, party, etc.',
                        ),
                        onChanged: (input) => _tags = input,
                      ),
                      SizedBox(height: 15),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _deviceController,
                              style: TextStyle(
                                fontSize: 15.0,
                                fontFamily: 'PTSerif',
                              ),
                              decoration: InputDecoration(
                                labelText: 'Device Name',
                                labelStyle: TextStyle(
                                  fontFamily: 'PTSerif',
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    Icons.clear,
                                  ),
                                  onPressed: _clearDevice,
                                ),
                              ),
                              onChanged: (input) => _deviceName = input,
                            ),
                          ),
                          FlatButton(
                            child: Icon(
                              Icons.phone_android,
                              size: 30,
                              color: Colors.deepPurple[300],
                            ),
                            onPressed: () {
                              info();
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _locationController,
                              style: TextStyle(fontSize: 15.0),
                              decoration: InputDecoration(
                                labelText: 'Location',
                                labelStyle: TextStyle(
                                  fontFamily: 'PTSerif',
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    Icons.clear,
                                  ),
                                  onPressed: _clearLocation,
                                ),
                              ),
                              onChanged: (input) => _location = input,
                            ),
                          ),
                          FlatButton(
                            child: Icon(
                              Icons.my_location,
                              size: 30,
                              color: Colors.deepPurple[300],
                            ),
                            onPressed: () {
                              _getCurrentLocation();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
