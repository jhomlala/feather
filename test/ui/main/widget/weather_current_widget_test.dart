import 'package:feather/src/data/model/remote/city.dart';
import 'package:feather/src/data/model/remote/coordinates.dart';
import 'package:feather/src/data/model/remote/main_weather_data.dart';
import 'package:feather/src/data/model/remote/overall_weather_data.dart';
import 'package:feather/src/data/model/remote/system.dart';
import 'package:feather/src/data/model/remote/weather_forecast_list_response.dart';
import 'package:feather/src/data/model/remote/weather_response.dart';
import 'package:feather/src/data/model/remote/wind.dart';
import 'package:feather/src/data/repository/local/application_local_repository.dart';
import 'package:feather/src/data/repository/local/storage_manager.dart';
import 'package:feather/src/data/repository/local/storage_provider.dart';
import 'package:feather/src/ui/app/app_bloc.dart';
import 'package:feather/src/ui/widget/current_weather_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../test_helper.dart';

void main() {
  testWidgets("Weather widget should show widgets",
      (WidgetTester tester) async {
    await tester.pumpWidget(
      BlocProvider<AppBloc>(
        create: (context) => AppBloc(
          ApplicationLocalRepository(
            StorageManager(StorageProvider()),
          ),
        ),
        child: TestHelper.wrapWidgetWithLocalizationApp(
          CurrentWeatherWidget(
            weatherResponse: setupWeatherResponse(),
            forecastListResponse: setupWeatherForecastListResponse(),
          ),
        ),
      ),
    );

    expect(find.byKey(const Key("weather_current_widget_container")),
        findsOneWidget);
    expect(find.byKey(const Key("weather_current_widget_temperature")),
        findsOneWidget);
    expect(find.byKey(const Key("weather_current_widget_min_max_temperature")),
        findsOneWidget);
    expect(find.byKey(const Key("weather_current_widget_pressure_humidity")),
        findsOneWidget);
    expect(find.byKey(const Key("weather_current_widget_thumbnail_list")),
        findsOneWidget);
  });
}

WeatherResponse setupWeatherResponse() {
  final Coordinates coordiantes = Coordinates(0, 0);
  final Wind wind = Wind(5, 200);
  final MainWeatherData mainWeatherData = MainWeatherData(0, 0, 0, 0, 0, 0, 0);
  final OverallWeatherData overallWeatherData =
      OverallWeatherData(0, "", "", "");
  final List<OverallWeatherData> list = [];
  list.add(overallWeatherData);
  final System system = System("", 0, 0);
  final WeatherResponse weatherResponse = WeatherResponse(
      cord: coordiantes,
      wind: wind,
      mainWeatherData: mainWeatherData,
      overallWeatherData: list,
      name: "",
      system: system);
  return weatherResponse;
}

WeatherForecastListResponse setupWeatherForecastListResponse() {
  return WeatherForecastListResponse([], City(0, ""));
}
