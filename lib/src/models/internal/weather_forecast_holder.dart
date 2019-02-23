import 'package:feather/src/models/internal/chart_data.dart';
import 'package:feather/src/models/remote/city.dart';
import 'package:feather/src/models/remote/system.dart';
import 'package:feather/src/models/remote/weather_forecast_response.dart';
import 'package:feather/src/resources/application_localization.dart';
import 'package:feather/src/resources/weather_helper.dart';
import 'package:flutter/material.dart';

class WeatherForecastHolder {
  List<double> _temperatures;
  double _averageTemperature;
  double _maxTemperature;
  double _minTemperature;

  List<double> _winds;
  double _averageWind;
  double _maxWind;
  double _minWind;

  List<double> _rains;
  double _averageRain;
  double _maxRain;
  double _minRain;

  List<double> _pressures;
  double _averagePressure;
  double _maxPressure;
  double _minPressure;

  String _dateShortFormatted;
  String _dateFullFormatted;
  int _weatherCode;
  String _weatherCodeAsset;
  List<WeatherForecastResponse> _forecastList;
  City _city;
  System _system;

  WeatherForecastHolder(
      List<WeatherForecastResponse> forecastList, City city, System system) {
    _forecastList = forecastList;
    _temperatures = _getTemperaturesList();

    _averageTemperature = _calculateAverage(_temperatures);
    _maxTemperature = _calculateMax(_temperatures);
    _minTemperature = _calculateMin(_temperatures);

    _winds = _getWindList();
    _averageWind = _calculateAverage(_winds);
    _maxWind = _calculateMax(_winds);
    _minWind = _calculateMin(_winds);

    _rains = _getRainList();
    _averageRain = _calculateAverage(_rains);
    _maxRain = _calculateMax(_rains);
    _minRain = _calculateMin(_rains);

    _pressures = _getPressureList();
    _averagePressure = _calculateAverage(_pressures);
    _maxPressure = _calculateMax(_pressures);
    _minPressure = _calculateMin(_pressures);

    setupDateFormatted(forecastList[0].dateTime);
    setupWeatherCode(forecastList);
    _city = city;
    _system = system;
  }

  List<double> _getTemperaturesList() {
    List<double> temperatures = new List();
    for (WeatherForecastResponse response in forecastList) {
      temperatures.add(response.mainWeatherData.temp);
    }
    return temperatures;
  }

  List<double> _getWindList() {
    List<double> winds = new List();
    for (WeatherForecastResponse response in forecastList) {
      var speed = response.wind.speed;
      winds.add(speed);
    }
    return winds;
  }

  void setupDateFormatted(DateTime dateTime) {
    int day = dateTime.day;
    String dayString = "";
    if (day < 10) {
      dayString = "0" + day.toString();
    } else {
      dayString = day.toString();
    }

    int month = dateTime.month;
    String monthString = "";
    if (month < 10) {
      monthString = "0" + month.toString();
    } else {
      monthString = month.toString();
    }

    _dateShortFormatted = dayString + "/" + monthString;
    _dateFullFormatted = _dateShortFormatted + "/" + dateTime.year.toString();
  }

  double _calculateAverage(List<double> values) {
    double sum = 0;
    for (var value in values) {
      sum += value;
    }
    return sum / values.length;
  }

  double _calculateMax(List<double> values) {
    double maxValue = values[0];
    for (var value in values) {
      if (value >= maxValue) {
        maxValue = value;
      }
    }

    return maxValue;
  }

  double _calculateMin(List<double> values) {
    double minValue = values[0];
    for (var value in values) {
      if (value <= minValue) {
        minValue = value;
      }
    }
    return minValue;
  }

  void setupWeatherCode(List<WeatherForecastResponse> forecastList) {
    int index = (forecastList.length / 2).floor();
    _weatherCode = forecastList[index].overallWeatherData[0].id;
    _weatherCodeAsset = WeatherHelper.getWeatherIcon(_weatherCode);
  }

  String getLocationName(BuildContext context) {
    if (city != null && city.name != null && city.name.length > 0) {
      return city.name;
    } else {
      return ApplicationLocalization.of(context).getText("your_location");
    }
  }

  ChartData setupChartData(
      ChartDataType chartDataType, double width, double height) {
    return ChartData(this, forecastList, chartDataType, width, height);
  }

  List<String> getWindDirectionList() {
    List<String> windDirections = new List();
    for (WeatherForecastResponse response in forecastList) {
      windDirections.add(response.wind.getDegCode());
    }
    return windDirections;
  }

  List<double> _getRainList() {
    List<double> rainList = new List();
    for (WeatherForecastResponse response in forecastList) {
      double rainSum = 0;
      if (response.rain != null && response.rain.amount != null) {
        rainSum = response.rain.amount;
      }
      if (response.snow != null && response.snow.amount != null) {
        rainSum += response.snow.amount;
      }
      rainList.add(rainSum);
    }
    return rainList;
  }

  List<double> _getPressureList() {
    List<double> pressureList = new List();
    for (WeatherForecastResponse response in forecastList) {
      pressureList.add(response.mainWeatherData.pressure);
    }
    return pressureList;
  }

  String get weatherCodeAsset => _weatherCodeAsset;

  int get weatherCode => _weatherCode;

  double get averageTemperature => _averageTemperature;

  double get minTemperature => _minTemperature;

  double get maxTemperature => _maxTemperature;

  String get dateFullFormatted => _dateFullFormatted;

  String get dateShortFormatted => _dateShortFormatted;

  List<WeatherForecastResponse> get forecastList => _forecastList;

  City get city => _city;

  double get minWind => _minWind;

  double get maxWind => _maxWind;

  double get averageWind => _averageWind;

  List<double> get winds => _winds;

  List<double> get temperatures => _temperatures;

  double get minRain => _minRain;

  double get maxRain => _maxRain;

  double get averageRain => _averageRain;

  List<double> get rains => _rains;

  double get minPressure => _minPressure;

  double get maxPressure => _maxPressure;

  double get averagePressure => _averagePressure;

  List<double> get pressures => _pressures;

  System get system => _system;
}
