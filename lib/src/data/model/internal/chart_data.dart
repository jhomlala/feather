import 'dart:math';
import 'dart:ui';

import 'package:feather/src/data/model/internal/chart_line.dart';
import 'package:feather/src/data/model/internal/point.dart';
import 'package:feather/src/data/model/internal/weather_forecast_holder.dart';
import 'package:feather/src/data/model/remote/weather_forecast_response.dart';
import 'package:feather/src/resources/config/dimensions.dart';
import 'package:feather/src/data/repository/local/weather_helper.dart';

class ChartData {
  List<Point>? _points;
  List<String>? _pointLabels;
  double? _width;
  double? _height;
  List<ChartLine>? _axes;

  ChartData(
      WeatherForecastHolder holder,
      List<WeatherForecastResponse> forecastList,
      ChartDataType type,
      double width,
      double height,
      bool isMetricUnits) {
    setupChartData(holder, forecastList, type, width, height, isMetricUnits);
  }

  void setupChartData(
      WeatherForecastHolder holder,
      List<WeatherForecastResponse> forecastList,
      ChartDataType chartDataType,
      double width,
      double height,
      bool isMetricUnits) {
    final List<double> values =
        _getChartValues(holder, chartDataType, isMetricUnits)!;
    final double? averageValue =
        _getChartAverageValue(holder, chartDataType, isMetricUnits);
    _points = _getPoints(values, averageValue, width, height);
    _pointLabels = _getPointLabels(values);
    final List<DateTime> dateTimes = _getDateTimes(forecastList);
    final String? mainAxisText =
        _getMainAxisText(chartDataType, averageValue, isMetricUnits);
    _axes = _getAxes(_points!, dateTimes, height, width, mainAxisText);
    _width = width;
    _height = height;
  }

  List<double>? _getChartValues(WeatherForecastHolder holder,
      ChartDataType chartDataType, bool isMetricUnits) {
    List<double>? dataSet;
    switch (chartDataType) {
      case ChartDataType.temperature:
        dataSet = holder.temperatures;
        if (!isMetricUnits) {
          dataSet = dataSet!
              .map((value) => WeatherHelper.convertCelsiusToFahrenheit(value))
              .toList();
        }
        break;
      case ChartDataType.wind:
        dataSet = holder.winds;
        if (isMetricUnits) {
          dataSet = dataSet!
              .map((value) =>
                  WeatherHelper.convertMetersPerSecondToKilometersPerHour(
                      value))
              .toList();
        } else {
          dataSet = dataSet!
              .map((value) =>
                  WeatherHelper.convertMetersPerSecondToMilesPerHour(value))
              .toList();
        }
        break;
      case ChartDataType.rain:
        dataSet = holder.rains;
        break;
      case ChartDataType.pressure:
        dataSet = holder.pressures;
        break;
    }
    return dataSet;
  }

  double? _getChartAverageValue(WeatherForecastHolder holder,
      ChartDataType chartDataType, bool isMetricUnits) {
    double? averageValue;
    switch (chartDataType) {
      case ChartDataType.temperature:
        averageValue = holder.averageTemperature;
        if (!isMetricUnits) {
          averageValue =
              WeatherHelper.convertCelsiusToFahrenheit(averageValue!);
        }
        break;
      case ChartDataType.wind:
        averageValue = holder.averageWind;
        if (isMetricUnits) {
          averageValue =
              WeatherHelper.convertMetersPerSecondToKilometersPerHour(
                  averageValue);
        } else {
          averageValue =
              WeatherHelper.convertMetersPerSecondToMilesPerHour(averageValue);
        }
        break;
      case ChartDataType.rain:
        averageValue = holder.averageRain;
        break;
      case ChartDataType.pressure:
        averageValue = holder.averagePressure;
        break;
    }
    return averageValue;
  }

  List<Point> _getPoints(
      List<double> values, double? averageValue, double width, double height) {
    final List<Point> points = [];
    final double halfHeight = (height - Dimensions.chartPadding) / 2;
    final double widthStep = width / (values.length - 1);
    double currentX = 0;

    final List<double> averageDifferenceValues =
        _getAverageDifferenceValues(values, averageValue);
    final double maxValue = _getAbsoluteMax(averageDifferenceValues);

    for (final double averageDifferenceValue in averageDifferenceValues) {
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
      List<double> values, double? averageValue) {
    final List<double> calculatedValues = [];
    for (final double value in values) {
      calculatedValues.add(value - averageValue!);
    }
    return calculatedValues;
  }

  double _getAbsoluteMax(List<double> values) {
    double maxValue = 0;
    for (final double value in values) {
      maxValue = max(maxValue, value.abs());
    }
    return maxValue;
  }

  List<String> _getPointLabels(List<double> values) {
    final List<String> points = [];
    for (final double value in values) {
      points.add(value.toStringAsFixed(1));
    }
    return points;
  }

  List<DateTime> _getDateTimes(List<WeatherForecastResponse> forecastList) {
    final List<DateTime> dateTimes = [];
    for (final WeatherForecastResponse response in forecastList) {
      dateTimes.add(response.dateTime);
    }
    return dateTimes;
  }

  List<ChartLine> _getAxes(List<Point> points, List<DateTime> dateTimes,
      double height, double width, String? mainAxisText) {
    final List<ChartLine> list = [];
    list.add(ChartLine(
        mainAxisText,
        Offset(-25, height / 2 - 15),
        Offset(-5, (height - Dimensions.chartPadding) / 2),
        Offset(width + 5, (height - Dimensions.chartPadding) / 2)));

    for (int index = 0; index < points.length; index++) {
      final Point point = points[index];
      final DateTime dateTime = dateTimes[index];
      list.add(ChartLine(
          _getPointAxisLabel(dateTime),
          Offset(point.x - 10, height - 10),
          Offset(point.x, 0),
          Offset(point.x, height - 10)));
    }
    return list;
  }

  String _getPointAxisLabel(DateTime dateTime) {
    final int hour = dateTime.hour;
    String hourText = "";
    if (hour < 10) {
      hourText = "0${hour.toString()}";
    } else {
      hourText = hour.toString();
    }
    return "${hourText.toString()}:00";
  }

  String? _getMainAxisText(
      ChartDataType chartDataType, double? averageValue, bool isMetricUnits) {
    String? text;
    switch (chartDataType) {
      case ChartDataType.temperature:
        final temperature = averageValue;
        text = WeatherHelper.formatTemperature(
          temperature: temperature,
          positions: 1,
          round: false,
          metricUnits: isMetricUnits,
        );
        break;
      case ChartDataType.wind:
        text = WeatherHelper.formatWind(averageValue!, isMetricUnits);
        break;
      case ChartDataType.rain:
        text = "${averageValue!.toStringAsFixed(1)} mm/h";
        break;
      case ChartDataType.pressure:
        text = WeatherHelper.formatPressure(averageValue!, isMetricUnits);
    }
    return text;
  }

  List<ChartLine>? get axes => _axes;

  double? get height => _height;

  double? get width => _width;

  List<String>? get pointLabels => _pointLabels;

  List<Point>? get points => _points;
}

enum ChartDataType { temperature, wind, rain, pressure }
