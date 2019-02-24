import 'package:feather/src/models/remote/main_weather_data.dart';
import 'package:feather/src/models/remote/overall_weather_data.dart';
import 'package:feather/src/models/remote/system.dart';
import 'package:feather/src/models/remote/weather_response.dart';
import 'package:feather/src/models/remote/wind.dart';
import 'package:feather/src/ui/widget/weather_current_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helper.dart';

main() {
  testWidgets("Weather widget should show widgets",
      (WidgetTester tester) async {
    await tester.pumpWidget(
        TestHelper.wrapWidgetWithLocalizationApp(WeatherCurrentWidget(
      weatherResponse: setupWeatherResponse(),
    )));

    expect(find.byKey(Key("weather_current_widget_container")), findsOneWidget);
    expect(
        find.byKey(Key("weather_current_widget_temperature")), findsOneWidget);
    expect(find.byKey(Key("weather_current_widget_min_max_temperature")),
        findsOneWidget);
    expect(find.byKey(Key("weather_current_widget_pressure_humidity")),
        findsOneWidget);
    expect(find.byKey(Key("weather_current_widget_thumbnail_list")),
        findsOneWidget);
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
