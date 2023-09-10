import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:message_app/models/user_model.dart';
import 'package:message_app/apis/apis.dart';
import 'package:intl/intl.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom(
      {super.key,
      required this.senderId,
      required this.recieverId,
      required this.senderName,
      required this.user});
  final String senderId;
  final String recieverId;
  final String senderName;
  final UserDetail user;

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  TextEditingController _messageController = TextEditingController();
  List<ChatModel> chatsList = [];
  final ScrollController _scrollController = ScrollController();

  // void scrollDown() {
  //   _scrollController.animateTo(10 * 100,
  //       duration: const Duration(milliseconds: 1000), curve: Curves.linear);
  //   // _scrollController.animateTo(_scrollController.position.maxScrollExtent,
  //   //     duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
  // }

  FirebaseFirestore db = FirebaseFirestore.instance;
  DateTime _now = DateTime.now();
  List documentId = [];

  // Future<void> sendNotification(UserDetail chatUser, String message) async {
  //   try {
  //     final body = {
  //       "to":
  //           "dHY9MYECSeGZWOVEeuW8XX:APA91bG6Bs1-MGcSziD0hp5JlKwK5bS2Wjch8e4uusil53aZovmE1wTLInyqUvX-SKqt75-mEN5PNxei6cDC4_jgLRxAdaic9BfFhplld6t0SMHoc5YqCjv2CxIadZbU49DWGxBGC2Xg",
  //       "notification": {
  //         "title": "hello from mohsim alam",
  //         "body": "hello mr.vasim"
  //       }
  //     };
  //     var response =
  //         await post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
  //             headers: {
  //               HttpHeaders.contentTypeHeader: 'application/json',
  //               HttpHeaders.authorizationHeader:
  //                   'key=AAAAtgqqVOw:APA91bE2Oz1Qm-ktesoRd9CHrquM2cSH194brj5jl195WAbcO7UwZCFFzFnOU00ZVi-ITTKJrlu0DUK1yvxhmiBVzp9RppVBd-CiurSErYXP66TCD0-YYKDYyeDJWmYwJNvoQ3AdKHAv'
  //             },
  //             body: jsonEncode(body));
  //     print('response status ${response.statusCode}');
  //     print('response body ${response.body}');
  //   } catch (e) {
  //     print('error from push notification$e');
  //   }
  // }

  _sendDataToFirestore() async {
    ChatModel user;
    Timestamp formattedDate = Timestamp.now();

    DocumentReference doc = await db.collection("messages").add({
      if (widget.recieverId != null) 'recieverId': widget.recieverId,
      'senderId': widget.senderId,
      'messages': _messageController.text,
      'dateTime': formattedDate,
      'read': '',
    });

    await db.collection('messages').doc(doc.id).update({'documentId': doc.id});
    print('TextCotroller${_messageController.text}');
    await Apis.sendNotification(
        widget.user, _messageController.text, widget.senderName);

    // Navigator.of(context).pushReplacement(MaterialPageRoute(
    //   builder: (context) =>
    //       ChatRoom(senderId: widget.senderId, recieverId: widget.recieverId),
    // ));
  }

  Future<void> _update(ChatModel message) async {
    if (message.recieverId == widget.senderId) {
      await db
          .collection('messages')
          .doc(message.documentId)
          .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //  _getData();
  }

  void _getData() async {
    var querySnapshot = await db
        .collection("messages")
        .where('recieverId', isEqualTo: widget.recieverId)
        .where('senderId', isEqualTo: widget.senderId)
        .orderBy("dateTime")
        .get();
    print('Querry snapShot -->${querySnapshot.docs}');

    final d =
        querySnapshot.docs.map((doc) => ChatModel.fromFirestore(doc)).toList();
    print('d->>${d}');
    setState(() {
      chatsList = d;
    });
    //  scrollDown();
    //print('chat list -->>->>${chatsList[0].messages}');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.user.name),
          actions: [
            IconButton(
              icon: Icon(Icons.video_call),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.call),
              onPressed: () {},
            ),
            SizedBox(
              width: 16,
            )
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                  stream: db
                      .collection("messages")
                      .where(Filter.or(
                          Filter.and(
                              Filter('recieverId', isEqualTo: widget.senderId),
                              Filter('senderId', isEqualTo: widget.recieverId)),
                          Filter.and(
                              Filter('recieverId',
                                  isEqualTo: widget.recieverId),
                              Filter('senderId', isEqualTo: widget.senderId))))
                      // .where('recieverId', isEqualTo: widget.recieverId)
                      // .where('senderId', isEqualTo: widget.senderId)
                      .orderBy("dateTime", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return const SizedBox();
                      case ConnectionState.active:
                      case ConnectionState.done:
                        var data = snapshot.data!.docs;
                        // print(chatsList);
                        print("data hai vro ${data}");
                        data.forEach((element) {
                          print('data${element.id}');

                          // _update(element.id);
                        });

                        //  print('Data: ${data}');
                        final d = data
                            .map((doc) => ChatModel.fromFirestore(doc))
                            .toList();

                        chatsList = d;
                        //  print('Listhai vro-> ${d}');

                        if (chatsList.isNotEmpty) {
                          return ListView.builder(
                              controller: _scrollController,
                              physics: BouncingScrollPhysics(),
                              reverse: true,
                              keyboardDismissBehavior:
                                  ScrollViewKeyboardDismissBehavior.manual,
                              // shrinkWrap: true,
                              itemCount: chatsList.length,
                              itemBuilder: (context, index) {
                                //  _update(snapshot.data!.docs[index].id);

                                return chatsList[index].senderId ==
                                        widget.senderId
                                    ? senderMessage(chatsList[index])
                                    : recieveMessage(chatsList[index]);
                              });
                        } else {
                          return const Center(
                            child: Text('hey hi'),
                          );
                        }
                    }
                  }),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {},
                            color: Colors.blueGrey,
                            highlightColor: Colors.brown,
                            icon: const Icon(
                              Icons.add,
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.multiline,
                              controller: _messageController,
                              decoration: InputDecoration(
                                hintText: 'Type Something....',
                                hintStyle: TextStyle(color: Colors.blueGrey),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.emoji_emotions_outlined)),
                          IconButton(
                              onPressed: () async {
                                //scrollDown();
                                if (_messageController.text.isNotEmpty) {
                                  await _sendDataToFirestore();
                                  _messageController.text = '';
                                }
                              },
                              icon: Icon(
                                Icons.send_outlined,
                                color: Colors.blue,
                              ))
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container recieveMessage(ChatModel message) {
    if (message.read.isEmpty) _update(message);
    return Container(
      padding: EdgeInsets.only(bottom: 10, right: 14, top: 10, left: 14),
      child: Align(
        alignment: Alignment.topLeft,
        child:
            // Text(chatsList[index]
            //     .dateTime
            //     .toString()),
            Card(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(24),
                  topRight: Radius.circular(24),
                  bottomLeft: Radius.circular(24))),
          color: Color.fromARGB(255, 176, 227, 252),
          borderOnForeground: true,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  message.messages,
                  style:
                      const TextStyle(color: Color.fromARGB(255, 17, 15, 15)),
                ),
                Text(
                  message.dateTime.toString().substring(10, 16),
                  style: TextStyle(fontSize: 12, color: Colors.black38),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget senderMessage(ChatModel message) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(bottom: 10, right: 14, top: 10, left: 14),
          child: Align(
            alignment: Alignment.topRight,
            child:
                // Text(chatsList[index]
                //     .dateTime
                //     .toString()),
                Card(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(24),
                      topLeft: Radius.circular(24),
                      bottomLeft: Radius.circular(24))),
              color: const Color.fromARGB(255, 217, 225, 227),
              borderOnForeground: true,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      message.messages,
                      style: const TextStyle(
                          color: Color.fromARGB(255, 17, 15, 15)),
                    ),
                    Text(
                      message.dateTime.toString().substring(10, 16),
                      style: TextStyle(fontSize: 12, color: Colors.black38),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (message.read.isNotEmpty)
          const Positioned(
              right: 12,
              bottom: 0,
              child: Icon(
                Icons.done_all_rounded,
                color: Colors.blueAccent,
              ))
      ],
    );
  }
}
