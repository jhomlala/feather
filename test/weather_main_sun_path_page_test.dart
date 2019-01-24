import 'package:feather/src/models/remote/system.dart';
import 'package:feather/src/ui/screen/weather_main_sun_path_page.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helper.dart';

main() {
  testWidgets("Weather widget should show widgets",
      (WidgetTester tester) async {

    WeatherMainSunPathPage page = WeatherMainSunPathPage(
      system: setupSystem(),
    );

    await tester.pumpWidget( TestHelper.wrapWidgetWithLocalizationApp(page));
    expect(find.byKey(Key("weather_main_sun_path_widget")), findsOneWidget);
    expect(find.byKey(Key("weather_main_sun_path_percentage")), findsOneWidget);
    expect(find.byKey(Key("weather_main_sun_path_countdown")), findsOneWidget);
    expect(find.byKey(Key("weather_main_sun_path_sunrise")), findsOneWidget);
    expect(find.byKey(Key("weather_main_sun_path_sunset")), findsOneWidget);
  });
}

System setupSystem() {
  return System("", 0, 0);
}
