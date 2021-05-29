import 'package:feather/src/data/model/internal/geo_position.dart';
import 'package:feather/src/data/model/internal/unit.dart';
import 'package:feather/src/data/model/remote/city.dart';
import 'package:feather/src/data/model/remote/weather_forecast_list_response.dart';
import 'package:feather/src/data/model/remote/weather_response.dart';
import 'package:feather/src/data/repository/local/storage_manager.dart';

///Fake class which mocks StorageManager
class FakeStorageManager extends StorageManager {
  Unit _unit = Unit.imperial;
  int _refreshTime = 0;
  int _lastRefreshTime = 0;
  GeoPosition _geoPosition = GeoPosition(0, 0);
  WeatherResponse _weatherResponse = WeatherResponse();
  WeatherForecastListResponse _weatherForecastListResponse =
      WeatherForecastListResponse([], City(0, ""));

  @override
  Future<Unit> getUnit() async {
    return _unit;
  }

  @override
  Future saveUnit(Unit unit) async {
    _unit = unit;
  }

  @override
  void saveRefreshTime(int refreshTime) {
    _refreshTime = refreshTime;
  }

  @override
  Future<int> getRefreshTime() async {
    return _refreshTime;
  }

  @override
  void saveLastRefreshTime(int lastRefreshTime) {
    _lastRefreshTime = lastRefreshTime;
  }

  @override
  Future<int> getLastRefreshTime() async {
    return _lastRefreshTime;
  }

  @override
  Future saveLocation(GeoPosition geoPosition) async {
    _geoPosition = geoPosition;
  }

  @override
  Future<GeoPosition?> getLocation() async {
    return _geoPosition;
  }

  @override
  Future saveWeather(WeatherResponse weatherResponse) async {
    _weatherResponse = weatherResponse;
  }

  @override
  Future<WeatherResponse?> getWeather() async {
    return _weatherResponse;
  }

  @override
  Future saveWeatherForecast(
      WeatherForecastListResponse weatherForecastListResponse) async {
    _weatherForecastListResponse = weatherForecastListResponse;
  }

  @override
  Future<WeatherForecastListResponse?> getWeatherForecast() async {
    return _weatherForecastListResponse;
  }
}
