import 'package:feather/src/models/internal/chart_data.dart';
import 'package:feather/src/models/internal/weather_forecast_holder.dart';
import 'package:feather/src/resources/application_localization.dart';
import 'package:feather/src/resources/config/assets.dart';
import 'package:feather/src/resources/weather_helper.dart';
import 'package:feather/src/ui/screen/base/weather_forecast_base_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WeatherForecastRainPage extends WeatherForecastBasePage {
  WeatherForecastRainPage(
      WeatherForecastHolder holder, double width, double height)
      : super(holder: holder, width: width, height: height);

  @override
  Row getBottomRowWidget(BuildContext context) {
    return Row(
      key: Key("weather_forecast_rain_page_bottom_row"),
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }

  @override
  ChartData getChartData() {
    return super.holder.setupChartData(ChartDataType.rain, width, height);
  }

  @override
  String getIcon() {
    return Assets.iconRain;
  }

  @override
  RichText getPageSubtitleWidget(BuildContext context) {
    return RichText(
        key: Key("weather_forecast_rain_page_subtitle"),
        textDirection: TextDirection.ltr,
        text: TextSpan(children: [
          TextSpan(text: 'min ', style: Theme.of(context).textTheme.body2),
          TextSpan(
              text: WeatherHelper.formatRain(holder.minRain),
              style: Theme.of(context).textTheme.subtitle),
          TextSpan(text: '   max ', style: Theme.of(context).textTheme.body2),
          TextSpan(
              text: WeatherHelper.formatRain(holder.maxRain),
              style: Theme.of(context).textTheme.subtitle)
        ]));
  }

  @override
  String getTitleText(BuildContext context) {
    return ApplicationLocalization.of(context).getText("rain");
  }
}
