import 'package:feather/src/data/model/remote/system.dart';
import 'package:feather/src/ui/main/widget/weather_main_sun_path_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../test_helper.dart';

void main() {
  testWidgets("Weather widget should show widgets",
      (WidgetTester tester) async {
    final WeatherMainSunPathWidget widget = WeatherMainSunPathWidget(
      system: setupSystem(),
    );

    await tester.pumpWidget(TestHelper.wrapWidgetWithLocalizationApp(widget));
    expect(
        find.byKey(const Key("weather_main_sun_path_widget")), findsOneWidget);
    expect(find.byKey(const Key("weather_main_sun_path_percentage")),
        findsOneWidget);
    expect(find.byKey(const Key("weather_main_sun_path_countdown")),
        findsOneWidget);
    expect(
        find.byKey(const Key("weather_main_sun_path_sunrise")), findsOneWidget);
    expect(
        find.byKey(const Key("weather_main_sun_path_sunset")), findsOneWidget);
  });
}

System setupSystem() {
  return System("", 0, 0);
}
