import 'dart:collection';

import 'package:feather/src/models/remote/weather_forecast_response.dart';
import 'package:feather/src/resources/app_const.dart';
import 'package:feather/src/ui/widget/widget_helper.dart';
import 'package:flutter/material.dart';

class WeatherManager {
  static String getWeatherIcon(int code) {
    String asset = "assets/icon_cloud.png";
    if (code >= 200 && code <= 299) {
      asset = "assets/icon_thunder.png";
    } else if (code >= 300 && code <= 399) {
      asset = "assets/icon_cloud_little_rain.png";
    } else if (code >= 500 && code <= 599) {
      asset = "assets/icon_rain.png";
    } else if (code >= 600 && code <= 699) {
      asset = "assets/icon_snow.png";
    } else if (code >= 700 && code <= 799) {
      asset = "assets/icon_dust.png";
    } else if (code == 800) {
      asset = "assets/icon_sun.png";
    } else if (code == 801) {
      asset = "assets/icon_cloud_sun.png";
    } else if (code >= 802) {
      asset = "assets/icon_cloud.png";
    }
    return asset;
  }

  static Map<String, List<WeatherForecastResponse>> mapForecastsForSameDay(
      List<WeatherForecastResponse> forecastList) {
    Map<String, List<WeatherForecastResponse>> map = new LinkedHashMap();
    for (int i = 0; i < forecastList.length; i++) {
      WeatherForecastResponse response = forecastList[i];
      String dayKey = _getDayKey(response.dateTime);
      if (!map.containsKey(dayKey)) {
        map[dayKey] = List<WeatherForecastResponse>();
      }
      map[dayKey].add(response);
    }
    return map;
  }

  static String _getDayKey(DateTime dateTime) {
    return "${dateTime.day.toString()}-${dateTime.month.toString()}-${dateTime.year.toString()}";
  }

  static LinearGradient getGradient({sunriseTime = 0, sunsetTime = 0}) {
    if (sunriseTime == 0 && sunsetTime == 0) {
      return WidgetHelper.buildGradient(
          AppConst.nightStartGradientColor, AppConst.nightEndGradient);
    } else {
      return WidgetHelper.buildGradientBasedOnDayCycle(sunriseTime, sunsetTime);
    }
  }
}
