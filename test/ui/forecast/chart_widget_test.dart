import 'package:feather/src/data/model/internal/chart_data.dart';
import 'package:feather/src/data/model/internal/weather_forecast_holder.dart';
import 'package:feather/src/data/model/remote/city.dart';
import 'package:feather/src/data/model/remote/main_weather_data.dart';
import 'package:feather/src/data/model/remote/overall_weather_data.dart';
import 'package:feather/src/data/model/remote/rain.dart';
import 'package:feather/src/data/model/remote/system.dart';
import 'package:feather/src/data/model/remote/weather_forecast_response.dart';
import 'package:feather/src/data/model/remote/wind.dart';
import 'package:feather/src/ui/forecast/widget/chart_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_helper.dart';

void main() {
  testWidgets("Chart widget should display chart", (WidgetTester tester) async {
    await tester.pumpWidget(TestHelper.wrapWidgetWithLocalizationApp(
        ChartWidget(chartData: setupChartData())));

    expect(find.byKey(const Key("chart_widget_container")), findsOneWidget);
    expect(find.byKey(const Key("chart_widget_custom_paint")), findsOneWidget);
  });

  testWidgets("Chart widget should not display chart",
      (WidgetTester tester) async {
    await tester.pumpWidget(
      TestHelper.wrapWidgetWithLocalizationApp(
        ChartWidget(
          chartData: setupEmptyChartData(),
        ),
      ),
    );
    expect(find.byKey(const Key("chart_widget_container")), findsOneWidget);
    expect(find.byKey(const Key("chart_widget_custom_paint")), findsNothing);
    expect(find.byKey(const Key("chart_widget_unavailable")), findsOneWidget);
  });
}

ChartData setupEmptyChartData() {
  return setupWeatherForecastHolder(1)
      .setupChartData(ChartDataType.rain, 300, 100, false);
}

ChartData setupChartData() {
  return setupWeatherForecastHolder(8)
      .setupChartData(ChartDataType.rain, 300, 100, false);
}

WeatherForecastHolder setupWeatherForecastHolder(int objectsCount) {
  final List<WeatherForecastResponse> forecastList =
      <WeatherForecastResponse>[];

  for (int index = 0; index < objectsCount; index++) {
    final DateTime dateTime = DateTime.utc(2019, 1, index + 1);
    forecastList.add(buildForecastResponseForDateTime(dateTime));
  }
  final System system = System(null, 0, 0);
  final City city = City(0, null);
  final WeatherForecastHolder holder =
      WeatherForecastHolder(forecastList, city, system);
  return holder;
}

WeatherForecastResponse buildForecastResponseForDateTime(DateTime dateTime) {
  final Wind wind = Wind(5, 200);
  final MainWeatherData mainWeatherData = MainWeatherData(0, 0, 0, 0, 0, 0, 0);
  final OverallWeatherData overallWeatherData =
      OverallWeatherData(0, "", "", "");
  final List<OverallWeatherData> list = [];
  list.add(overallWeatherData);
  final Rain rain = Rain(0);
  final Rain snow = Rain(0);
  return WeatherForecastResponse(
      mainWeatherData, list, null, wind, dateTime, rain, snow);
}
