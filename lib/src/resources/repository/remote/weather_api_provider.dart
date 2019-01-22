import 'dart:convert';

import 'package:feather/src/models/internal/application_error.dart';
import 'package:feather/src/models/remote/weather_forecast_list_response.dart';
import 'package:feather/src/models/remote/weather_response.dart';
import 'package:feather/src/resources/config/application_config.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

class WeatherApiProvider {
  final _logger = new Logger("WeatherApiProvider");

  Future<WeatherResponse> fetchWeather(
      double latitude, double longitude) async {
    try {
      String url = buildUrl(
          ApplicationConfig.apiWeatherEndpoint,
          List.of([
            "lat=" + latitude.toString(),
            "lon=" + longitude.toString(),
            "units=metric"
          ]));

      _logger.log(Level.INFO, "Fetch weather with url: " + url);
      final response = await http.get(url);
      _logger.log(Level.INFO,
          "Received status code: " + response.statusCode.toString());
      if (response.statusCode == 200) {
        return WeatherResponse.fromJson(json.decode(response.body));
      } else {
        return WeatherResponse.withErrorCode(ApplicationError.apiError);
      }
    } catch (exc, stacktrace) {
      _logger.log(Level.INFO,
          "Exception occured: $exc stack trace: ${stacktrace.toString()}");

      return WeatherResponse.withErrorCode(ApplicationError.connectionError);
    }
  }

  Future<WeatherForecastListResponse> fetchWeatherForecast(
      double latitude, double longitude) async {
    try {
      String url = buildUrl(
          ApplicationConfig.apiWeatherForecastEndpoint,
          List.of([
            "lat=" + latitude.toString(),
            "lon=" + longitude.toString(),
            "units=metric"
          ]));
      _logger.log(Level.INFO, "Fetch weather forecast with url: " + url);
      final response = await http.get(url);
      _logger.log(Level.INFO,
          "Received status code: " + response.statusCode.toString());
      if (response.statusCode == 200) {
        return WeatherForecastListResponse.fromJson(json.decode(response.body));
      } else {
        return WeatherForecastListResponse.withErrorCode(
            ApplicationError.apiError);
      }
    } catch (exc) {
      _logger.log(Level.INFO, "Exception occured: " + exc.toString());
      return WeatherForecastListResponse.withErrorCode(
          ApplicationError.connectionError);
    }
  }

  String buildUrl(String endpoint, List<String> queryParameters) {
    var buffer = StringBuffer();
    buffer.write(ApplicationConfig.apiUrl);
    buffer.write(endpoint);
    buffer.write("?");
    for (String queryParameter in queryParameters) {
      buffer.write(queryParameter);
      buffer.write("&");
    }
    buffer.write("apiKey=" + ApplicationConfig.apiKey);
    return buffer.toString();
  }
}
