import 'dart:convert';

import 'package:feather/src/data/model/internal/geo_position.dart';
import 'package:feather/src/data/model/internal/unit.dart';
import 'package:feather/src/data/model/remote/weather_forecast_list_response.dart';
import 'package:feather/src/data/model/remote/weather_response.dart';
import 'package:feather/src/data/repository/local/storage_provider.dart';
import 'package:feather/src/resources/config/ids.dart';
import 'package:feather/src/utils/app_logger.dart';
import 'package:feather/src/utils/date_time_helper.dart';

class StorageManager {
  final StorageProvider _storageProvider;

  StorageManager(this._storageProvider);

  Future<Unit> getUnit() async {
    try {
      final int? unit = await _storageProvider.getInt(Ids.storageUnitKey);
      if (unit == null) {
        return Unit.metric;
      } else {
        if (unit == 0) {
          return Unit.metric;
        } else {
          return Unit.imperial;
        }
      }
    } catch (exc, stackTrace) {
      Log.e("Exception: $exc stack trace: $stackTrace");
      return Unit.metric;
    }
  }

  Future<bool> saveUnit(Unit unit) async {
    try {
      Log.d("Store unit $unit");
      int unitValue = 0;
      if (unit == Unit.metric) {
        unitValue = 0;
      } else {
        unitValue = 1;
      }

      final result =
          await _storageProvider.setInt(Ids.storageUnitKey, unitValue);
      Log.d("Saved with result: $result");

      return result;
    } catch (exc, stackTrace) {
      Log.e("Exception: $exc stack trace: $stackTrace");
      return false;
    }
  }

  Future<bool> saveRefreshTime(int refreshTime) async {
    try {
      Log.d("Save refresh time: $refreshTime");
      final result =
          await _storageProvider.setInt(Ids.storageRefreshTimeKey, refreshTime);
      Log.d("Saved with result: $result");
      return result;
    } catch (exc, stackTrace) {
      Log.e("Exception: $exc stack trace: $stackTrace");
      return false;
    }
  }

  Future<int> getRefreshTime() async {
    try {
      int? refreshTime =
          await _storageProvider.getInt(Ids.storageRefreshTimeKey);
      if (refreshTime == null || refreshTime == 0) {
        refreshTime = 600000;
      }
      return refreshTime;
    } catch (exc, stackTrace) {
      Log.e("Exception: $exc stack trace: $stackTrace");
      return 600000;
    }
  }

  Future<bool> saveLastRefreshTime(int lastRefreshTime) async {
    try {
      Log.d("Save refresh time: $lastRefreshTime");
      final result = await _storageProvider.setInt(
          Ids.storageLastRefreshTimeKey, lastRefreshTime);
      Log.d("Saved with result: $result");
      return result;
    } catch (exc, stackTrace) {
      Log.e("Exception: $exc stack trace: $stackTrace");
      return false;
    }
  }

  Future<int> getLastRefreshTime() async {
    try {
      int? lastRefreshTime =
          await _storageProvider.getInt(Ids.storageLastRefreshTimeKey);
      if (lastRefreshTime == null || lastRefreshTime == 0) {
        lastRefreshTime = DateTimeHelper.getCurrentTime();
      }
      return lastRefreshTime;
    } catch (exc, stackTrace) {
      Log.e("Exception: $exc stack trace: $stackTrace");
      return DateTimeHelper.getCurrentTime();
    }
  }

  Future<bool> saveLocation(GeoPosition geoPosition) async {
    try {
      Log.d("Store location: $geoPosition");
      final result = await _storageProvider.setString(
          Ids.storageLocationKey, json.encode(geoPosition));
      Log.d("Saved with result: $result");
      return result;
    } catch (exc, stackTrace) {
      Log.e("Exception: $exc stack trace: $stackTrace");
      return false;
    }
  }

  Future<GeoPosition?> getLocation() async {
    try {
      final String? jsonData =
          await _storageProvider.getString(Ids.storageLocationKey);
      Log.d("Returned user location: $jsonData");
      if (jsonData != null) {
        return GeoPosition.fromJson(
            json.decode(jsonData) as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (exc, stackTrace) {
      Log.e("Exception: $exc stack trace: $stackTrace");
      return null;
    }
  }

  Future<bool> saveWeather(WeatherResponse response) async {
    try {
      Log.d("Store weather: ${json.encode(response)}");
      final result = await _storageProvider.setString(
          Ids.storageWeatherKey, json.encode(response));
      Log.d("Saved with result: $result");
      return result;
    } catch (exc, stackTrace) {
      Log.e("Exception: $exc stack trace: $stackTrace");
      return false;
    }
  }

  Future<WeatherResponse?> getWeather() async {
    try {
      final String? jsonData =
          await _storageProvider.getString(Ids.storageWeatherKey);
      Log.d("Returned weather data: $jsonData");
      if (jsonData != null) {
        return WeatherResponse.fromJson(
            jsonDecode(jsonData) as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (exc, stackTrace) {
      Log.e("Exception: $exc stack trace: $stackTrace");
      return null;
    }
  }

  Future<bool> saveWeatherForecast(WeatherForecastListResponse response) async {
    try {
      Log.d("Store weather forecast ${json.encode(response)}");
      final result = _storageProvider.setString(
          Ids.storageWeatherForecastKey, json.encode(response));
      Log.d("Saved with result: $result");
      return result;
    } catch (exc, stackTrace) {
      Log.e("Exception: $exc stack trace: $stackTrace");
      return false;
    }
  }

  Future<WeatherForecastListResponse?> getWeatherForecast() async {
    try {
      final String? jsonData =
          await _storageProvider.getString(Ids.storageWeatherForecastKey);
      Log.d("Returned weather forecast data: $jsonData");
      if (jsonData != null) {
        return WeatherForecastListResponse.fromJson(
            jsonDecode(jsonData) as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (exc, stackTrace) {
      Log.e("Exception: $exc stack trace: $stackTrace");
      return null;
    }
  }
}
