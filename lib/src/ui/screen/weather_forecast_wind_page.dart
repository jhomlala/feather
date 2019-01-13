import 'package:feather/src/models/internal/chart_data.dart';
import 'package:feather/src/models/internal/point.dart';
import 'package:feather/src/models/internal/weather_forecast_holder.dart';
import 'package:feather/src/ui/widget/chart_widget.dart';
import 'package:feather/src/ui/widget/widget_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WeatherForecastWindPage extends StatelessWidget {
  final WeatherForecastHolder holder;
  final double width;
  final double height;

  const WeatherForecastWindPage({Key key, this.holder, this.width, this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ChartData chartData =
        holder.setupChartData(ChartDataType.wind, width, height);
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
      getWindDirectionRow(context, chartData)
    ]));
  }

  Widget getPageIcon(BuildContext context){
    return Image.asset("assets/icon_wind.png",
        width: 100, height: 100);
  }

  Widget getPageText(BuildContext context){
    return Text("Wind",style: Theme.of(context).textTheme.subtitle);
  }

  Widget getLineAboveChart(BuildContext context) {
    return RichText(
        text: TextSpan(children: [
      TextSpan(text: 'min ', style: Theme.of(context).textTheme.body2),
      TextSpan(
          text: "${holder.minWind.toStringAsFixed(1)} m/s",
          style: Theme.of(context).textTheme.subtitle),
      TextSpan(text: '   max ', style: Theme.of(context).textTheme.body2),
      TextSpan(
          text: "${holder.maxWind.toStringAsFixed(1)} m/s",
          style: Theme.of(context).textTheme.subtitle)
    ]));
  }


  Widget getWindDirectionRow(BuildContext context, ChartData chartData) {
    List<Widget> rowElements = new List();
    List<Point> points = chartData.points;
    if (points.length > 1) {
      double padding = points[1].x - points[0].x - 30;

      rowElements.add(WidgetHelper.buildPadding(left: 15));
      for (String direction in holder.getWindDirectionList()) {
        rowElements.add(SizedBox(
            width: 30,
            child: Center(
                child: Text(direction,
                    style: Theme.of(context).textTheme.body2))));
        rowElements.add(WidgetHelper.buildPadding(left: padding));
      }
      rowElements.removeLast();
    }
    return Row(children: rowElements);
  }
}
