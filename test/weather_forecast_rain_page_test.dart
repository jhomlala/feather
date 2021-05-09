// import 'package:feather/src/model/internal/weather_forecast_holder.dart';
// import 'package:feather/src/model/remote/city.dart';
// import 'package:feather/src/model/remote/main_weather_data.dart';
// import 'package:feather/src/model/remote/overall_weather_data.dart';
// import 'package:feather/src/model/remote/rain.dart';
// import 'package:feather/src/model/remote/system.dart';
// import 'package:feather/src/model/remote/weather_forecast_response.dart';
// import 'package:feather/src/model/remote/wind.dart';
// import 'package:feather/src/ui/screen/weather_forecast_rain_page.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
//
// import 'test_helper.dart';
//
// main() {
//   testWidgets("Rain page should contains widgets", (WidgetTester tester) async {
//     await tester.pumpWidget(TestHelper.wrapWidgetWithLocalizationApp(
//         WeatherForecastRainPage(setupWeatherForecastHolder(), 300, 100)));
//
//     expect(find.byKey(Key("weather_forecast_base_page_icon")), findsOneWidget);
//     expect(find.byKey(Key("weather_forecast_base_page_title")), findsOneWidget);
//     expect(
//         find.byKey(Key("weather_forecast_rain_page_subtitle")), findsOneWidget);
//     expect(find.byKey(Key("weather_forecast_rain_page_bottom_row")),
//         findsOneWidget);
//     expect(find.byKey(Key("weather_forecast_base_page_title")), findsOneWidget);
//     expect(find.byKey(Key("chart_widget_container")), findsOneWidget);
//
//     Text title =
//         tester.widget(find.byKey(Key("weather_forecast_base_page_title")));
//     expect(title.data, "Rain");
//
//     RichText subtitle =
//         tester.widget(find.byKey(Key("weather_forecast_rain_page_subtitle")));
//     TextSpan textSpan = subtitle.text as TextSpan;
//     expect(textSpan.text == null, true);
//     expect(textSpan.children!.length == 4, true);
//     //expect(textSpan.children[0].text.contains("min"), true);
//     //expect(textSpan.children[1].text.contains("mm/h"), true);
//     //expect(textSpan.children[2].text.contains("max"), true);
//     //expect(textSpan.children[3].text.contains("mm/h"), true);
//   });
// }
//
// WeatherForecastHolder setupWeatherForecastHolder() {
//   List<WeatherForecastResponse> forecastList = [];
//
//   Wind wind = new Wind(5, 200);
//   MainWeatherData mainWeatherData = MainWeatherData(0, 0, 0, 0, 0, 0, 0);
//   OverallWeatherData overallWeatherData = OverallWeatherData(0, "", "", "");
//   List<OverallWeatherData> list = [];
//   list.add(overallWeatherData);
//   Rain rain = Rain(10);
//   Rain snow = Rain(10);
//
//   forecastList.add(new WeatherForecastResponse(
//       mainWeatherData, list, null, wind, DateTime.now(), rain, snow));
//
//   System system = System(null, 0, 0);
//   City city = City(0, null);
//
//   WeatherForecastHolder holder =
//       new WeatherForecastHolder(forecastList, city, system);
//
//   return holder;
// }
