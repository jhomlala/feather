import 'dart:math';

import 'package:feather/src/models/internal/chart_data.dart';
import 'package:feather/src/models/internal/chart_line.dart';
import 'package:feather/src/models/internal/point.dart';
import 'package:feather/src/models/remote/city.dart';
import 'package:feather/src/models/remote/system.dart';
import 'package:feather/src/models/remote/weather_forecast_response.dart';
import 'package:feather/src/resources/application_localization.dart';
import 'package:feather/src/resources/config/dimensions.dart';
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

  Map<ChartDataType, ChartData> _chartDataCache;

  WeatherForecastHolder(
      List<WeatherForecastResponse> forecastList, City city, System system) {
    _chartDataCache = new Map();
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
      winds.add(response.wind.speed);
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
    if (_chartDataCache.containsKey(chartDataType)) {
      return _chartDataCache[chartDataType];
    }
    List<double> values = _getChartValues(chartDataType);
    double averageValue = _getChartAverageValue(chartDataType);
    List<Point> points = _getPoints(values, averageValue, width, height);
    List<String> pointsLabel = _getPointLabels(values);
    List<DateTime> dateTimes = _getDateTimes();
    String mainAxisText = _getMainAxisText(chartDataType, averageValue);
    List<ChartLine> axes =
        _getAxes(points, dateTimes, height, width, mainAxisText);
    var chartData = ChartData(points, pointsLabel, width, height, axes);
    _chartDataCache[chartDataType] = chartData;
    return chartData;
  }

  List<double> _getChartValues(ChartDataType chartDataType) {
    List<double> dataSet;
    switch (chartDataType) {
      case ChartDataType.temperature:
        dataSet = _temperatures;
        break;
      case ChartDataType.wind:
        dataSet = _winds;
        break;
      case ChartDataType.rain:
        dataSet = _rains;
        break;
      case ChartDataType.pressure:
        dataSet = _pressures;
        break;
    }
    return dataSet;
  }

  double _getChartAverageValue(ChartDataType chartDataType) {
    double averageValue;
    switch (chartDataType) {
      case ChartDataType.temperature:
        averageValue = _averageTemperature;
        break;
      case ChartDataType.wind:
        averageValue = _averageWind;
        break;
      case ChartDataType.rain:
        averageValue = _averageRain;
        break;
      case ChartDataType.pressure:
        averageValue = _averagePressure;
        break;
    }
    return averageValue;
  }

  List<Point> _getPoints(
      List<double> values, double averageValue, double width, double height) {
    List<Point> points = List();
    double halfHeight = (height - Dimensions.chartPadding) / 2;
    double widthStep = width / (forecastList.length - 1);
    double currentX = 0;

    List<double> averageDifferenceValues =
        _getAverageDifferenceValues(values, averageValue);
    double maxValue = _getAbsoluteMax(averageDifferenceValues);

    for (double averageDifferenceValue in averageDifferenceValues) {
      var y = halfHeight - (halfHeight * averageDifferenceValue / maxValue);
      if (y.isNaN) {
        y = halfHeight;
      }
      points.add(Point(currentX, y));
      currentX += widthStep;
    }
    return points;
  }

  List<double> _getAverageDifferenceValues(
      List<double> values, double averageValue) {
    List<double> calculatedValues = new List();
    for (double value in values) {
      calculatedValues.add(value - averageValue);
    }
    return calculatedValues;
  }

  double _getAbsoluteMax(List<double> values) {
    double maxValue = 0;
    for (double value in values) {
      maxValue = max(maxValue, value.abs());
    }
    return maxValue;
  }

  List<String> _getPointLabels(List<double> values) {
    List<String> points = List();
    for (double value in values) {
      points.add(value.toStringAsFixed(1));
    }
    return points;
  }

  List<DateTime> _getDateTimes() {
    List<DateTime> dateTimes = new List();
    for (WeatherForecastResponse response in forecastList) {
      dateTimes.add(response.dateTime);
    }
    return dateTimes;
  }

  List<ChartLine> _getAxes(List<Point> points, List<DateTime> dateTimes,
      double height, double width, String mainAxisText) {
    List<ChartLine> list = new List();
    list.add(ChartLine(
        mainAxisText,
        Offset(-25, height / 2 - 15),
        Offset(-5, (height - Dimensions.chartPadding) / 2),
        Offset(width + 5, (height - Dimensions.chartPadding) / 2)));

    for (int index = 0; index < points.length; index++) {
      Point point = points[index];
      DateTime dateTime = dateTimes[index];
      list.add(ChartLine(
          _getPointAxisLabel(dateTime),
          Offset(point.x - 10, height - 10),
          Offset(point.x, 0),
          Offset(point.x, height - 10)));
    }
    return list;
  }

  String _getPointAxisLabel(DateTime dateTime) {
    int hour = dateTime.hour;
    String hourText = "";
    if (hour < 10) {
      hourText = "0${hour.toString()}";
    } else {
      hourText = hour.toString();
    }
    return "${hourText.toString()}:00";
  }

  String _getMainAxisText(ChartDataType chartDataType, double averageValue) {
    String text;
    switch (chartDataType) {
      case ChartDataType.temperature:
        text = WeatherHelper.formatTemperature(
            temperature: averageValue, positions: 1, round: false);
        break;
      case ChartDataType.wind:
        text = "${averageValue.toStringAsFixed(1)} km/h";
        break;
      case ChartDataType.rain:
        text = "${averageValue.toStringAsFixed(1)} mm/h";
        break;
      case ChartDataType.pressure:
        text = "${averageValue.toStringAsFixed(0)} hPa";
    }
    return text;
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
