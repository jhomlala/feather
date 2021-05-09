// import 'package:feather/src/data/model/internal/weather_forecast_holder.dart';
// import 'package:feather/src/data/model/remote/city.dart';
// import 'package:feather/src/data/model/remote/main_weather_data.dart';
// import 'package:feather/src/data/model/remote/overall_weather_data.dart';
// import 'package:feather/src/data/model/remote/rain.dart';
// import 'package:feather/src/data/model/remote/system.dart';
// import 'package:feather/src/data/model/remote/weather_forecast_response.dart';
// import 'package:feather/src/data/model/remote/wind.dart';
// import 'package:feather/src/ui/widget/weather_forecast_widget.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_test/flutter_test.dart';
//
// import 'test_helper.dart';
//
// main() {
//   testWidgets("Wind page should contains widgets", (WidgetTester tester) async {
//     await tester.pumpWidget(TestHelper.wrapWidgetWithLocalizationApp(
//         WeatherForecastWidget(
//             holder: setupWeatherForecastHolder(), width: 300, height: 100)));
//     expect(find.byKey(Key("weather_forecast_container")), findsOneWidget);
//     expect(find.byKey(Key("weather_forecast_location_name")), findsOneWidget);
//     expect(find.byKey(Key("weather_forecast_date_formatted")), findsOneWidget);
//     expect(find.byKey(Key("weather_forecast_swiper")), findsOneWidget);
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
