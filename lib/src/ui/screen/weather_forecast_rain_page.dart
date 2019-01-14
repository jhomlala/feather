import 'package:feather/src/models/internal/chart_data.dart';
import 'package:feather/src/models/internal/point.dart';
import 'package:feather/src/models/internal/weather_forecast_holder.dart';
import 'package:feather/src/ui/screen/weather_forecast_base_page.dart';
import 'package:feather/src/ui/widget/widget_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WeatherForecastRainPage extends WeatherForecastBasePage {
  WeatherForecastRainPage(
      WeatherForecastHolder holder, double width, double height)
      : super(holder: holder, width: width, height: height);


  @override
  Row getBottomRowWidget(BuildContext context) {
    List<Widget> rowElements = new List();
    List<Point> points = getChartData().points;
    if (points.length > 2) {
      double padding = points[1].x - points[0].x - 30;
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
    return Row(mainAxisAlignment: MainAxisAlignment.center,children: rowElements);
  }

  @override
  ChartData getChartData() {
   return super.holder.setupChartData(ChartDataType.rain, width, height);
  }

  @override
  String getIcon() {
    return "assets/icon_rain.png";
  }

  @override
  RichText getPageSubtitleWidget(BuildContext context) {
    return RichText(
        text: TextSpan(children: [
          TextSpan(text: 'min ', style: Theme.of(context).textTheme.body2),
          TextSpan(
              text: "${holder.minRain.toStringAsFixed(2)} mm/h",
              style: Theme.of(context).textTheme.subtitle),
          TextSpan(text: '   max ', style: Theme.of(context).textTheme.body2),
          TextSpan(
              text: "${holder.maxRain.toStringAsFixed(2)} mm/h",
              style: Theme.of(context).textTheme.subtitle)
        ]));
  }

  @override
  String getTitleText() {
    return "Rain";
  }
}
