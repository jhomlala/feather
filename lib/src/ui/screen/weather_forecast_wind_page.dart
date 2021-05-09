import 'package:feather/src/model/internal/chart_data.dart';
import 'package:feather/src/model/internal/point.dart';
import 'package:feather/src/model/internal/weather_forecast_holder.dart';
import 'package:feather/src/resources/application_localization.dart';
import 'package:feather/src/resources/config/assets.dart';
import 'package:feather/src/resources/weather_helper.dart';
import 'package:feather/src/ui/screen/base/weather_forecast_base_page.dart';
import 'package:feather/src/ui/widget/widget_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WeatherForecastWindPage extends WeatherForecastBasePage {
  WeatherForecastWindPage(
      WeatherForecastHolder? holder, double? width, double? height, bool isMetricUnits)
      : super(holder: holder, width: width, height: height, isMetricUnits: isMetricUnits);

  @override
  Row getBottomRowWidget(BuildContext context) {
    List<Widget> rowElements = [];
    List<Point> points = getChartData().points!;
    if (points.length > 2) {
      double padding = points[1].x - points[0].x - 30;
      for (String direction in holder!.getWindDirectionList()) {
        rowElements.add(SizedBox(
            width: 30,
            child: Center(
                child: Text(direction,
                    textDirection: TextDirection.ltr,
                    style: Theme.of(context).textTheme.bodyText1))));
        rowElements.add(WidgetHelper.buildPadding(left: padding));
      }
      rowElements.removeLast();
    }
    return Row(
        key: Key("weather_forecast_wind_page_bottom_row"),
        mainAxisAlignment: MainAxisAlignment.center,
        children: rowElements);
  }

  @override
  ChartData getChartData() {
    return super.holder!.setupChartData(ChartDataType.wind, width!, height!,isMetricUnits);
  }

  @override
  String getIcon() {
    return Assets.iconWind;
  }

  @override
  RichText getPageSubtitleWidget(BuildContext context) {


    var minWind = holder!.minWind;
    var maxWind = holder!.maxWind;
    if (isMetricUnits){
      minWind = WeatherHelper.convertMetersPerSecondToKilometersPerHour(minWind);
      maxWind = WeatherHelper.convertMetersPerSecondToKilometersPerHour(maxWind);
    } else {
      minWind = WeatherHelper.convertMetersPerSecondToMilesPerHour(minWind);
      maxWind = WeatherHelper.convertMetersPerSecondToMilesPerHour(maxWind);
    }

    return RichText(
        key: Key("weather_forecast_wind_page_subtitle"),
        textDirection: TextDirection.ltr,
        text: TextSpan(children: [
          TextSpan(text: 'min ', style: Theme.of(context).textTheme.bodyText1),
          TextSpan(
              text: WeatherHelper.formatWind(minWind,isMetricUnits),
              style: Theme.of(context).textTheme.subtitle2),
          TextSpan(text: '   max ', style: Theme.of(context).textTheme.bodyText1),
          TextSpan(
              text: WeatherHelper.formatWind(maxWind,isMetricUnits),
              style: Theme.of(context).textTheme.subtitle2)
        ]));
  }

  @override
  String? getTitleText(BuildContext context) {
    return ApplicationLocalization.of(context)!.getText("wind");
  }
}
