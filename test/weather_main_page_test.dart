import 'package:feather/src/models/remote/main_weather_data.dart';
import 'package:feather/src/models/remote/overall_weather_data.dart';
import 'package:feather/src/models/remote/system.dart';
import 'package:feather/src/models/remote/weather_response.dart';
import 'package:feather/src/models/remote/wind.dart';
import 'package:feather/src/ui/screen/weather_main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helper.dart';

main() {
  testWidgets("Weather main page should show widgets",
      (WidgetTester tester) async {
    await tester
        .pumpWidget(TestHelper.wrapWidgetWithLocalizationApp(WeatherMainPage(
      weatherResponse: setupWeatherResponse(),
    )));

    expect(
        find.byKey(Key("weather_main_page_current_weather")), findsOneWidget);
  });
}

WeatherResponse setupWeatherResponse() {
  Wind wind = new Wind(5, 200);
  MainWeatherData mainWeatherData = MainWeatherData(0, 0, 0, 0, 0, 0, 0);
  OverallWeatherData overallWeatherData = OverallWeatherData(0, "", "", "");
  List<OverallWeatherData> list = new List();
  list.add(overallWeatherData);
  System system = System("", 0, 0);
  WeatherResponse weatherResponse = WeatherResponse(
      wind: wind,
      mainWeatherData: mainWeatherData,
      overallWeatherData: list,
      name: "",
      system: system);
  return weatherResponse;
}
