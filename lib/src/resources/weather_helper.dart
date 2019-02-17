import 'dart:collection';
import 'package:feather/src/models/remote/system.dart';
import 'package:feather/src/models/remote/weather_forecast_response.dart';
import 'package:feather/src/resources/config/assets.dart';

class WeatherHelper {
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

  static String formatTemperature({double temperature, int positions = 0, round = true}){
    if (round){
      temperature = temperature.floor().toDouble();
    }
    return temperature.toStringAsFixed(positions) + "°C";
  }

  static String formatPressure(double pressure){
    return "${pressure.toStringAsFixed(0)} hPa";
  }

  static String formatRain(double rain){
    return "${rain.toStringAsFixed(2)} mm/h";
  }

  static String formatWind(double wind){
    return "${wind.toStringAsFixed(1)} km/h";
  }

  static String formatHumidity(double humidity){
    return "${humidity.toStringAsFixed(0)}%";
  }

  static int getDayMode(System system) {
    int sunrise = system.sunrise * 1000;
    int sunset = system.sunset * 1000;
    return getDayModeFromSunriseSunset(sunrise, sunset);
  }

  static int getDayModeFromSunriseSunset(int sunrise, int sunset){
    int now = DateTime.now().millisecondsSinceEpoch;
    if (now >= sunrise && now <= sunset) {
      return 0;
    } else if (now >= sunrise) {
      return 1;
    } else {
      return -1;
    }
  }




}
