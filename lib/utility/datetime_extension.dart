import 'package:flutter/material.dart';
import 'package:time_range_picker/time_range_picker.dart';

extension TimeRangeExtension on TimeRange {

  String toStringRange(){
    String strTimeRange;
    TimeOfDay fromTime;
    TimeOfDay toTime;
    String strFromTime;
    String strToTime;

    fromTime = startTime;
    toTime = endTime;

    strFromTime = '${fromTime.hour.toString().padLeft(2, '0')}:${fromTime.minute.toString().padLeft(2, '0')}';
    strToTime = '${toTime.hour.toString().padLeft(2, '0')}:${toTime.minute.toString().padLeft(2, '0')}';

    strTimeRange = "$strFromTime - $strToTime";

    return strTimeRange;
  }

}

extension TimeOfDayExtension on TimeOfDay {

  TimeOfDay addMinutes(int minutes) {
    if (minutes == 0) {
      return this;
    } else {
      int mofd = hour * 60 + minute;
      int newMofd = ((minutes % 1440) + mofd + 1440) % 1440;
      if (mofd == newMofd) {
        return this;
      } else {
        int newHour = newMofd ~/ 60;
        int newMinute = newMofd % 60;
        return TimeOfDay(hour: newHour, minute: newMinute);
      }
    }
  }

  String toStringTimeOfDay() {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

}