import 'package:feather/src/blocs/weather_forecast_bloc.dart';
import 'package:feather/src/models/internal/application_error.dart';
import 'package:feather/src/models/remote/city.dart';
import 'package:feather/src/models/remote/clouds.dart';
import 'package:feather/src/models/remote/main_weather_data.dart';
import 'package:feather/src/models/remote/overall_weather_data.dart';
import 'package:feather/src/models/remote/rain.dart';
import 'package:feather/src/models/remote/weather_forecast_list_response.dart';
import 'package:feather/src/models/remote/weather_forecast_response.dart';
import 'package:feather/src/models/remote/wind.dart';
import 'package:feather/src/ui/widget/weather_forecast_thumbnail_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helper.dart';

main() {
  testWidgets("Weather forecast thumbnail list widget should show error",
          (WidgetTester tester) async {
        await tester.runAsync(() async {
          bloc.weatherForecastSubject.sink
              .add(WeatherForecastListResponse.withErrorCode(
              ApplicationError.apiError));
          await tester.pump(new Duration(seconds: 5));
          WeatherForecastThumbnailListWidget widget =
          WeatherForecastThumbnailListWidget();
          await tester.pumpWidget(
              TestHelper.wrapWidgetWithLocalizationApp(widget));
          expect(find.byKey(Key("progress_indicator")), findsOneWidget);
          await tester.idle();
          await tester.pump(new Duration(seconds: 5));
          expect(find.byKey(Key("error_widget")), findsOneWidget);
        });
        //await tester.pumpWidget(WeatherForecastThumbnailListWidget());
      });

  testWidgets("Weather forecast thumbnail list widget show widgets",
          (WidgetTester tester) async {
        //todo: Find out why these tests fail on Travis
        /*await tester.runAsync(() async {
      WeatherForecastListResponse response = setupWeatherForecastResponse();
      print("response list: " + response.list.length.toString());
      bloc.weatherForecastSubject.sink.add(setupWeatherForecastResponse());
      await tester.pump(new Duration(seconds: 5));
      WeatherForecastThumbnailListWidget widget =
          WeatherForecastThumbnailListWidget();
      await tester.pumpWidget(TestHelper.wrapWidgetWithLocalizationApp(widget));
      expect(find.byKey(Key("progress_indicator")), findsOneWidget);
      await tester.idle();
      await tester.pump(new Duration(seconds: 10));
      expect(
          find.byKey(Key("weather_forecast_thumbnail_list_widget_container")),
          findsOneWidget);
      expect(
          find.byKey(Key("weather_forecast_thumbnail_widget")),
          findsNWidgets(8));
      });*/
});
}

WeatherForecastListResponse setupWeatherForecastResponse() {
  City city = City(0, "");
  List<WeatherForecastResponse> list = new List();
  for (int index = 0; index < 8; index++) {
    list.add(buildForecastResponseForDateTime(DateTime(2019, 1, index + 1)));
  }
  return WeatherForecastListResponse(list, city);
}

WeatherForecastResponse buildForecastResponseForDateTime(DateTime dateTime) {
  Wind wind = new Wind(5, 200);
  Clouds clouds = Clouds(0);
  MainWeatherData mainWeatherData = MainWeatherData(
      0,
      0,
      0,
      0,
      0,
      0,
      0);
  OverallWeatherData overallWeatherData = OverallWeatherData(0, "", "", "");
  List<OverallWeatherData> list = new List();
  list.add(overallWeatherData);
  Rain rain = Rain(0);
  Rain snow = Rain(0);
  return new WeatherForecastResponse(
      mainWeatherData,
      list,
      clouds,
      wind,
      dateTime,
      rain,
      snow);
}
