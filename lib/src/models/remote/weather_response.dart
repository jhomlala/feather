import 'dart:convert';

import 'package:feather/src/models/remote/clouds.dart';
import 'package:feather/src/models/remote/coord.dart';
import 'package:feather/src/models/remote/main_weather_data.dart';
import 'package:feather/src/models/remote/overall_weather_data.dart';
import 'package:feather/src/models/remote/system.dart';
import 'package:feather/src/models/remote/wind.dart';

class WeatherResponse {
  final Coordinates cord;
  final List<OverallWeatherData> overallWeatherData;
  final MainWeatherData mainWeatherData;
  final Wind wind;
  final Clouds clouds;
  final System system;
  final int id;
  final String name;
  final int cod;
  final String station;
  String _errorCode;

  WeatherResponse(
      {this.cord,
      this.overallWeatherData,
      this.mainWeatherData,
      this.wind,
      this.clouds,
      this.system,
      this.id,
      this.name,
      this.cod,
      this.station});

  WeatherResponse.fromJson(Map<String, dynamic> json)
      : cord = Coordinates.fromJson(json["coord"]),
        system = System.fromJson(json["sys"]),
        overallWeatherData = (json["weather"] as List)
            .map((i) => OverallWeatherData.fromJson(i))
            .toList(),
        mainWeatherData = MainWeatherData.fromJson(json["main"]),
        wind = Wind.fromJson(json["wind"]),
        clouds = Clouds.fromJson(json["clouds"]),
        id = json["id"],
        name = json["name"],
        cod = json["cod"],
        station = json["station"];

  Map<String, dynamic> toJson() => {
        "coord": cord,
        "sys": system,
        "weather": overallWeatherData,
        "main": mainWeatherData,
        "wind": wind,
        "clouds": clouds,
        "id": id,
        "name": name,
        "cod": cod,
        "station": station,
      };

  static WeatherResponse withErrorCode(String errorCode) {
    WeatherResponse response = new WeatherResponse();
    response._errorCode = errorCode;
    return response;
  }

  String get errorCode => _errorCode;
}
