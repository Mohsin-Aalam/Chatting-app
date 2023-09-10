import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:math';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _aboutController = TextEditingController();
  Random random = Random();
  String _name = '';
  String _about = '';
  String _gmail = '';
  String _id = '';
  String _photoUrl = '';
  String _imageUrl = '';
  FirebaseFirestore db = FirebaseFirestore.instance;
  File? _selectedImage;

  void _imagePicker() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (image == null) return;
    // print('${image.path}');
    setState(() {
      _selectedImage = File(image.path);
    });

    //  print(_selectedImage);
    final storageRef = FirebaseStorage.instance.ref();

    Reference directoryImage = storageRef.child('images');
    Reference imageToUpload =
        directoryImage.child('${DateTime.now()}${random}-${image.name}');
    try {
      await imageToUpload.putFile(File(image.path));

      _imageUrl = await imageToUpload.getDownloadURL();
    } catch (error) {
      print('error');
    }

    var querySnapshot = db.collection("users");

    await querySnapshot.doc(_id).update({'photoUrl': _imageUrl});
    var pref = await SharedPreferences.getInstance();
    pref.setString('photoUrl', _imageUrl);
    setState(() {
      _photoUrl = _imageUrl;
    });

    //var querySnapshot = await db.collection("users").get();
  }

  void _myUser() async {
    final prefs = await SharedPreferences.getInstance();
    print('prefs${prefs}');
    setState(() {
      _name = prefs.getString('userName').toString();

      _gmail = prefs.getString('userEmail').toString();
      _photoUrl = prefs.getString('photoUrl').toString();
      _id = prefs.getString('id').toString();
      _about = prefs.getString('about').toString();
      //   print('user id ${_id}');
      //   print(_gmail);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _myUser();
  }

  void _showName(Function callBack) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
          title: Text('Enter Your name'),
          content: Form(
            child: TextFormField(
              controller: _nameController,
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('cancel')),
            TextButton(
                onPressed: () async {
                  var pref = await SharedPreferences.getInstance();
                  pref.setString('userName', _nameController.text);

                  var querySnapshot = db.collection("users");

                  querySnapshot.doc(_id).update({'name': _nameController.text});

                  // setState(() {
                  //   _name = _nameController.text;
                  // });

                  callBack(_nameController.text);
                  Navigator.of(context).pop();
                },
                child: Text('Save'))
          ]),
    );
  }

  void _showAbout(Function callBack) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
          title: Text('Enter Your name'),
          content: Form(
            child: TextFormField(
              controller: _aboutController,
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('cancel')),
            TextButton(
                onPressed: () async {
                  var pref = await SharedPreferences.getInstance();
                  pref.setString('about', _aboutController.text);
                  var querySnapshot = db.collection("users");

                  querySnapshot
                      .doc(_id)
                      .update({'about': _aboutController.text});

                  // setState(() {
                  //   _about = _aboutController.text;
                  // });
                  callBack(_aboutController.text);
                  Navigator.of(context).pop();
                },
                child: Text('Save'))
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        margin: const EdgeInsets.all(12),
        child: Column(children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.black12, borderRadius: BorderRadius.circular(20)),
            child: Column(
              children: [
                Padding(
                  padding:
                      EdgeInsets.only(top: 60, right: 60, left: 60, bottom: 30),
                  child: Stack(
                    children: [
                      Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(80)),
                        child: CircleAvatar(
                            maxRadius: 60,
                            backgroundImage: _photoUrl == null
                                ? null
                                : NetworkImage(
                                    _photoUrl,
                                    scale: 1.0,
                                  )),
                      ),
                      //  _photoUrl == null
                      //     ? 'https://images.unsplash.com/photo-1591154669695-5f2a8d20c089?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1374&q=80'
                      //     : _photoUrl,
                      Positioned(
                          right: 0,
                          bottom: 0,
                          child: IconButton(
                              onPressed: _imagePicker,
                              icon: Icon(
                                Icons.camera_alt_outlined,
                                color: Colors.white,
                                size: 30,
                              )))
                    ],
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text(
                    'name',
                    style: TextStyle(
                      color: Colors.black38,
                    ),
                  ),
                  subtitle: Text(
                    _name,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  trailing: IconButton(
                      onPressed: () {
                        _showName((value) {
                          setState(() {
                            _name = value;
                          });
                        });
                      },
                      icon: Icon(Icons.edit)),
                ),
                ListTile(
                  leading: Icon(Icons.note_alt_outlined),
                  title: Text(
                    'about',
                    style: TextStyle(
                      color: Colors.black38,
                    ),
                  ),
                  subtitle: Text(
                    _about,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  trailing: IconButton(
                      onPressed: () {
                        //   updatef();
                        _showAbout((value) {
                          setState(() {
                            _about = value;
                          });
                        });
                      },
                      icon: Icon(Icons.edit)),
                ),
                ListTile(
                  leading: Icon(Icons.mail),
                  title: Text(
                    'gmail',
                    style: TextStyle(
                      color: Colors.black38,
                    ),
                  ),
                  subtitle: Text(
                    _gmail,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                )
              ],
            ),
          ),
        ]),
      )),
    );
  }
}
