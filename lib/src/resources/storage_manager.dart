import 'dart:convert';

import 'package:feather/src/models/internal/geo_position.dart';
import 'package:feather/src/models/remote/weather_forecast_list_response.dart';
import 'package:feather/src/models/remote/weather_response.dart';
import 'package:feather/src/resources/app_const.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageManager {
  final Logger _logger = Logger("StorageManager");


  saveLocation(GeoPosition geoPosition) async {
    var sharedPreferences = await SharedPreferences.getInstance();
    _logger.log(Level.FINE, "Store location: $geoPosition");
    sharedPreferences.setString(
        AppConst.storageLocationKey, json.encode(geoPosition));
  }

  Future<GeoPosition> getLocation() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    String jsonData = sharedPreferences.getString(AppConst.storageLocationKey);
    _logger.log(Level.FINE, "Returned user location: $jsonData");
    if (jsonData != null) {
      return GeoPosition.fromJson(json.decode(jsonData));
    } else {
      return null;
    }
  }

  saveWeather(WeatherResponse response) async {
    var sharedPreferences = await SharedPreferences.getInstance();
    _logger.log(Level.FINE, "Store weather" + json.encode(response));
    sharedPreferences.setString(AppConst.storageWeatherKey, json.encode(response));
  }


  Future<WeatherResponse> getWeather() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    String jsonData = sharedPreferences.getString(AppConst.storageWeatherKey);
    _logger.log(Level.FINE, "Returned weather data: $jsonData");
    if (jsonData != null) {
      return WeatherResponse.fromJson(jsonDecode(jsonData));
    } else {
      return null;
    }
  }

  saveWeatherForecast(WeatherForecastListResponse response) async {
    var sharedPreferences = await SharedPreferences.getInstance();
    _logger.log(Level.FINE, "Store weather forecast" + json.encode(response));
    sharedPreferences.setString(AppConst.storageWeatherForecastKey, json.encode(response));
  }

  Future<WeatherForecastListResponse> getWeatherForecast() async{
    var sharedPreferences = await SharedPreferences.getInstance();
    String jsonData = sharedPreferences.getString(AppConst.storageWeatherForecastKey);
    _logger.log(Level.FINE, "Returned weather forecast data: $jsonData");
    if (jsonData != null) {
      return WeatherForecastListResponse.fromJson(jsonDecode(jsonData));
    } else {
      return null;
    }
  }



}
