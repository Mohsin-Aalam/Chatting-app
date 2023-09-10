import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:message_app/screens/authentic/login_screen.dart';
import 'package:message_app/screens/char_room.dart';
import 'package:message_app/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/chat_usercard.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  List<UserDetail> userList = [];
  String _senderId = '';
  List<ChatModel> chatsList = [];
  String _senderName = '';

  FirebaseMessaging fMessaging = FirebaseMessaging.instance;
  Future<void> getFirebaseMessagingToken() async {
    await fMessaging.requestPermission();
    await fMessaging.getToken().then((token) async {
      if (token != null) {
        //  final toke = token;
        print('token :=>$token');
        await db
            .collection('users')
            .doc(_senderId)
            .update({'pushToken': token});
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _data();
  }

  void _data() async {
    final prefs = await SharedPreferences.getInstance();

    String _email = prefs.getString('userEmail').toString();

    setState(() {
      _senderId = prefs.getString('id').toString();
      _senderName = prefs.getString('userName').toString();
    });
    print('senderId${_senderName}');
    var querySnapshot =
        await db.collection("users").where('email', isNotEqualTo: _email).get();
    for (final snapshot in querySnapshot.docs) {
      final data = snapshot.data();

      setState(() {
        userList.add(UserDetail.fromFirestore(snapshot));
      });
    }
    getFirebaseMessagingToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: IconButton(
          onPressed: () {
            FirebaseAuth.instance.signOut().then((value) =>
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => LoginScreen(),
                )));
          },
          icon: Icon(Icons.logout),
        ),
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Chat'),
        ),
        body: ListView.builder(
            itemCount: userList.length,
            itemBuilder: (context, index) {
              return UserCard(
                user: userList[index],
                senderId: _senderId,
                SenderName: _senderName,
              );
              // ListTile(
              //   leading: CircleAvatar(
              //     backgroundImage: NetworkImage(
              //       userList[index].photoUrl.toString(),
              //     ),
              //     // backgroundColor: Colors.transparent,
              //   ),
              //   title: Text(
              //     userList[index].name,
              //     style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              //   ),
              //   subtitle: Text(chatsList[index].messages!),
              //   trailing: Wrap(
              //     spacing: 7,
              //     children: [
              //       Text('29/8/2023'),
              //       CircleAvatar(
              //         radius: 10,
              //         backgroundColor: Colors.green,
              //       )
              //     ],
              //   ),
              //   onTap: () {
              //     Navigator.of(context).push(MaterialPageRoute(
              //       builder: (context) => ChatRoom(
              //         senderId: _senderId,
              //         recieverId: userList[index].id,
              //         name: userList[index].name,
              //       ),
              //     ));
              //   },
              // );
            }));
  }
}
