import 'package:dio/dio.dart';
import 'package:feather/src/data/model/internal/application_error.dart';
import 'package:feather/src/data/model/remote/weather_forecast_list_response.dart';
import 'package:feather/src/data/model/remote/weather_response.dart';
import 'package:feather/src/resources/config/application_config.dart';
import 'package:feather/src/utils/app_logger.dart';
import 'package:flutter/material.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
// ignore: argument_type_not_assignable

class WeatherApiProvider {
  final String _apiBaseUrl = "api.openweathermap.org";
  final String _apiPath = "/data/2.5";
  final String _apiWeatherEndpoint = "/weather";
  final String _apiWeatherForecastEndpoint = "/forecast";
  final Dio _dio = Dio();

  Future<WeatherResponse> fetchWeather(
      double? latitude, double? longitude) async {
    try {
      final Uri uri = _buildUri(_apiWeatherEndpoint, latitude, longitude);
      final Response<Map<String, dynamic>> response =
          await _dio.get(uri.toString());
      if (response.statusCode == 200) {
        return WeatherResponse.fromJson(response.data!);
      } else {
        return WeatherResponse.withErrorCode(ApplicationError.apiError);
      }
    } catch (exc, stacktrace) {
      Log.e("Exception occurred: $exc stack trace: ${stacktrace.toString()}");

      return WeatherResponse.withErrorCode(ApplicationError.connectionError);
    }
  }

  Future<WeatherForecastListResponse> fetchWeatherForecast(
      double? latitude, double? longitude) async {
    try {
      final Uri uri =
          _buildUri(_apiWeatherForecastEndpoint, latitude, longitude);
      final Response<Map<String, dynamic>> response =
          await _dio.get(uri.toString());
      if (response.statusCode == 200) {
        return WeatherForecastListResponse.fromJson(response.data!);
      } else {
        return WeatherForecastListResponse.withErrorCode(
            ApplicationError.apiError);
      }
    } catch (exc, stackTrace) {
      Log.e("Exception occurred: $exc $stackTrace");
      return WeatherForecastListResponse.withErrorCode(
          ApplicationError.connectionError);
    }
  }

  Uri _buildUri(String endpoint, double? latitude, double? longitude) {
    return Uri(
      scheme: "https",
      host: _apiBaseUrl,
      path: "$_apiPath$endpoint",
      queryParameters: <String, dynamic>{
        "lat": latitude.toString(),
        "lon": longitude.toString(),
        "apiKey": ApplicationConfig.apiKey,
        "units": "metric"
      },
    );
  }

  void setupInterceptors() {
    _dio.interceptors.add(PrettyDioLogger());
  }

  @visibleForTesting
  Dio get dio => _dio;
}
