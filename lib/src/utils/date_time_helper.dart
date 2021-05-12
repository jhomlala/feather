import 'package:intl/intl.dart';

class DateTimeHelper{
  static const int dayAsMs = 86400000;
  static const int hoursAsMs = 3600000;
  static const int minutesAsMs = 60000;
  static const int secondsAsMs = 1000;


  static String formatDateTime(DateTime dateTime){
    return DateFormat('dd/MM/yyyy').format(DateTime.now());
  }

  static int getCurrentTime(){
    return DateTime.now().millisecondsSinceEpoch;
  }

  static String getTimeFormatted(DateTime dateTime) {
    final String hourFormatted = formatTimeUnit(dateTime.hour);
    final String minuteFormatted = formatTimeUnit(dateTime.minute);
    return "$hourFormatted:$minuteFormatted";
  }

  static String formatTimeUnit(int timeUnit){
    return timeUnit < 10 ? "0$timeUnit" : "$timeUnit";
  }

  static String formatTime(int time) {
    final int hours = (time / hoursAsMs).floor();
    final int minutes = ((time - hours * hoursAsMs) / minutesAsMs).floor();
    final int seconds =
    ((time - hours * hoursAsMs - minutes * minutesAsMs) / secondsAsMs)
        .floor();
    String text = "";
    if (hours > 0) {
      text += "${formatTimeUnit(hours)}h ";
    }
    if (minutes > 0) {
      text += "${formatTimeUnit(minutes)}m ";
    }
    if (seconds >= 0) {
      text += "${formatTimeUnit(seconds)}s";
    }
    return text;
  }
  
}