import 'package:logger/logger.dart';

class Log {
  static final Logger _logger = Logger(
    printer: PrefixPrinter(
      PrettyPrinter(colors: false, methodCount: 0),
    ),
  );

  static void i(dynamic message) {
    _logger.i(message);
  }

  static void d(dynamic message) {
    _logger.d(message);
  }

  static void e(dynamic message, {dynamic error, StackTrace? stackTrace}) {
    _logger.e(message, error, stackTrace);
  }
}
