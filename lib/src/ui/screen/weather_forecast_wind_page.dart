import 'package:feather/src/models/internal/chart_data.dart';
import 'package:feather/src/models/internal/point.dart';
import 'package:feather/src/models/internal/weather_forecast_holder.dart';
import 'package:feather/src/resources/config/assets.dart';
import 'package:feather/src/ui/screen/weather_forecast_base_page.dart';
import 'package:feather/src/ui/widget/widget_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WeatherForecastWindPage extends WeatherForecastBasePage {
  WeatherForecastWindPage(
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
                    textDirection: TextDirection.ltr,
                    style: Theme.of(context).textTheme.body2))));
        rowElements.add(WidgetHelper.buildPadding(left: padding));
      }
      rowElements.removeLast();
    }
    return Row( key: Key("weather_forecast_wind_page_bottom_row"),
        mainAxisAlignment: MainAxisAlignment.center, children: rowElements);
  }

  @override
  ChartData getChartData() {
    return super.holder.setupChartData(ChartDataType.wind, width, height);
  }

  @override
  String getIcon() {
    return Assets.iconWind;
  }

  @override
  RichText getPageSubtitleWidget(BuildContext context) {
    return RichText(
        key: Key("weather_forecast_wind_page_subtitle"),
        textDirection: TextDirection.ltr,
        text: TextSpan(children: [
          TextSpan(text: 'min ', style: Theme.of(context).textTheme.body2),
          TextSpan(
              text: "${holder.minWind.toStringAsFixed(1)} km/h",
              style: Theme.of(context).textTheme.subtitle),
          TextSpan(text: '   max ', style: Theme.of(context).textTheme.body2),
          TextSpan(
              text: "${holder.maxWind.toStringAsFixed(1)} km/h",
              style: Theme.of(context).textTheme.subtitle)
        ]));
  }

  @override
  String getTitleText() {
    return "Wind";
  }
}
