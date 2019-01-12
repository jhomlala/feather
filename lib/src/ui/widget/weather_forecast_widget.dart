import 'dart:core';
import 'dart:math';

import 'package:feather/src/models/internal/line_axis.dart';
import 'package:feather/src/models/internal/point.dart';
import 'package:feather/src/models/internal/weather_forecast_holder.dart';
import 'package:feather/src/models/remote/weather_forecast_response.dart';
import 'package:feather/src/resources/app_const.dart';
import 'package:feather/src/resources/weather_manager.dart';
import 'package:feather/src/ui/widget/chart_painter_widget.dart';
import 'package:feather/src/ui/widget/widget_helper.dart';
import 'package:feather/src/utils/types_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WeatherForecastWidget extends StatelessWidget {
  final WeatherForecastHolder holder;
  final double width;
  final double height;

  const WeatherForecastWidget({Key key, this.holder, this.width, this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Point> points = _getPoints();
    List<String> pointLabels = _getPointLabels();
    List<LineAxis> axes = _getAxes(points);
    Widget imagesUnderChartRowWidget;
    if (points.length > 2) {
      imagesUnderChartRowWidget = Row(
        children: _getWeatherImages(points),
      );
    } else {
      imagesUnderChartRowWidget = Row();
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(holder.getLocationName(),
              style: Theme.of(context).textTheme.title),
          Text(holder.dateFullFormatted,
              style: Theme.of(context).textTheme.subtitle),
          WidgetHelper.buildPadding(top: 20),
          Hero(
              tag: AppConst.imageWeatherHeroTag + holder.dateShortFormatted,
              child: Image.asset(holder.weatherCodeAsset,
                  width: 100, height: 100)),
          Text(_getMaxMinTemperatureText(),
              style: Theme.of(context).textTheme.subtitle),
          WidgetHelper.buildPadding(top: 30),
          ChartWidget(
            height: height,
            width: width,
            points: points,
            pointLabels: pointLabels,
            axes: axes,
          ),
          WidgetHelper.buildPadding(top: 10),
          imagesUnderChartRowWidget
        ],
      ),
    );
  }

  String _getMaxMinTemperatureText() {
    return "↑${TypesHelper.formatTemperature(temperature: holder.maxTemperature, positions: 1, round: false)}    ↓${TypesHelper.formatTemperature(temperature: holder.minTemperature, positions: 1, round: false)}";
  }

  List<Point> _getPoints() {
    List<Point> points = List();
    double halfHeight = (height - AppConst.chartPadding) / 2;
    double widthStep = width / (holder.forecastList.length - 1);
    double currentX = 0;

    List<double> temperatures = _getTemperaturesList();
    double maxTemperature = _getAbsoluteMax(temperatures);

    for (double temp in temperatures) {
      var y = halfHeight - (halfHeight * temp / maxTemperature);
      points.add(Point(currentX, y));
      currentX += widthStep;
    }
    return points;
  }

  List<double> _getTemperaturesList() {
    List<double> temperatures = new List();
    double averageTemperature = holder.averageTemperature;
    for (WeatherForecastResponse forecastResponse in holder.forecastList) {
      double temperatureDiff =
          forecastResponse.mainWeatherData.temp - averageTemperature;
      temperatures.add(temperatureDiff);
    }
    return temperatures;
  }

  double _getAbsoluteMax(List<double> values) {
    double maxValue = 0;
    for (double value in values) {
      maxValue = max(maxValue, value.abs());
    }
    return maxValue;
  }

  List<LineAxis> _getAxes(List<Point> points) {
    List<LineAxis> list = new List();
    list.add(LineAxis(
        TypesHelper.formatTemperature(
            temperature: holder.averageTemperature, positions: 1, round: false),
        Offset(-25, height / 2 - 15),
        Offset(-5, (height - AppConst.chartPadding) / 2),
        Offset(width + 5, (height - AppConst.chartPadding) / 2)));

    for (int index = 0; index < points.length; index++) {
      Point point = points[index];
      DateTime dateTime = holder.forecastList[index].dateTime;
      list.add(LineAxis(
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

  List<String> _getPointLabels() {
    List<String> points = List();
    for (WeatherForecastResponse forecastResponse in holder.forecastList) {
      points.add(forecastResponse.mainWeatherData.temp.toStringAsFixed(1));
    }
    return points;
  }

  List<Widget> _getWeatherImages(List<Point> points) {
    List<Widget> widgets = new List();
    if (points.length > 1) {
      double padding = points[1].x - points[0].x - 30;
      widgets.add(WidgetHelper.buildPadding(left: 15, top: 5));
      for (int index = 0; index < points.length; index++) {
        widgets.add(Image.asset(
            WeatherManager.getWeatherIcon(
                holder.forecastList[index].overallWeatherData[0].id),
            width: 30,
            height: 30));
        widgets.add(WidgetHelper.buildPadding(left: padding));
      }
      widgets.removeLast();
    }

    return widgets;
  }
}
