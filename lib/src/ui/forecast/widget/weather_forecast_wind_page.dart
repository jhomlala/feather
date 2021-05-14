import 'package:feather/src/data/model/internal/chart_data.dart';
import 'package:feather/src/data/model/internal/point.dart';
import 'package:feather/src/data/model/internal/weather_forecast_holder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:feather/src/resources/config/assets.dart';
import 'package:feather/src/data/repository/local/weather_helper.dart';
import 'package:feather/src/ui/forecast/widget/weather_forecast_base_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WeatherForecastWindPage extends WeatherForecastBasePage {
  const WeatherForecastWindPage(
    WeatherForecastHolder? holder,
    double? width,
    double? height,
    bool isMetricUnits, {
    Key? key,
  }) : super(
          holder: holder,
          width: width,
          height: height,
          isMetricUnits: isMetricUnits,
          key: key,
        );

  @override
  Row getBottomRowWidget(BuildContext context) {
    final List<Widget> rowElements = [];
    final List<Point> points = getChartData().points!;
    if (points.length > 2) {
      final double padding = points[1].x - points[0].x - 30;
      for (final String direction in holder!.getWindDirectionList()) {
        rowElements.add(
          SizedBox(
            width: 30,
            child: Center(
              child: Text(direction,
                  textDirection: TextDirection.ltr,
                  style: Theme.of(context).textTheme.bodyText1),
            ),
          ),
        );
        rowElements.add(SizedBox(width: padding));
      }
      rowElements.removeLast();
    }
    return Row(
      key: const Key("weather_forecast_wind_page_bottom_row"),
      mainAxisAlignment: MainAxisAlignment.center,
      children: rowElements,
    );
  }

  @override
  ChartData getChartData() {
    return super
        .holder!
        .setupChartData(ChartDataType.wind, width!, height!, isMetricUnits);
  }

  @override
  String getIcon() {
    return Assets.iconWind;
  }

  @override
  RichText getPageSubtitleWidget(BuildContext context) {
    var minWind = holder!.minWind;
    var maxWind = holder!.maxWind;
    if (isMetricUnits) {
      minWind =
          WeatherHelper.convertMetersPerSecondToKilometersPerHour(minWind);
      maxWind =
          WeatherHelper.convertMetersPerSecondToKilometersPerHour(maxWind);
    } else {
      minWind = WeatherHelper.convertMetersPerSecondToMilesPerHour(minWind);
      maxWind = WeatherHelper.convertMetersPerSecondToMilesPerHour(maxWind);
    }

    return RichText(
      key: const Key("weather_forecast_wind_page_subtitle"),
      textDirection: TextDirection.ltr,
      text: TextSpan(
        children: [
          TextSpan(text: 'min ', style: Theme.of(context).textTheme.bodyText1),
          TextSpan(
              text: WeatherHelper.formatWind(minWind, isMetricUnits),
              style: Theme.of(context).textTheme.subtitle2),
          TextSpan(
              text: '   max ', style: Theme.of(context).textTheme.bodyText1),
          TextSpan(
              text: WeatherHelper.formatWind(maxWind, isMetricUnits),
              style: Theme.of(context).textTheme.subtitle2)
        ],
      ),
    );
  }

  @override
  String? getTitleText(BuildContext context) {
    return AppLocalizations.of(context)!.wind;
  }
}
