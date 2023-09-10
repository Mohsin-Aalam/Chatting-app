import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:http/http.dart';

import '../models/user_model.dart';

class Apis {
  static FirebaseFirestore db = FirebaseFirestore.instance;

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      String recieverId, String senderId) {
    return db
        .collection("messages")
        .where('recieverId', isEqualTo: recieverId)
        .where('senderId', isEqualTo: senderId)
        .orderBy("dateTime")
        .snapshots();
    //  .get();
    // print('Querry snapShot -->${querySnapshot.docs}');

    // final d =
    //     querySnapshot.docs.map((doc) => ChatModel.fromFirestore(doc)).toList();
    // print('d->>${d}');
    // setState(() {
    //   chatsList = d;
    // });
    //  scrollDown();
    //print('chat list -->>->>${chatsList[0].messages}');
  }

  static Future<void> sendNotification(
      UserDetail chatUser, String message, String senderName) async {
    print('mesaage$message');
    print('sendTo${chatUser.name}');
    try {
      final body = {
        "to": chatUser.pushToken,
        "notification": {"title": senderName, "body": message}
      };
      var response =
          await post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
              headers: {
                HttpHeaders.contentTypeHeader: 'application/json',
                HttpHeaders.authorizationHeader:
                    'key=AAAAtgqqVOw:APA91bE2Oz1Qm-ktesoRd9CHrquM2cSH194brj5jl195WAbcO7UwZCFFzFnOU00ZVi-ITTKJrlu0DUK1yvxhmiBVzp9RppVBd-CiurSErYXP66TCD0-YYKDYyeDJWmYwJNvoQ3AdKHAv'
              },
              body: jsonEncode(body));
      print('response status ${response.statusCode}');
      print('response body ${response.body}');
    } catch (e) {
      print('error from push notification$e');
    }
  }

  static String getFormatedTime(
      {required String time, required BuildContext context}) {
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));

    return TimeOfDay.fromDateTime(date).format(context);
  }

  static String getLastMessageTime(
      {required String time, required BuildContext context}) {
    final DateTime sent = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final DateTime now = DateTime.now();
    if (now.day == sent.day &&
        now.month == sent.month &&
        now.year == sent.year) {
      return TimeOfDay.fromDateTime(sent).format(context);
    }
    return '${sent.day} ${_getMonth(sent)}';
  }

  static String _getMonth(DateTime date) {
    switch (date.month) {
      case 1:
        return 'jan';
      case 2:
        return 'feb';
      case 3:
        return 'mar';
      case 4:
        return 'apr';
      case 5:
        return 'may';
      case 6:
        return 'jun';
      case 7:
        return 'jul';
      case 8:
        return 'agu';
      case 9:
        return 'sep';
      case 10:
        return 'oct';
      case 11:
        return 'nov';
      case 12:
        return 'dec';
    }
    return 'NA';
  }
}
