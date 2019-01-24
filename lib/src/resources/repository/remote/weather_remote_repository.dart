import 'package:feather/src/models/remote/weather_forecast_list_response.dart';
import 'package:feather/src/models/remote/weather_response.dart';
import 'package:feather/src/resources/repository/remote/weather_api_provider.dart';

class WeatherRemoteRepository{
  final weatherApiProvider = WeatherApiProvider();

  static final WeatherRemoteRepository _instance = WeatherRemoteRepository._internal();
  WeatherRemoteRepository._internal();

  factory WeatherRemoteRepository(){
    return _instance;
  }

  Future<WeatherResponse> fetchWeather(double latitude,double longitude){
    return weatherApiProvider.fetchWeather(latitude,longitude);
  }

  Future<WeatherForecastListResponse> fetchWeatherForecast(double latitude, double longitude){
    return weatherApiProvider.fetchWeatherForecast(latitude, longitude);
  }

}