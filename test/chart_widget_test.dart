import 'package:feather/src/models/internal/chart_data.dart';
import 'package:feather/src/models/internal/weather_forecast_holder.dart';
import 'package:feather/src/models/remote/city.dart';
import 'package:feather/src/models/remote/main_weather_data.dart';
import 'package:feather/src/models/remote/overall_weather_data.dart';
import 'package:feather/src/models/remote/rain.dart';
import 'package:feather/src/models/remote/system.dart';
import 'package:feather/src/models/remote/weather_forecast_response.dart';
import 'package:feather/src/models/remote/wind.dart';
import 'package:feather/src/ui/widget/chart_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helper.dart';

main() {
  testWidgets("Chart widget should display chart", (WidgetTester tester) async {
    await tester.pumpWidget(TestHelper.wrapWidgetWithLocalizationApp(
        ChartWidget(chartData: setupChartData())));

    expect(find.byKey(Key("chart_widget_container")), findsOneWidget);
    expect(find.byKey(Key("chart_widget_custom_paint")), findsOneWidget);
  });

  testWidgets("Chart widget should not display chart",
      (WidgetTester tester) async {
    await tester.pumpWidget(TestHelper.wrapWidgetWithLocalizationApp(
        ChartWidget(chartData: setupEmptyChartData())));
    expect(find.byKey(Key("chart_widget_container")), findsOneWidget);
    expect(find.byKey(Key("chart_widget_custom_paint")), findsNothing);
    expect(find.byKey(Key("chart_widget_unavailable")), findsOneWidget);
  });
}

ChartData setupEmptyChartData() {
  return setupWeatherForecastHolder(1)
      .setupChartData(ChartDataType.rain, 300, 100);
}

ChartData setupChartData() {
  return setupWeatherForecastHolder(8)
      .setupChartData(ChartDataType.rain, 300, 100);
}

WeatherForecastHolder setupWeatherForecastHolder(int objectsCount) {
  List<WeatherForecastResponse> forecastList =
      new List<WeatherForecastResponse>();

  for (int index = 0; index < objectsCount; index++) {
    DateTime dateTime = DateTime.utc(2019, 1, index + 1);
    forecastList.add(buildForecastResponseForDateTime(dateTime));
  }

  System system = System(null, 0, 0);
  City city = City(0, null);

  WeatherForecastHolder holder =
      new WeatherForecastHolder(forecastList, city, system);

  return holder;
}

WeatherForecastResponse buildForecastResponseForDateTime(DateTime dateTime) {
  Wind wind = new Wind(5, 200);
  MainWeatherData mainWeatherData = MainWeatherData(0, 0, 0, 0, 0, 0, 0);
  OverallWeatherData overallWeatherData = OverallWeatherData(0, "", "", "");
  List<OverallWeatherData> list = new List();
  list.add(overallWeatherData);
  Rain rain = Rain(0);
  Rain snow = Rain(0);
  return new WeatherForecastResponse(
      mainWeatherData, list, null, wind, dateTime, rain, snow);
}
