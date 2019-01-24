import 'package:feather/src/models/internal/weather_forecast_holder.dart';
import 'package:feather/src/models/remote/city.dart';
import 'package:feather/src/models/remote/main_weather_data.dart';
import 'package:feather/src/models/remote/overall_weather_data.dart';
import 'package:feather/src/models/remote/rain.dart';
import 'package:feather/src/models/remote/system.dart';
import 'package:feather/src/models/remote/weather_forecast_response.dart';
import 'package:feather/src/models/remote/wind.dart';
import 'package:feather/src/ui/screen/weather_forecast_wind_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helper.dart';

void main() {
  testWidgets("Wind page should contains widgets", (WidgetTester tester) async {
    await tester.pumpWidget(
        TestHelper.wrapWidgetWithLocalizationApp(WeatherForecastWindPage(setupWeatherForecastHolder(), 300, 100)));

    expect(find.byKey(Key("weather_forecast_base_page_icon")), findsOneWidget);
    expect(find.byKey(Key("weather_forecast_base_page_title")), findsOneWidget);
    expect(
        find.byKey(Key("weather_forecast_wind_page_subtitle")), findsOneWidget);
    expect(find.byKey(Key("weather_forecast_wind_page_bottom_row")),
        findsOneWidget);
    expect(find.byKey(Key("weather_forecast_base_page_title")), findsOneWidget);
    expect(find.byKey(Key("chart_widget_container")), findsOneWidget);

    Text title =
        tester.widget(find.byKey(Key("weather_forecast_base_page_title")));
    expect(title.data, "Wind");

    RichText subtitle =
        tester.widget(find.byKey(Key("weather_forecast_wind_page_subtitle")));
    TextSpan textSpan = subtitle.text;
    expect(textSpan.text == null, true);
    expect(textSpan.children.length == 4, true);
    expect(textSpan.children[0].text.contains("min"), true);
    expect(textSpan.children[1].text.contains("km/h"), true);
    expect(textSpan.children[2].text.contains("max"), true);
    expect(textSpan.children[3].text.contains("km/h"), true);

    Row bottomRow =
        tester.widget(find.byKey(Key("weather_forecast_wind_page_bottom_row")));
    expect(bottomRow.children.length == 0, true);

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
  Rain rain = Rain(0);
  Rain snow = Rain(0);

  forecastList.add(new WeatherForecastResponse(
      mainWeatherData, list, null, wind, DateTime.now(), rain, snow));

  System system = System(null, 0, 0);
  City city = City(0, null);

  WeatherForecastHolder holder =
      new WeatherForecastHolder(forecastList, city, system);

  return holder;
}
