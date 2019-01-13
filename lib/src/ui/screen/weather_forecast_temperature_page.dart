import 'package:feather/src/models/internal/chart_data.dart';
import 'package:feather/src/models/internal/point.dart';
import 'package:feather/src/models/internal/weather_forecast_holder.dart';
import 'package:feather/src/resources/weather_manager.dart';
import 'package:feather/src/ui/widget/chart_widget.dart';
import 'package:feather/src/ui/widget/widget_helper.dart';
import 'package:feather/src/utils/types_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WeatherForecastTemperaturePage extends StatelessWidget {
  final WeatherForecastHolder holder;
  final double width;
  final double height;

  const WeatherForecastTemperaturePage({Key key, this.holder, this.width, this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ChartData chartData =
    holder.setupChartData(ChartDataType.temperature, width, height);
    return Center(
        child: Column(children: [
          getPageIcon(context),
          getPageText(context),
          WidgetHelper.buildPadding(top: 20),
          getLineAboveChart(context),
          WidgetHelper.buildPadding(top: 40),
          ChartWidget(
              points: chartData.points,
              pointLabels: chartData.pointLabels,
              width: width,
              height: height,
              axes: chartData.axes),
          _getWeatherImages(chartData.points)
        ]));
  }

  Widget getPageIcon(BuildContext context){
    return Image.asset(holder.weatherCodeAsset,
        width: 100, height: 100);
  }

  Widget getPageText(BuildContext context){
    return Text("Temperature",style: Theme.of(context).textTheme.subtitle);
  }

  Widget getLineAboveChart(BuildContext context) {
    return RichText(
        text: TextSpan(children: [
          TextSpan(text: 'min ', style: Theme.of(context).textTheme.body2),
          TextSpan(
              text: "${TypesHelper.formatTemperature(temperature: holder.maxTemperature, positions: 1, round: false)}",
              style: Theme.of(context).textTheme.subtitle),
          TextSpan(text: '   max ', style: Theme.of(context).textTheme.body2),
          TextSpan(
              text: "${TypesHelper.formatTemperature(temperature: holder.minTemperature, positions: 1, round: false)}",
              style: Theme.of(context).textTheme.subtitle)
        ]));
  }

  Row _getWeatherImages(List<Point> points) {
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

    return Row(children: widgets);
  }

}
