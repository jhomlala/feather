import 'package:feather/src/data/model/remote/system.dart';
import 'package:feather/src/data/model/remote/weather_forecast_response.dart';
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

  static Map<String, List<WeatherForecastResponse>> getMapForecastsForSameDay(
      List<WeatherForecastResponse> forecastList) {
    final Map<String, List<WeatherForecastResponse>> map = {};
    for (int i = 0; i < forecastList.length; i++) {
      final WeatherForecastResponse response = forecastList[i];
      final String dayKey = _getDayKey(response.dateTime);
      if (!map.containsKey(dayKey)) {
        map[dayKey] = <WeatherForecastResponse>[];
      }
      map[dayKey]!.add(response);
    }
    return map;
  }

  static String _getDayKey(DateTime dateTime) {
    return "${dateTime.day.toString()}-${dateTime.month.toString()}-${dateTime.year.toString()}";
  }

  static String formatTemperature({
    double? temperature,
    int positions = 0,
    bool round = true,
    bool metricUnits = true,
  }) {
    var unit = "°C";
    var temperatureValue = temperature;

    if (!metricUnits) {
      unit = "°F";
    }

    if (round) {
      temperatureValue = temperature!.floor().toDouble();
    }

    return "${temperatureValue!.toStringAsFixed(positions)} $unit";
  }

  static double convertCelsiusToFahrenheit(double temperature) {
    return 32 + temperature * 1.8;
  }


  static double convertFahrenheitToCelsius(double temperature) {
    return (temperature - 32) * 5/9;
  }

  static String formatPressure(double pressure, bool isMetricUnits) {
    String unit = "hPa";
    if (!isMetricUnits) {
      unit = "mbar";
    }
    return "${pressure.toStringAsFixed(0)} $unit";
  }

  static double convertMetersPerSecondToKilometersPerHour(double? speed) {
    if (speed != null) {
      return speed * 3.6;
    } else {
      return 0;
    }
  }

  static double convertMetersPerSecondToMilesPerHour(double? speed) {
    if (speed != null) {
      return speed * 2.236936292;
    } else {
      return 0;
    }
  }

  static String formatRain(double rain) {
    return "${rain.toStringAsFixed(2)} mm/h";
  }

  static String formatWind(double wind, bool isMetricUnits) {
    String unit = "km/h";
    if (!isMetricUnits) {
      unit = "mi/h";
    }
    return "${wind.toStringAsFixed(1)} $unit";
  }

  static String formatHumidity(double humidity) {
    return "${humidity.toStringAsFixed(0)}%";
  }

  static int getDayMode(System system) {
    final int sunrise = system.sunrise! * 1000;
    final int sunset = system.sunset! * 1000;
    return getDayModeFromSunriseSunset(sunrise, sunset);
  }

  static int getDayModeFromSunriseSunset(int sunrise, int? sunset) {
    final int now = DateTime.now().millisecondsSinceEpoch;
    if (now >= sunrise && now <= sunset!) {
      return 0;
    } else if (now >= sunrise) {
      return 1;
    } else {
      return -1;
    }
  }
}
