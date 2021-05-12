import 'package:feather/src/data/model/internal/chart_data.dart';
import 'package:feather/src/data/model/internal/weather_forecast_holder.dart';
import 'package:feather/src/ui/forecast/widget/chart_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

abstract class WeatherForecastBasePage extends StatelessWidget {
  final WeatherForecastHolder? holder;
  final double? width;
  final double? height;
  final bool isMetricUnits;

  const WeatherForecastBasePage({
    Key? key,
    required this.holder,
    required this.width,
    required this.height,
    required this.isMetricUnits,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ChartData chartData = getChartData();
    return Center(
      child: Column(
        children: [
          getPageIconWidget(),
          getPageTitleWidget(context),
          const SizedBox(height: 20),
          getPageSubtitleWidget(context),
          const SizedBox(height: 40),
          ChartWidget(
              key: const Key("weather_forecast_base_page_chart"),
              chartData: chartData),
          const SizedBox(height: 10),
          getBottomRowWidget(context)
        ],
      ),
    );
  }

  Image getPageIconWidget() {
    return Image.asset(
      getIcon(),
      key: const Key("weather_forecast_base_page_icon"),
      width: 100,
      height: 100,
    );
  }

  Widget getPageTitleWidget(BuildContext context) {
    return Text(getTitleText(context)!,
        key: const Key("weather_forecast_base_page_title"),
        textDirection: TextDirection.ltr,
        style: Theme.of(context).textTheme.subtitle2);
  }

  String getIcon();

  String? getTitleText(BuildContext context);

  RichText getPageSubtitleWidget(BuildContext context);

  Widget getBottomRowWidget(BuildContext context);

  ChartData getChartData();
}
