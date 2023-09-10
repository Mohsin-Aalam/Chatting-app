import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatesUtils {
  String dateFormatYMDKKMM() {
    DateTime now = DateTime.now();

    String formattedDate = DateFormat('yyyy-MM-dd , hh:mm').format(now);
    return formattedDate;
  }

  String compareTimesForSevenDays(String date) {
    DateTime dt =
        DateTime.fromMicrosecondsSinceEpoch(int.parse(date.toString()))
            .toLocal();

    final todayDate = DateTime.now();

    final today = DateTime(todayDate.year, todayDate.month, todayDate.day);
    final yesterday =
        DateTime(todayDate.year, todayDate.month, todayDate.day - 1);
    final dayBeforeYesterday =
        DateTime(todayDate.year, todayDate.month, todayDate.day - 2);

    String difference = '';

    final aDate = DateTime(dt.year, dt.month, dt.day);

    if (aDate == today) {
      return 'Today';
    } else if (aDate == yesterday) {
      difference = "Yesterday";
    } else if (aDate == dayBeforeYesterday) {
      difference = DateFormat('E').format(dt).toString();
    } else if (todayDate.difference(dt).inDays >= 3 &&
        todayDate.difference(dt).inDays < 4) {
      difference = DateFormat('E').format(dt).toString();
    } else if (todayDate.difference(dt).inDays >= 4 &&
        todayDate.difference(dt).inDays < 5) {
      difference = DateFormat('E').format(dt).toString();
    } else if (todayDate.difference(dt).inDays >= 5 &&
        todayDate.difference(dt).inDays < 6) {
      difference = DateFormat('E').format(dt).toString();
    } else if (todayDate.difference(dt).inDays >= 6 &&
        todayDate.difference(dt).inDays < 7) {
      difference = DateFormat('E').format(dt).toString();
    } else {
      difference =
          "${DateFormat.d().format(dt)} ${DateFormat.MMM().format(dt)} ${DateFormat.y().format(dt)}";
    }
    return difference;
  }

  String daysAgo(String date) {
    DateTime dt =
        DateTime.fromMicrosecondsSinceEpoch(int.parse(date.toString()))
            .toLocal();

    final todayDate = DateTime.now();

    final today = DateTime(todayDate.year, todayDate.month, todayDate.day);
    final yesterday =
        DateTime(todayDate.year, todayDate.month, todayDate.day - 1);
    final dayBeforeYesterday =
        DateTime(todayDate.year, todayDate.month, todayDate.day - 2);

    String difference = '';

    final aDate = DateTime(dt.year, dt.month, dt.day);

    if (aDate == today) {
      return 'Today';
    } else if (aDate == yesterday) {
      difference = "1d ago";
    } else if (aDate == dayBeforeYesterday) {
      difference = '2d ago';
    } else if (todayDate.difference(dt).inDays >= 3 &&
        todayDate.difference(dt).inDays < 4) {
      difference = '3d ago';
    } else if (todayDate.difference(dt).inDays >= 4 &&
        todayDate.difference(dt).inDays < 5) {
      difference = '4d ago';
    } else if (todayDate.difference(dt).inDays >= 5 &&
        todayDate.difference(dt).inDays < 6) {
      difference = '5d ago';
    } else if (todayDate.difference(dt).inDays >= 6 &&
        todayDate.difference(dt).inDays < 7) {
      difference = '6 ago';
    } else {
      difference =
          "${DateFormat.d().format(dt)} ${DateFormat.MMM().format(dt)} ${DateFormat.y().format(dt)}";
    }
    return difference;
  }

  String timesAndMinutesAgo(String timestamp) {
    var now = DateTime.now();
    var format = DateFormat('HH:mm a');
    var date = DateTime.fromMicrosecondsSinceEpoch(int.parse(timestamp));
    var diff = now.difference(date);
    var time = '';

    print(diff.inMinutes);

    if (diff.inHours <= 1) {
      time = diff.inMinutes.toString() + "m ago";
    } else if (diff.inHours <= 24) {
      time = diff.inHours.toString() + "h ago";
    } else if (diff.inDays > 0 && diff.inDays < 7) {
      if (diff.inDays == 1) {
        time = diff.inDays.toString() + ' DAY AGO';
      } else {
        time = diff.inDays.toString() + ' DAYS AGO';
      }
    } else {
      if (diff.inDays == 7) {
        time = (diff.inDays / 7).floor().toString() + ' WEEK AGO';
      } else {
        time = (diff.inDays / 7).floor().toString() + ' WEEKS AGO';
      }
    }

    return time;
  }
}
