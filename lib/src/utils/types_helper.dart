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


  static String formatTemperature({double temperature, int positions = 0, round = true}){
    if (round){
      temperature = temperature.floor().toDouble();
    }
    return temperature.toStringAsFixed(positions) + "°C";
  }
}
