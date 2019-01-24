import 'package:intl/intl.dart';

class DateTimeHelper{
  static final int dayAsMs = 86400000;
  static final int hoursAsMs = 3600000;
  static final int minutesAsMs = 60000;
  static final int secondsAsMs = 1000;


  static String formatDateTime(DateTime dateTime){
    return DateFormat('dd/MM/yyyy').format(DateTime.now());
  }

  static int getCurrentTime(){
    return DateTime.now().millisecondsSinceEpoch;
  }

  static String getTimeFormatted(DateTime dateTime) {
    String hourFormatted = formatTimeUnit(dateTime.hour);
    String minuteFormatted = formatTimeUnit(dateTime.minute);
    return "$hourFormatted:$minuteFormatted";
  }

  static String formatTimeUnit(int timeUnit){
    return timeUnit < 10 ? "0$timeUnit" : "$timeUnit";
  }

  static String formatTime(int time) {
    int hours = (time / (hoursAsMs)).floor();
    int minutes = ((time - hours * hoursAsMs) / minutesAsMs).floor();
    int seconds =
    ((time - hours * hoursAsMs - minutes * minutesAsMs) / secondsAsMs)
        .floor();
    String text = "";
    if (hours > 0) {
      text += formatTimeUnit(hours) + "h ";
    }
    if (minutes > 0) {
      text += formatTimeUnit(minutes) + "m ";
    }
    if (seconds >= 0) {
      text += formatTimeUnit(seconds) + "s";
    }
    return text;
  }
  
}