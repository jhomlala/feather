import 'package:feather/src/models/remote/weather_forecast_list_response.dart';
import 'package:feather/src/models/remote/weather_response.dart';
import 'package:feather/src/resources/weather_api_provider.dart';

class WeatherRepository{
  final weatherApiProvider = WeatherApiProvider();

  Future<WeatherResponse> fetchWeather(double latitude,double longitude){
    return weatherApiProvider.fetchWeather(latitude,longitude);
  }

  Future<WeatherForecastListResponse> fetchWeatherForecast(double latitude, double longitude){
    return weatherApiProvider.fetchWeatherForecast(latitude, longitude);
  }

}