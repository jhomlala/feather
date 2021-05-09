import 'package:feather/src/utils/app_logger.dart';

class TypesHelper {
  static double toDouble(num? val) {
    try {
      if (val == null) {
        return 0;
      }
      if (val is double) {
        return val;
      } else {
        return val.toDouble();
      }
    } catch (exception, stackTrace) {
      Log.e("toDouble failed: $exception $stackTrace");
      return 0;
    }
  }
}
