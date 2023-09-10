import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:message_app/screens/authentic/login_screen.dart';
import 'package:message_app/screens/tabs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final prefs = await SharedPreferences.getInstance();
  String? id = prefs.getString('id');
  // String? userName = prefs.getString('userName');
  // String? userEmail = prefs.getString('userEmail');
  // String? userPhoto = prefs.getString('photoUrl');
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blueGrey,
            ),
            home: id == null ? const LoginScreen() : TabScreen(),
          )));
}
