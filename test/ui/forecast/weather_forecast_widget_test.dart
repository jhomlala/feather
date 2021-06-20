import 'package:feather/src/data/model/internal/weather_forecast_holder.dart';
import 'package:feather/src/data/model/remote/city.dart';
import 'package:feather/src/data/model/remote/main_weather_data.dart';
import 'package:feather/src/data/model/remote/overall_weather_data.dart';
import 'package:feather/src/data/model/remote/rain.dart';
import 'package:feather/src/data/model/remote/system.dart';
import 'package:feather/src/data/model/remote/weather_forecast_response.dart';
import 'package:feather/src/data/model/remote/wind.dart';
import 'package:feather/src/ui/forecast/widget/weather_forecast_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_helper.dart';

void main() {
  testWidgets("Wind page should contains widgets", (WidgetTester tester) async {
    await tester.pumpWidget(
      TestHelper.wrapWidgetWithLocalizationApp(
        WeatherForecastWidget(
          holder: setupWeatherForecastHolder(),
          width: 300,
          height: 100,
          isMetricUnits: false,
        ),
      ),
    );
    expect(find.byKey(const Key("weather_forecast_container")), findsOneWidget);
    expect(find.byKey(const Key("weather_forecast_location_name")),
        findsOneWidget);
    expect(find.byKey(const Key("weather_forecast_date_formatted")),
        findsOneWidget);
    expect(find.byKey(const Key("weather_forecast_swiper")), findsOneWidget);
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
