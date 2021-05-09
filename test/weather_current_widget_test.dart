// import 'package:feather/src/data/model/remote/main_weather_data.dart';
// import 'package:feather/src/data/model/remote/overall_weather_data.dart';
// import 'package:feather/src/data/model/remote/system.dart';
// import 'package:feather/src/data/model/remote/weather_response.dart';
// import 'package:feather/src/data/model/remote/wind.dart';
// import 'package:feather/src/ui/widget/current_weather_widget.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_test/flutter_test.dart';
//
// import 'test_helper.dart';
//
// main() {
//   testWidgets("Weather widget should show widgets",
//       (WidgetTester tester) async {
//     await tester.pumpWidget(
//         TestHelper.wrapWidgetWithLocalizationApp(CurrentWeatherWidget(
//       weatherResponse: setupWeatherResponse(),
//     )));
//
//     expect(find.byKey(Key("weather_current_widget_container")), findsOneWidget);
//     expect(
//         find.byKey(Key("weather_current_widget_temperature")), findsOneWidget);
//     expect(find.byKey(Key("weather_current_widget_min_max_temperature")),
//         findsOneWidget);
//     expect(find.byKey(Key("weather_current_widget_pressure_humidity")),
//         findsOneWidget);
//     expect(find.byKey(Key("weather_current_widget_thumbnail_list")),
//         findsOneWidget);
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
