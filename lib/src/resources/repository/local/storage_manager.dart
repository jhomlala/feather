import 'dart:convert';

import 'package:feather/src/models/internal/geo_position.dart';
import 'package:feather/src/models/internal/unit.dart';
import 'package:feather/src/models/remote/weather_forecast_list_response.dart';
import 'package:feather/src/models/remote/weather_response.dart';
import 'package:feather/src/resources/config/ids.dart';
import 'package:feather/src/utils/date_time_helper.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageManager {
  final Logger _logger = Logger("StorageManager");
  static final StorageManager _instance = StorageManager._internal();

  StorageManager._internal();

  factory StorageManager() {
    return _instance;
  }

  Future<Unit> getUnit() async {
    try {
      var sharedPreferences = await SharedPreferences.getInstance();
      int unit = sharedPreferences.getInt(Ids.storageUnitKey);
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
      _logger.warning("Exception: $exc stack trace: $stackTrace");
      return Unit.metric;
    }
  }

  saveUnit(Unit unit) async {
    try {
      var sharedPreferences = await SharedPreferences.getInstance();
      _logger.log(Level.FINE, "Store unit $unit");
      int unitValue = 0;
      if (unit == Unit.metric) {
        unitValue = 0;
      } else {
        unitValue = 1;
      }

      sharedPreferences.setInt(Ids.storageUnitKey, unitValue);
    } catch (exc, stackTrace) {
      _logger.warning("Exception: $exc stack trace: $stackTrace");
    }
  }

  void saveRefreshTime(int refreshTime) async {
    try {
      var sharedPreferences = await SharedPreferences.getInstance();
      _logger.log(Level.FINE, "Save refresh time: $refreshTime");

      sharedPreferences.setInt(Ids.storageRefreshTimeKey, refreshTime);
    } catch (exc, stackTrace) {
      _logger.warning("Exception: $exc stack trace: $stackTrace");
    }
  }

  Future<int> getRefreshTime() async {
    try {
      var sharedPreferences = await SharedPreferences.getInstance();
      int refreshTime = sharedPreferences.getInt(Ids.storageRefreshTimeKey);
      if (refreshTime == null || refreshTime == 0) {
        refreshTime = 600000;
      }
      return refreshTime;
    } catch (exc, stackTrace) {
      _logger.warning("Exception: $exc stack trace: $stackTrace");
      return 600000;
    }
  }

  void saveLastRefreshTime(int lastRefreshTime) async {
    try {
      var sharedPreferences = await SharedPreferences.getInstance();
      _logger.log(Level.FINE, "Save refresh time: $lastRefreshTime");
      sharedPreferences.setInt(Ids.storageLastRefreshTimeKey, lastRefreshTime);
    } catch (exc, stackTrace) {
      _logger.warning("Exception: $exc stack trace: $stackTrace");
    }
  }

  Future<int> getLastRefreshTime() async {
    try {
      var sharedPreferences = await SharedPreferences.getInstance();
      int lastRefreshTime =
          sharedPreferences.getInt(Ids.storageLastRefreshTimeKey);
      if (lastRefreshTime == null || lastRefreshTime == 0) {
        lastRefreshTime = DateTimeHelper.getCurrentTime();
      }
      return lastRefreshTime;
    } catch (exc, stackTrace) {
      _logger.warning("Exception: $exc stack trace: $stackTrace");
      return DateTimeHelper.getCurrentTime();
    }
  }

  saveLocation(GeoPosition geoPosition) async {
    try {
      var sharedPreferences = await SharedPreferences.getInstance();
      _logger.log(Level.FINE, "Store location: $geoPosition");
      sharedPreferences.setString(
          Ids.storageLocationKey, json.encode(geoPosition));
    } catch (exc, stackTrace) {
      _logger.warning("Exception: $exc stack trace: $stackTrace");
    }
  }

  Future<GeoPosition> getLocation() async {
    try {
      var sharedPreferences = await SharedPreferences.getInstance();
      String jsonData = sharedPreferences.getString(Ids.storageLocationKey);
      _logger.log(Level.FINE, "Returned user location: $jsonData");
      if (jsonData != null) {
        return GeoPosition.fromJson(json.decode(jsonData));
      } else {
        return null;
      }
    } catch (exc, stackTrace) {
      _logger.warning("Exception: $exc stack trace: $stackTrace");
      return null;
    }
  }

  saveWeather(WeatherResponse response) async {
    try {
      var sharedPreferences = await SharedPreferences.getInstance();
      _logger.log(Level.FINE, "Store weather" + json.encode(response));
      sharedPreferences.setString(Ids.storageWeatherKey, json.encode(response));
    } catch (exc, stackTrace) {
      _logger.warning("Exception: $exc stack trace: $stackTrace");
    }
  }

  Future<WeatherResponse> getWeather() async {
    try {
      var sharedPreferences = await SharedPreferences.getInstance();
      String jsonData = sharedPreferences.getString(Ids.storageWeatherKey);
      _logger.log(Level.FINE, "Returned weather data: $jsonData");
      if (jsonData != null) {
        return WeatherResponse.fromJson(jsonDecode(jsonData));
      } else {
        return null;
      }
    } catch (exc, stackTrace) {
      _logger.warning("Exception: $exc stack trace: $stackTrace");
      return null;
    }
  }

  saveWeatherForecast(WeatherForecastListResponse response) async {
    try {
      var sharedPreferences = await SharedPreferences.getInstance();
      _logger.log(Level.FINE, "Store weather forecast" + json.encode(response));
      sharedPreferences.setString(
          Ids.storageWeatherForecastKey, json.encode(response));
    } catch (exc, stackTrace) {
      _logger.warning("Exception: $exc stack trace: $stackTrace");
    }
  }

  Future<WeatherForecastListResponse> getWeatherForecast() async {
    try {
      var sharedPreferences = await SharedPreferences.getInstance();
      String jsonData =
          sharedPreferences.getString(Ids.storageWeatherForecastKey);
      _logger.log(Level.FINE, "Returned weather forecast data: $jsonData");
      if (jsonData != null) {
        return WeatherForecastListResponse.fromJson(jsonDecode(jsonData));
      } else {
        return null;
      }
    } catch (exc, stackTrace) {
      _logger.warning("Exception: $exc stack trace: $stackTrace");
      return null;
    }
  }
}
