import 'package:feather/src/data/model/remote/city.dart';
import 'package:feather/src/data/model/remote/clouds.dart';
import 'package:feather/src/data/model/remote/main_weather_data.dart';
import 'package:feather/src/data/model/remote/overall_weather_data.dart';
import 'package:feather/src/data/model/remote/rain.dart';
import 'package:feather/src/data/model/remote/system.dart';
import 'package:feather/src/data/model/remote/weather_forecast_list_response.dart';
import 'package:feather/src/data/model/remote/weather_forecast_response.dart';
import 'package:feather/src/data/model/remote/wind.dart';
import 'package:feather/src/data/repository/local/application_local_repository.dart';
import 'package:feather/src/data/repository/local/storage_manager.dart';
import 'package:feather/src/data/repository/local/storage_provider.dart';
import 'package:feather/src/ui/app/app_bloc.dart';
import 'package:feather/src/ui/main/widget/weather_forecast_thumbnail_list_widget.dart';
import 'package:feather/src/ui/navigation/bloc/navigation_bloc.dart';
import 'package:feather/src/ui/navigation/navigation_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../test_helper.dart';

void main() {
  testWidgets("Weather forecast thumbnail list widget show widgets",
      (WidgetTester tester) async {
    await tester.runAsync(() async {
      final WeatherForecastThumbnailListWidget widget =
          WeatherForecastThumbnailListWidget(
        system: setupSystem(),
        forecastListResponse: setupWeatherForecastResponse(),
      );
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<AppBloc>(
              create: (context) => AppBloc(
                ApplicationLocalRepository(
                  StorageManager(StorageProvider()),
                ),
              ),
            ),
            BlocProvider<NavigationBloc>(
              create: (context) => NavigationBloc(NavigationProvider(), GlobalKey()),
            )
          ],
          child: TestHelper.wrapWidgetWithLocalizationApp(widget),
        ),
      );
      expect(
          find.byKey(
              const Key("weather_forecast_thumbnail_list_widget_container")),
          findsOneWidget);
      expect(find.byKey(const Key("weather_forecast_thumbnail_widget")),
          findsNWidgets(8));
    });
  });
}

System setupSystem() {
  return System("", 0, 0);
}

WeatherForecastListResponse setupWeatherForecastResponse() {
  final City city = City(0, "");
  final List<WeatherForecastResponse> list = [];
  for (int index = 0; index < 8; index++) {
    list.add(buildForecastResponseForDateTime(DateTime(2019, 1, index + 1)));
  }
  return WeatherForecastListResponse(list, city);
}

WeatherForecastResponse buildForecastResponseForDateTime(DateTime dateTime) {
  final Wind wind = Wind(5, 200);
  final Clouds clouds = Clouds(0);
  final MainWeatherData mainWeatherData = MainWeatherData(0, 0, 0, 0, 0, 0, 0);
  final OverallWeatherData overallWeatherData =
      OverallWeatherData(0, "", "", "");
  final List<OverallWeatherData> list = [];
  list.add(overallWeatherData);
  final Rain rain = Rain(0);
  final Rain snow = Rain(0);
  return WeatherForecastResponse(
      mainWeatherData, list, clouds, wind, dateTime, rain, snow);
}
