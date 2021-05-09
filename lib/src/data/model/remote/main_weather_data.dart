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
      : temp = TypesHelper.toDouble(json["temp"] as num?),
        pressure = TypesHelper.toDouble(json["pressure"] as num?),
        humidity = TypesHelper.toDouble(json["humidity"] as num?),
        tempMin = TypesHelper.toDouble(json["temp_min"] as num?),
        tempMax = TypesHelper.toDouble(json["temp_max"] as num?),
        pressureSeaLevel = TypesHelper.toDouble(json["sea_level"] as num?),
        pressureGroundLevel =
            TypesHelper.toDouble(json["ground_level"] as num?);

  Map<String, dynamic> toJson() => <String, dynamic>{
        "temp": temp,
        "pressure": pressure,
        "humidity": humidity,
        "temp_min": tempMin,
        "temp_max": tempMax,
        "sea_level": pressureSeaLevel,
        "ground_level": pressureGroundLevel
      };
}
