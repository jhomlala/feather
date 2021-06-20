import 'package:feather/src/data/model/internal/application_error.dart';
import 'package:feather/src/data/model/remote/weather_forecast_list_response.dart';
import 'package:feather/src/data/model/remote/weather_response.dart';
import 'package:feather/src/data/repository/remote/weather_api_provider.dart';

import '../../model/weather_utils.dart';

class FakeWeatherApiProvider extends WeatherApiProvider {
  ApplicationError? _weatherError;
  ApplicationError? _weatherForecastError;

  @override
  Future<WeatherResponse> fetchWeather(
      double? latitude, double? longitude) async {
    if (_weatherError != null) {
      return WeatherResponse.withErrorCode(_weatherError!);
    }
    return WeatherUtils.getWeather();
  }

  @override
  Future<WeatherForecastListResponse> fetchWeatherForecast(
      double? latitude, double? longitude) async {
    if (_weatherForecastError != null) {
      return WeatherForecastListResponse.withErrorCode(_weatherForecastError!);
    }
    return WeatherUtils.getWeatherForecastListResponse();
  }

  // ignore: avoid_setters_without_getters
  set weatherForecastError(ApplicationError value) {
    _weatherForecastError = value;
  }

  // ignore: avoid_setters_without_getters
  set weatherError(ApplicationError value) {
    _weatherError = value;
  }
}
