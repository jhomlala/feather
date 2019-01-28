import 'package:logging/logging.dart';

class TypesHelper {
  static final _logger = new Logger("TypesHelper");
  static double toDouble(num val) {
    try {
      if (val == null){
        return 0;
      }
      if (val is double) {
        return val;
      } else {
        return val.toDouble();
      }
    } catch (exc,stackTrace){
      _logger.warning("Error occured $exc stackTrace: $stackTrace");
      return 0;
    }
  }
}
