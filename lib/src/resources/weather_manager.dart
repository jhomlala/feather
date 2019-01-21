import 'dart:collection';

import 'package:feather/src/models/remote/weather_forecast_response.dart';
import 'package:feather/src/resources/app_const.dart';
import 'package:feather/src/resources/config/assets.dart';
import 'package:feather/src/ui/widget/widget_helper.dart';
import 'package:flutter/material.dart';

class WeatherManager {
  static String getWeatherIcon(int code) {
    String asset = Assets.iconCloud;
    if (code >= 200 && code <= 299) {
      asset = Assets.iconThunder;
    } else if (code >= 300 && code <= 399) {
      asset = Assets.iconCloudLittleRain;
    } else if (code >= 500 && code <= 599) {
      asset = Assets.iconRain;
    } else if (code >= 600 && code <= 699) {
      asset = Assets.iconSnow;
    } else if (code >= 700 && code <= 799) {
      asset = Assets.iconDust;
    } else if (code == 800) {
      asset = Assets.iconSun;
    } else if (code == 801) {
      asset = Assets.iconCloudSun;
    } else if (code >= 802) {
      asset = Assets.iconCloud;
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


}
