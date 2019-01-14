import 'package:feather/src/models/internal/chart_data.dart';
import 'package:feather/src/models/internal/weather_forecast_holder.dart';
import 'package:feather/src/ui/screen/weather_forecast_base_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WeatherForecastPressurePage extends WeatherForecastBasePage {
  WeatherForecastPressurePage(
      WeatherForecastHolder holder, double width, double height)
      : super(holder: holder, width: width, height: height);


  @override
  Row getBottomRowWidget(BuildContext context) {
   return Row();
  }

  @override
  ChartData getChartData() {
   return super.holder.setupChartData(ChartDataType.pressure, width, height);
  }

  @override
  String getIcon() {
    return "assets/icon_barometer.png";
  }

  @override
  RichText getPageSubtitleWidget(BuildContext context) {
    return RichText(
        text: TextSpan(children: [
          TextSpan(text: 'min ', style: Theme.of(context).textTheme.body2),
          TextSpan(
              text: "${holder.minPressure.toStringAsFixed(0)} hPa",
              style: Theme.of(context).textTheme.subtitle),
          TextSpan(text: '   max ', style: Theme.of(context).textTheme.body2),
          TextSpan(
              text: "${holder.maxRain.toStringAsFixed(0)} hPa",
              style: Theme.of(context).textTheme.subtitle)
        ]));
  }

  @override
  String getTitleText() {
    return "Pressure";
  }
}
