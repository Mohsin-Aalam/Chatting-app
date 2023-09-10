import 'package:cloud_firestore/cloud_firestore.dart';

class UserDetail {
  final id;
  final String name;
  final String email;
  final String? photoUrl;
  final String? pushToken;

  UserDetail(
      {this.photoUrl,
      required this.name,
      required this.email,
      required this.id,
      required this.pushToken});

  factory UserDetail.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    return UserDetail(
        name: data!['name'],
        email: data['email'],
        photoUrl: data['photoUrl'],
        pushToken: data['pushToken'],
        id: snapshot.id);
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      if (photoUrl != null) 'photoUrl': photoUrl,
    };
  }
}

class ChatModel {
  ChatModel(
      {required this.read,
      required this.recieverId,
      required this.senderId,
      required this.messages,
      required this.dateTime,
      required this.documentId});

  String? recieverId;
  String? senderId;
  String messages;
  DateTime? dateTime;
  String read;
  String? documentId;

  factory ChatModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    return ChatModel(
        recieverId: data?['recieverId'],
        senderId: data?['senderId'],
        messages: data?['messages'],
        read: data?['read'],
        dateTime: (data?['dateTime'] as Timestamp).toDate(),
        documentId: data?['documentId']);
  }

  Map<String, dynamic> toFirestore() {
    return {
      'recieverId': recieverId,
      'senderId': senderId,
      'messages': messages,
      'dateTime': dateTime,
    };
  }
}
