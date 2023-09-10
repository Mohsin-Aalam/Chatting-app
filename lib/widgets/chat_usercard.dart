import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:message_app/models/user_model.dart';
import 'package:message_app/apis/apis.dart';
import '../screens/char_room.dart';

class UserCard extends StatefulWidget {
  const UserCard(
      {super.key,
      required this.user,
      required this.senderId,
      required this.SenderName});
  final UserDetail user;
  final String senderId;
  final String SenderName;
  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    ChatModel? _message;
    return StreamBuilder(
      stream: db
          .collection("messages")
          // .where('recieverId', isEqualTo: widget.user.id)
          // .where('senderId', isEqualTo: widget.senderId)
          .where(Filter.or(
              Filter.and(Filter('recieverId', isEqualTo: widget.senderId),
                  Filter('senderId', isEqualTo: widget.user.id)),
              Filter.and(Filter('recieverId', isEqualTo: widget.user.id),
                  Filter('senderId', isEqualTo: widget.senderId))))
          .orderBy("dateTime", descending: true)
          .limit(1)
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
            // var data = snapshot.data!.docs;
            // print(chatsList);
            //  print("data hai vro ${data}");
            //   data.forEach((element) {
            //  print('data${element.id}');

            // _update(element.id);
            //    });

            //  print('Data: ${data}');
            final d = data.map((doc) => ChatModel.fromFirestore(doc)).toList();
            print('hello$d');
            if (d.isNotEmpty) _message = d[0];
            print('message$_message');

            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                  widget.user.photoUrl.toString(),
                ),
                // backgroundColor: Colors.transparent,
              ),
              title: Text(
                widget.user.name,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              subtitle:
                  Text(_message == null ? 'type message' : _message!.messages),
              trailing: _message == null
                  ? null
                  : _message!.read.isEmpty &&
                          _message!.senderId != widget.senderId
                      ? CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.green,
                        )
                      : Text(Apis.getLastMessageTime(
                          context: context,
                          time: _message!.dateTime!.millisecondsSinceEpoch
                              .toString())),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ChatRoom(
                    senderId: widget.senderId,
                    recieverId: widget.user.id,
                    senderName: widget.SenderName,
                    user: widget.user,
                  ),
                ));
              },
            );
        }
      },
    );
  }
}
