import 'dart:convert';

import 'package:feather/src/models/remote/city.dart';
import 'package:feather/src/models/remote/weather_forecast_response.dart';

class WeatherForecastListResponse {
  final List<WeatherForecastResponse> list;
  final City city;
  String _errorCode;

  WeatherForecastListResponse(this.list, this.city);

  WeatherForecastListResponse.fromJson(Map<String, dynamic> json)
      : list = (json["list"] as List)
            .map((i) => new WeatherForecastResponse.fromJson(i))
            .toList(),
        city = City.fromJson(json["city"]);

  Map<String, dynamic> toJson() => {"list": list, "city": city};

  

  static WeatherForecastListResponse withErrorCode(String errorCode) {
    WeatherForecastListResponse response =
        new WeatherForecastListResponse(null, null);
    response._errorCode = errorCode;
    return response;
  }

  String get errorCode => _errorCode;


}
