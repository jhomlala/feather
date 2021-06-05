import 'package:feather/src/data/model/internal/geo_position.dart';
import 'package:feather/src/data/model/internal/unit.dart';
import 'package:feather/src/data/model/remote/weather_forecast_list_response.dart';
import 'package:feather/src/data/model/remote/weather_response.dart';
import 'package:feather/src/data/repository/local/storage_manager.dart';

import '../../model/weather_utils.dart';
import 'fake_storage_provider.dart';

///Fake class which mocks StorageManager
class FakeStorageManager extends StorageManager {
  Unit _unit = Unit.imperial;
  int _refreshTime = 0;
  int _lastRefreshTime = 0;
  GeoPosition _geoPosition = GeoPosition(0, 0);
  WeatherResponse? _weatherResponse = WeatherUtils.getWeather();
  WeatherForecastListResponse? _weatherForecastListResponse =
      WeatherUtils.getWeatherForecastListResponse();

  FakeStorageManager() : super(FakeStorageProvider());

  @override
  Future<Unit> getUnit() async {
    return _unit;
  }

  @override
  Future<bool> saveUnit(Unit unit) async {
    _unit = unit;
    return true;
  }

  @override
  Future<bool> saveRefreshTime(int refreshTime) async {
    _refreshTime = refreshTime;
    return true;
  }

  @override
  Future<int> getRefreshTime() async {
    return _refreshTime;
  }

  @override
  Future<bool> saveLastRefreshTime(int lastRefreshTime) async {
    _lastRefreshTime = lastRefreshTime;
    return true;
  }

  @override
  Future<int> getLastRefreshTime() async {
    return _lastRefreshTime;
  }

  @override
  Future<bool> saveLocation(GeoPosition geoPosition) async {
    _geoPosition = geoPosition;
    return true;
  }

  @override
  Future<GeoPosition?> getLocation() async {
    return _geoPosition;
  }

  @override
  Future<bool> saveWeather(WeatherResponse weatherResponse) async {
    _weatherResponse = weatherResponse;
    return true;
  }

  @override
  Future<WeatherResponse?> getWeather() async {
    return _weatherResponse;
  }

  @override
  Future<bool> saveWeatherForecast(
      WeatherForecastListResponse weatherForecastListResponse) async {
    _weatherForecastListResponse = weatherForecastListResponse;
    return true;
  }

  @override
  Future<WeatherForecastListResponse?> getWeatherForecast() async {
    return _weatherForecastListResponse;
  }

  // ignore: avoid_setters_without_getters
  set weatherResponse(WeatherResponse? value) {
    _weatherResponse = value;
  }
// ignore: avoid_setters_without_getters
  set weatherForecastListResponse(WeatherForecastListResponse? value) {
    _weatherForecastListResponse = value;
  }
}
