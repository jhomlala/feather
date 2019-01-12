class TypesHelper {
  static double getDouble(dynamic val) {
    if (val is double) {
      return val;
    } else if (val is int) {
      return val.toDouble();
    } else {
      return val;
    }
  }

  static String formatTemperature(double temperature){
    temperature = temperature.ceil().toDouble();
    return temperature.toStringAsFixed(0) + "°C";
  }
}
