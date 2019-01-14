import 'dart:convert';

import 'package:feather/src/models/remote/weather_forecast_list_response.dart';
import 'package:feather/src/models/remote/weather_response.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

class WeatherApiProvider {
  final _apiBaseAddress = "https://api.openweathermap.org/data/2.5";
  final _weatherEndpoint = "/weather";
  final _weatherForecastEndpoint = "/forecast";
  final _apiKey = "2b557cc4c291a6293e22bc44e49231d8";
  final _logger = new Logger("WeatherApiProvider");

  Future<WeatherResponse> fetchWeather(
      double latitude, double longitude) async {
    try {
      String url = _apiBaseAddress +
          _weatherEndpoint +
          "?lat=" +
          latitude.toString() +
          "&lon=" +
          longitude.toString() +
          "&units=metric";

      url = _addApiKey(url);

      _logger.log(Level.INFO,"Fetch weather with url: " + url);
      final response = await http.get(url);
      _logger.log(Level.INFO,"Received status code: " + response.statusCode.toString());
      if (response.statusCode == 200) {
        return WeatherResponse(json.decode(response.body));
      } else {
        return WeatherResponse.withErrorCode("ERROR_API_ERROR");
      }
    } catch (exc, stacktrace){
      _logger.log(Level.INFO,"Exception occured: " + stacktrace.toString());
      return WeatherResponse.withErrorCode("ERROR_CONNECTION_ERROR");
    }
  }

  Future<WeatherForecastListResponse> fetchWeatherForecast(
      double latitude, double longitude) async {
    try {
      String url = _apiBaseAddress +
          _weatherForecastEndpoint +
          "?lat=" +
          latitude.toString() +
          "&lon=" +
          longitude.toString() +
          "&units=metric";
      url = _addApiKey(url);
      _logger.log(Level.INFO, "Fetch weather forecast with url: " + url);
      final response = await http.get(url);
      _logger.log(Level.INFO, "Received status code: " + response.statusCode.toString());
      if (response.statusCode == 200) {
        return WeatherForecastListResponse(json.decode(response.body));
      } else {
        return WeatherForecastListResponse.withErrorCode("ERROR_API_ERROR");
      }
    } catch (exc){
      _logger.log(Level.INFO,"Exception occured: " + exc.toString());
      return WeatherForecastListResponse.withErrorCode("ERROR_CONNECTION_ERROR");
    }
  }

  String _addApiKey(String url) {
    return url + "&apiKey=" + _apiKey;
  }
}
