import 'package:flutter/material.dart';

class ClockController {
  DateTime clockTime = DateTime.now();
  String textOfResultWidget = '';
  Color colorOfResultWidget = Colors.green;

  void changeTime(DateTime newTime) {
    clockTime = newTime;
  }

  bool checkEqualityTime(DateTime otherTime) {
    return (otherTime.hour == clockTime.hour &&
        otherTime.minute == clockTime.minute);
  }

  DateTime differenceInTime(DateTime otherTime) {
    DateTime res;
    Duration differenceInTime = otherTime.difference(clockTime);
    int hoursMiss = (differenceInTime.inHours);
    int minutesMiss = (differenceInTime.inMinutes % 60);
    res = DateTime(0, 0, 0, hoursMiss, minutesMiss);
    return res;
  }
}
