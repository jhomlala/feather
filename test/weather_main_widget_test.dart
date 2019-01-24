import 'package:feather/src/blocs/weather_bloc.dart';
import 'package:feather/src/models/internal/application_error.dart';
import 'package:feather/src/models/remote/main_weather_data.dart';
import 'package:feather/src/models/remote/overall_weather_data.dart';
import 'package:feather/src/models/remote/system.dart';
import 'package:feather/src/models/remote/weather_response.dart';
import 'package:feather/src/models/remote/wind.dart';
import 'package:feather/src/ui/widget/weather_main_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helper.dart';

main() {
  testWidgets("Weather widget should display error",
      (WidgetTester tester) async {
    await tester.runAsync(() async {
      bloc.weatherSubject.sink
          .add(WeatherResponse.withErrorCode(ApplicationError.apiError));
      await tester.pump(new Duration(seconds: 5));
      await tester.pumpWidget(TestHelper.wrapWidgetWithLocalizationApp(WeatherMainWidget()));
      await tester.idle();
      expect(find.byKey(Key("progress_indicator")), findsOneWidget);
      await tester.idle();
      await tester.pump(new Duration(seconds: 5));
      expect(find.byKey(Key("error_widget")), findsOneWidget);
    });
  });

  testWidgets("Weather widget should show widgets",
          (WidgetTester tester) async {
    //todo: Find out why these tests fail on Travis
            /*await tester.runAsync(() async {
          bloc.weatherSubject.sink.add(setupWeatherResponse());
          await tester.pump(new Duration(seconds: 5));
          await tester.pumpWidget(TestHelper.wrapWidgetWithLocalizationApp(WeatherMainWidget()));
          expect(find.byKey(Key("progress_indicator")), findsOneWidget);
          await tester.idle();
          await tester.pump(new Duration(seconds: 5));

          expect(find.byKey(Key("weather_main_widget_container")), findsOneWidget);
          expect(find.byKey(Key("weather_main_widget_city_name")), findsOneWidget);
          expect(find.byKey(Key("weather_main_widget_date")), findsOneWidget);
          expect(find.byKey(Key("weather_main_swiper")), findsOneWidget);
        });
    */
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
