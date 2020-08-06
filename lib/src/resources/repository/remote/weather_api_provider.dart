import 'package:dio/dio.dart';
import 'package:feather/src/models/internal/application_error.dart';
import 'package:feather/src/models/remote/weather_forecast_list_response.dart';
import 'package:feather/src/models/remote/weather_response.dart';
import 'package:feather/src/resources/config/application_config.dart';
import 'package:logging/logging.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class WeatherApiProvider {
  final String _apiBaseUrl = "api.openweathermap.org";
  final String _apiPath = "/data/2.5";
  final String _apiWeatherEndpoint = "/weather";
  final String _apiWeatherForecastEndpoint = "/forecast";
  final Logger _logger = new Logger("WeatherApiProvider");
  final Dio _dio = Dio();

  static final WeatherApiProvider _instance = WeatherApiProvider._internal();

  WeatherApiProvider._internal() {
    setupInterceptors();
  }

  factory WeatherApiProvider() {
    return _instance;
  }

  Future<WeatherResponse> fetchWeather(
      double latitude, double longitude) async {
    try {
      Uri uri = buildUri(_apiWeatherEndpoint, latitude, longitude);
      Response response = await _dio.get(uri.toString());
      if (response.statusCode == 200) {
        return WeatherResponse.fromJson(response.data);
      } else {
        return WeatherResponse.withErrorCode(ApplicationError.apiError);
      }
    } catch (exc, stacktrace) {
      _logger.log(Level.INFO,
          "Exception occured: $exc stack trace: ${stacktrace.toString()}");

      return WeatherResponse.withErrorCode(ApplicationError.connectionError);
    }
  }

  Uri buildUri(String endpoint, double latitude, double longitude) {
    return Uri(
        scheme: "https",
        host: _apiBaseUrl,
        path: "$_apiPath$endpoint",
        queryParameters: {
          "lat": latitude.toString(),
          "lon": longitude.toString(),
          "apiKey": ApplicationConfig.apiKey,
          "units": "metric"
        });
  }

  Future<WeatherForecastListResponse> fetchWeatherForecast(
      double latitude, double longitude) async {
    try {
      Uri uri = buildUri(_apiWeatherForecastEndpoint, latitude, longitude);
      Response response = await _dio.get(uri.toString());
      if (response.statusCode == 200) {
        return WeatherForecastListResponse.fromJson(response.data);
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

  void setupInterceptors() {
    _dio.interceptors.add(PrettyDioLogger());
  }
}
