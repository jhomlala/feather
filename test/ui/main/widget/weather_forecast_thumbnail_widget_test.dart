import 'package:feather/src/data/model/internal/weather_forecast_holder.dart';
import 'package:feather/src/data/model/remote/city.dart';
import 'package:feather/src/data/model/remote/main_weather_data.dart';
import 'package:feather/src/data/model/remote/overall_weather_data.dart';
import 'package:feather/src/data/model/remote/rain.dart';
import 'package:feather/src/data/model/remote/system.dart';
import 'package:feather/src/data/model/remote/weather_forecast_response.dart';
import 'package:feather/src/data/model/remote/wind.dart';
import 'package:feather/src/ui/main/widget/weather_forecast_thumbnail_widget.dart';
import 'package:feather/src/ui/navigation/bloc/navigation_bloc.dart';
import 'package:feather/src/ui/navigation/navigation_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets("Weather forecast thumbnail widget should display widgets",
      (WidgetTester tester) async {
    await tester.pumpWidget(
      BlocProvider<NavigationBloc>(
        create: (context) => NavigationBloc(NavigationProvider(), GlobalKey()),
        child:
            WeatherForecastThumbnailWidget(setupWeatherForecastHolder(), false),
      ),
    );
    expect(find.byKey(const Key("weather_forecast_thumbnail_date")),
        findsOneWidget);
    expect(find.byKey(const Key("weather_forecast_thumbnail_icon")),
        findsOneWidget);
    expect(find.byKey(const Key("weather_forecast_thumbnail_temperature")),
        findsOneWidget);
  });
}

WeatherForecastHolder setupWeatherForecastHolder() {
  final List<WeatherForecastResponse> forecastList = [];

  final Wind wind = Wind(5, 200);
  final MainWeatherData mainWeatherData = MainWeatherData(0, 0, 0, 0, 0, 0, 0);
  final OverallWeatherData overallWeatherData =
      OverallWeatherData(0, "", "", "");
  final List<OverallWeatherData> list = [];
  list.add(overallWeatherData);
  final Rain rain = Rain(10);
  final Rain snow = Rain(10);

  forecastList.add(WeatherForecastResponse(
      mainWeatherData, list, null, wind, DateTime.now(), rain, snow));

  final System system = System(null, 0, 0);
  final City city = City(0, null);

  final WeatherForecastHolder holder =
      WeatherForecastHolder(forecastList, city, system);

  return holder;
}
