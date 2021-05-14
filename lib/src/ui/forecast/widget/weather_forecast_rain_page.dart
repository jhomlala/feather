import 'package:feather/src/data/model/internal/chart_data.dart';
import 'package:feather/src/data/model/internal/weather_forecast_holder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:feather/src/resources/config/assets.dart';
import 'package:feather/src/data/repository/local/weather_helper.dart';
import 'package:feather/src/ui/forecast/widget/weather_forecast_base_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WeatherForecastRainPage extends WeatherForecastBasePage {
  const WeatherForecastRainPage(WeatherForecastHolder? holder, double? width,
      double? height, bool isMetricUnits, {Key? key})
      : super(
            holder: holder,
            width: width,
            height: height,
            isMetricUnits: isMetricUnits,
            key: key);

  @override
  Row getBottomRowWidget(BuildContext context) {
    return Row(
      key: const Key("weather_forecast_rain_page_bottom_row"),
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }

  @override
  ChartData getChartData() {
    return super
        .holder!
        .setupChartData(ChartDataType.rain, width!, height!, isMetricUnits);
  }

  @override
  String getIcon() {
    return Assets.iconRain;
  }

  @override
  RichText getPageSubtitleWidget(BuildContext context) {
    return RichText(
      key: const Key("weather_forecast_rain_page_subtitle"),
      textDirection: TextDirection.ltr,
      text: TextSpan(
        children: [
          TextSpan(text: 'min ', style: Theme.of(context).textTheme.bodyText1),
          TextSpan(
              text: WeatherHelper.formatRain(holder!.minRain!),
              style: Theme.of(context).textTheme.subtitle2),
          TextSpan(
              text: '   max ', style: Theme.of(context).textTheme.bodyText1),
          TextSpan(
              text: WeatherHelper.formatRain(holder!.maxRain!),
              style: Theme.of(context).textTheme.subtitle2)
        ],
      ),
    );
  }

  @override
  String? getTitleText(BuildContext context) {
    return AppLocalizations.of(context)!.rain;
  }
}
