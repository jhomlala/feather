import 'package:feather/src/data/model/internal/weather_forecast_holder.dart';
import 'package:feather/src/data/model/remote/city.dart';
import 'package:feather/src/data/model/remote/main_weather_data.dart';
import 'package:feather/src/data/model/remote/overall_weather_data.dart';
import 'package:feather/src/data/model/remote/rain.dart';
import 'package:feather/src/data/model/remote/system.dart';
import 'package:feather/src/data/model/remote/weather_forecast_response.dart';
import 'package:feather/src/data/model/remote/wind.dart';
import 'package:feather/src/ui/forecast/widget/weather_forecast_wind_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_helper.dart';

void main() {
  testWidgets("Wind page should contains widgets", (WidgetTester tester) async {
    await tester.pumpWidget(
      TestHelper.wrapWidgetWithLocalizationApp(
        WeatherForecastWindPage(setupWeatherForecastHolder(), 300, 100, true),
      ),
    );

    expect(find.byKey(const Key("weather_forecast_base_page_icon")),
        findsOneWidget);
    expect(find.byKey(const Key("weather_forecast_base_page_title")),
        findsOneWidget);
    expect(find.byKey(const Key("weather_forecast_wind_page_subtitle")),
        findsOneWidget);
    expect(find.byKey(const Key("weather_forecast_wind_page_bottom_row")),
        findsOneWidget);
    expect(find.byKey(const Key("weather_forecast_base_page_title")),
        findsOneWidget);
    expect(find.byKey(const Key("chart_widget_container")), findsOneWidget);

    final Text title = tester
        .widget(find.byKey(const Key("weather_forecast_base_page_title")));
    expect(title.data, "Wind");

    final RichText subtitle = tester
        .widget(find.byKey(const Key("weather_forecast_wind_page_subtitle")));
    final TextSpan textSpan = subtitle.text as TextSpan;
    expect(textSpan.text == null, true);
    expect(textSpan.children!.length == 4, true);
    expect(textSpan.children![0].toPlainText().contains("min"), true);
    expect(textSpan.children![1].toPlainText().contains("km/h"), true);
    expect(textSpan.children![2].toPlainText().contains("max"), true);
    expect(textSpan.children![3].toPlainText().contains("km/h"), true);

    final Row bottomRow = tester.widget(
      find.byKey(
        const Key("weather_forecast_wind_page_bottom_row"),
      ),
    );
    expect(bottomRow.children.isEmpty, true);
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
  final rain = Rain(0);
  final Rain snow = Rain(0);

  forecastList.add(
    WeatherForecastResponse(
        mainWeatherData, list, null, wind, DateTime.now(), rain, snow),
  );

  final System system = System(null, 0, 0);
  final City city = City(0, null);

  final WeatherForecastHolder holder =
      WeatherForecastHolder(forecastList, city, system);

  return holder;
}
