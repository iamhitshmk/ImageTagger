import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imgtag/models/user_model.dart';
import 'package:imgtag/services/database_service.dart';
import 'package:imgtag/services/storage_service.dart';

class EditProfileScreen extends StatefulWidget {
  final User user;

  EditProfileScreen({this.user});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  File _profileImage;
  String _name = '';
  String _bio = '';
  bool _isLoading = false;
  bool _private = false;

  @override
  void initState() {
    super.initState();
    _name = widget.user.name;
    _bio = widget.user.bio;
    _private = widget.user.private;
  }

  _cropImage(File imageFile) async {
    File cropped = await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
    );
    return cropped;
  }

  _handleImageFromGallery() async {
    final picker = ImagePicker();
    PickedFile imageFile = await picker.getImage(source: ImageSource.gallery);
    File file = File(imageFile.path);
    if (file != null) {
      file = await _cropImage(file);
      print(imageFile);
      setState(() {
        _profileImage = file;
      });
    }
  }

  _displayProfileImage() {
    //no new profile image
    if (_profileImage == null) {
      //no existing profile image
      if (widget.user.profileImageUrl.isEmpty) {
        //display placeholder
        return AssetImage('assets/images/user-placeholder.jpg');
      } else {
        //user profile image exists
        return CachedNetworkImageProvider(widget.user.profileImageUrl);
      }
    } else {
      //new profile image
      return FileImage(_profileImage);
    }
  }

  _submit() async {
    if (_formKey.currentState.validate() && !_isLoading) {
      _formKey.currentState.save();

      setState(() {
        _isLoading = true;
      });
      //update user in database
      String _profileImageUrl = '';

      if (_profileImage == null) {
        _profileImageUrl = widget.user.profileImageUrl;
      } else {
        _profileImageUrl = await StorageService.uploadUserProfileImage(
          widget.user.profileImageUrl,
          _profileImage,
        );
      }

      User user = User(
        id: widget.user.id,
        name: _name,
        profileImageUrl: _profileImageUrl,
        bio: _bio,
        private: _private
      );
      // database update
      DatabaseService.updateUser(user);

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Edit Profile',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              _isLoading
                  ? LinearProgressIndicator(
                      backgroundColor: Colors.blue[200],
                      valueColor: AlwaysStoppedAnimation(Colors.blue),
                    )
                  : SizedBox.shrink(),
              ListView(
                padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                children: <Widget>[
                  Container(
                    child: Column(
                      children: <Widget>[
                        CircleAvatar(
                          radius: 60.0,
                          backgroundColor: Colors.grey,
                          backgroundImage: _displayProfileImage(),
                        ),
                        FlatButton(
                          onPressed: _handleImageFromGallery,
                          child: Text(
                            'Change Profile Image',
                            style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _private,
                    onChanged: (value) {
                      setState(() {
                        _private = value;
                      });
                    },
                  ),
                  TextFormField(
                    initialValue: _name,
                    style: TextStyle(fontSize: 18.0),
                    decoration: InputDecoration(
                      icon: Icon(Icons.person, size: 30.0),
                      labelText: 'Name',
                    ),
                    validator: (input) => input.trim().length < 1
                        ? 'Please enter a valid name'
                        : null,
                    onSaved: (input) => _name = input,
                  ),
                  TextFormField(
                    initialValue: _bio,
                    style: TextStyle(fontSize: 18.0),
                    decoration: InputDecoration(
                      icon: Icon(Icons.book, size: 30.0),
                      labelText: 'Bio',
                    ),
                    validator: (input) => input.trim().length > 150
                        ? 'Please enter a bio less than 150 characters'
                        : null,
                    onSaved: (input) => _bio = input,
                  ),
                  Container(
                    margin: EdgeInsets.all(40.0),
                    height: 40.0,
                    width: 250.0,
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
                    child: FlatButton(
                      onPressed: _submit,
                      textColor: Colors.white,
                      child: Text(
                        'Save Profile',
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
