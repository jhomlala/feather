import 'package:feather/src/data/model/remote/clouds.dart';
import 'package:feather/src/data/model/remote/main_weather_data.dart';
import 'package:feather/src/data/model/remote/overall_weather_data.dart';
import 'package:feather/src/data/model/remote/rain.dart';
import 'package:feather/src/data/model/remote/wind.dart';

class WeatherForecastResponse {
  final MainWeatherData? mainWeatherData;
  final List<OverallWeatherData>? overallWeatherData;
  final Clouds? clouds;
  final Wind? wind;
  final DateTime dateTime;
  final Rain? rain;
  final Rain? snow;

  WeatherForecastResponse(this.mainWeatherData, this.overallWeatherData,
      this.clouds, this.wind, this.dateTime, this.rain, this.snow);

  WeatherForecastResponse.fromJson(Map<String, dynamic> json)
      : overallWeatherData = (json["weather"] as List)
            .map((dynamic data) =>
                OverallWeatherData.fromJson(data as Map<String, dynamic>))
            .toList(),
        mainWeatherData =
            MainWeatherData.fromJson(json["main"] as Map<String, dynamic>),
        wind = Wind.fromJson(json["wind"] as Map<String, dynamic>),
        clouds = Clouds.fromJson(json["clouds"] as Map<String, dynamic>),
        dateTime = DateTime.parse(json["dt_txt"] as String),
        rain = _getRain(json["rain"]),
        snow = _getRain(json["snow"]);

  static Rain _getRain(dynamic json) {
    if (json == null) {
      return Rain(0);
    } else {
      return Rain.fromJson(json as Map<String, dynamic>);
    }
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        "weather": overallWeatherData,
        "main": mainWeatherData,
        "clouds": clouds!.toJson(),
        "wind": wind!.toJson(),
        "dt_txt": dateTime.toIso8601String(),
        "rain": rain!.toJson(),
        "snow": snow!.toJson()
      };

  @override
  String toString() {
    return toJson().toString();
  }
}
