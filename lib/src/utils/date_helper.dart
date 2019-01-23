import 'package:intl/intl.dart';

class DateHelper{
  static String formatDateTime(DateTime dateTime){
    return DateFormat('dd/MM/yyyy').format(DateTime.now());
  }

  static int getCurrentTime(){
    return DateTime.now().millisecondsSinceEpoch;
  }
}