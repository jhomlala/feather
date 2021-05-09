import 'package:feather/src/data/model/remote/weather_forecast_list_response.dart';
import 'package:feather/src/data/model/remote/weather_response.dart';
import 'package:feather/src/data/repository/remote/weather_api_provider.dart';

class WeatherRemoteRepository {
  final _weatherApiProvider = WeatherApiProvider();

  Future<WeatherResponse> fetchWeather(double? latitude, double? longitude) {
    return _weatherApiProvider.fetchWeather(latitude, longitude);
  }

  Future<WeatherForecastListResponse> fetchWeatherForecast(
      double? latitude, double? longitude) {
    return _weatherApiProvider.fetchWeatherForecast(latitude, longitude);
  }
}
