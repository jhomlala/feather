import 'package:feather/src/models/internal/weather_forecast_holder.dart';
import 'package:feather/src/models/remote/city.dart';
import 'package:feather/src/models/remote/main_weather_data.dart';
import 'package:feather/src/models/remote/overall_weather_data.dart';
import 'package:feather/src/models/remote/rain.dart';
import 'package:feather/src/models/remote/system.dart';
import 'package:feather/src/models/remote/weather_forecast_response.dart';
import 'package:feather/src/models/remote/wind.dart';
import 'package:feather/src/ui/widget/weather_forecast_thumbnail_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  testWidgets("Weather forecast thumbnail widget should display widgets",
      (WidgetTester tester) async {
    await tester.pumpWidget(
        WeatherForecastThumbnailWidget(setupWeatherForecastHolder()));
    expect(find.byKey(Key("weather_forecast_thumbnail_date")), findsOneWidget);
    expect(find.byKey(Key("weather_forecast_thumbnail_icon")), findsOneWidget);
    expect(find.byKey(Key("weather_forecast_thumbnai_temperature")),
        findsOneWidget);
  });
}

WeatherForecastHolder setupWeatherForecastHolder() {
  List<WeatherForecastResponse> forecastList =
      new List<WeatherForecastResponse>();

  Wind wind = new Wind(5, 200);
  MainWeatherData mainWeatherData = MainWeatherData(0, 0, 0, 0, 0, 0, 0);
  OverallWeatherData overallWeatherData = OverallWeatherData(0, "", "", "");
  List<OverallWeatherData> list = new List();
  list.add(overallWeatherData);
  Rain rain = Rain(10);
  Rain snow = Rain(10);

  forecastList.add(new WeatherForecastResponse(
      mainWeatherData, list, null, wind, DateTime.now(), rain, snow));

  System system = System(null, 0, 0);
  City city = City(0, null);

  WeatherForecastHolder holder =
      new WeatherForecastHolder(forecastList, city, system);

  return holder;
}
