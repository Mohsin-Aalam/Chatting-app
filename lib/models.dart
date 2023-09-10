import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

class ChatModel {
  String title;
  String subtitle;
  Image image;
  String dayTime;
  int chatCount;
  ChatModel({
    required this.chatCount,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.dayTime,
  });
}
