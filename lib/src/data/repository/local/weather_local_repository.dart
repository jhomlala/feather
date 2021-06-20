import 'package:feather/src/data/model/internal/geo_position.dart';
import 'package:feather/src/data/model/remote/weather_forecast_list_response.dart';
import 'package:feather/src/data/model/remote/weather_response.dart';
import 'package:feather/src/data/repository/local/storage_manager.dart';

class WeatherLocalRepository {
  final StorageManager _storageManager;

  WeatherLocalRepository(this._storageManager);

  Future saveLocation(GeoPosition geoPosition) async {
    await _storageManager.saveLocation(geoPosition);
  }

  Future<GeoPosition?> getLocation() async {
    return _storageManager.getLocation();
  }

  Future saveWeather(WeatherResponse response) async {
    await _storageManager.saveWeather(response);
  }

  Future<WeatherResponse?> getWeather() async {
    return _storageManager.getWeather();
  }

  Future saveWeatherForecast(WeatherForecastListResponse response) async {
    await _storageManager.saveWeatherForecast(response);
  }

  Future<WeatherForecastListResponse?> getWeatherForecast() async {
    return _storageManager.getWeatherForecast();
  }
}
