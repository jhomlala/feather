import 'package:feather/src/utils/types_helper.dart';

class MainWeatherData {
  final double temp;
  final double pressure;
  final double humidity;
  final double tempMin;
  final double tempMax;
  final double pressureSeaLevel;
  final double pressureGroundLevel;

  MainWeatherData(this.temp, this.pressure, this.humidity, this.tempMin,
      this.tempMax, this.pressureSeaLevel, this.pressureGroundLevel);

  MainWeatherData.fromJson(Map<String, dynamic> json)
      : temp = TypesHelper.getDouble(json["temp"]),
        pressure = TypesHelper.getDouble(json["pressure"]),
        humidity = TypesHelper.getDouble(json["humidity"]),
        tempMin = TypesHelper.getDouble(json["temp_min"]),
        tempMax = TypesHelper.getDouble(json["temp_max"]),
        pressureSeaLevel = TypesHelper.getDouble(json["sea_level"]),
        pressureGroundLevel = TypesHelper.getDouble(json["ground_level"]);

  Map<String, dynamic> toJson() => {
        "temp": temp,
        "pressure": pressure,
        "humidity": humidity,
        "temp_min": tempMin,
        "temp_max": tempMax,
        "sea_level": pressureSeaLevel,
        "ground_level": pressureGroundLevel
      };
}
