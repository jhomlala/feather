import 'package:feather/src/data/model/remote/weather_forecast_list_response.dart';
import 'package:feather/src/data/model/remote/weather_response.dart';
import 'package:feather/src/data/repository/remote/weather_api_provider.dart';

import '../../model/weather_utils.dart';

class FakeWeatherApiProvider extends WeatherApiProvider {
  @override
  Future<WeatherResponse> fetchWeather(
      double? latitude, double? longitude) async {
    return WeatherUtils.getWeather();
  }

  @override
  Future<WeatherForecastListResponse> fetchWeatherForecast(
      double? latitude, double? longitude) async {
    return WeatherUtils.getWeatherForecastListResponse();
  }
}
