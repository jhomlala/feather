// import 'package:feather/src/data/model/remote/main_weather_data.dart';
// import 'package:feather/src/data/model/remote/overall_weather_data.dart';
// import 'package:feather/src/data/model/remote/system.dart';
// import 'package:feather/src/data/model/remote/weather_response.dart';
// import 'package:feather/src/data/model/remote/wind.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
//
// main() {
//   testWidgets("Weather main page should show widgets",
//       (WidgetTester tester) async {
//     /*await tester
//         .pumpWidget(TestHelper.wrapWidgetWithLocalizationApp(WeatherMainPage(
//       weatherResponse: setupWeatherResponse(),
//     )));*/
//
//     expect(
//         find.byKey(Key("weather_main_page_current_weather")), findsOneWidget);
//   });
// }
//
// WeatherResponse setupWeatherResponse() {
//   Wind wind = new Wind(5, 200);
//   MainWeatherData mainWeatherData = MainWeatherData(0, 0, 0, 0, 0, 0, 0);
//   OverallWeatherData overallWeatherData = OverallWeatherData(0, "", "", "");
//   List<OverallWeatherData> list = [];
//   list.add(overallWeatherData);
//   System system = System("", 0, 0);
//   WeatherResponse weatherResponse = WeatherResponse(
//       wind: wind,
//       mainWeatherData: mainWeatherData,
//       overallWeatherData: list,
//       name: "",
//       system: system);
//   return weatherResponse;
// }
