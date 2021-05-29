import 'dart:convert';

import 'package:feather/src/data/model/internal/geo_position.dart';
import 'package:feather/src/data/model/internal/unit.dart';
import 'package:feather/src/data/model/remote/weather_forecast_list_response.dart';
import 'package:feather/src/data/model/remote/weather_response.dart';
import 'package:feather/src/resources/config/ids.dart';
import 'package:feather/src/utils/app_logger.dart';
import 'package:feather/src/utils/date_time_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageManager {

  Future<Unit> getUnit() async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      final int? unit = sharedPreferences.getInt(Ids.storageUnitKey);
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

  Future saveUnit(Unit unit) async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      Log.d("Store unit $unit");
      int unitValue = 0;
      if (unit == Unit.metric) {
        unitValue = 0;
      } else {
        unitValue = 1;
      }

      sharedPreferences.setInt(Ids.storageUnitKey, unitValue);
    } catch (exc, stackTrace) {
      Log.e("Exception: $exc stack trace: $stackTrace");
    }
  }

  void saveRefreshTime(int refreshTime) async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      Log.d("Save refresh time: $refreshTime");

      sharedPreferences.setInt(Ids.storageRefreshTimeKey, refreshTime);
    } catch (exc, stackTrace) {
      Log.e("Exception: $exc stack trace: $stackTrace");
    }
  }

  Future<int> getRefreshTime() async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      int? refreshTime = sharedPreferences.getInt(Ids.storageRefreshTimeKey);
      if (refreshTime == null || refreshTime == 0) {
        refreshTime = 600000;
      }
      return refreshTime;
    } catch (exc, stackTrace) {
      Log.e("Exception: $exc stack trace: $stackTrace");
      return 600000;
    }
  }

  void saveLastRefreshTime(int lastRefreshTime) async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      Log.d("Save refresh time: $lastRefreshTime");
      sharedPreferences.setInt(Ids.storageLastRefreshTimeKey, lastRefreshTime);
    } catch (exc, stackTrace) {
      Log.e("Exception: $exc stack trace: $stackTrace");
    }
  }

  Future<int> getLastRefreshTime() async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      int? lastRefreshTime =
          sharedPreferences.getInt(Ids.storageLastRefreshTimeKey);
      if (lastRefreshTime == null || lastRefreshTime == 0) {
        lastRefreshTime = DateTimeHelper.getCurrentTime();
      }
      return lastRefreshTime;
    } catch (exc, stackTrace) {
      Log.e("Exception: $exc stack trace: $stackTrace");
      return DateTimeHelper.getCurrentTime();
    }
  }

  Future saveLocation(GeoPosition geoPosition) async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      Log.d("Store location: $geoPosition");
      sharedPreferences.setString(
          Ids.storageLocationKey, json.encode(geoPosition));
    } catch (exc, stackTrace) {
      Log.e("Exception: $exc stack trace: $stackTrace");
    }
  }

  Future<GeoPosition?> getLocation() async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      final String? jsonData =
          sharedPreferences.getString(Ids.storageLocationKey);
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

  Future saveWeather(WeatherResponse response) async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      Log.d("Store weather: ${json.encode(response)}");
      sharedPreferences.setString(Ids.storageWeatherKey, json.encode(response));
    } catch (exc, stackTrace) {
      Log.e("Exception: $exc stack trace: $stackTrace");
    }
  }

  Future<WeatherResponse?> getWeather() async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      final String? jsonData =
          sharedPreferences.getString(Ids.storageWeatherKey);
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

  Future saveWeatherForecast(WeatherForecastListResponse response) async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      Log.d("Store weather forecast ${json.encode(response)}");
      sharedPreferences.setString(
          Ids.storageWeatherForecastKey, json.encode(response));
    } catch (exc, stackTrace) {
      Log.e("Exception: $exc stack trace: $stackTrace");
    }
  }

  Future<WeatherForecastListResponse?> getWeatherForecast() async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      final String? jsonData =
          sharedPreferences.getString(Ids.storageWeatherForecastKey);
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
