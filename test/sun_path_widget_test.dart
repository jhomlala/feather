import 'package:feather/src/models/remote/system.dart';
import 'package:feather/src/ui/widget/sun_path_widget.dart';
import 'package:feather/src/utils/date_time_helper.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  testWidgets("Sun path widget should draw", (WidgetTester tester) async {
    await tester.pumpWidget(SunPathWidget(
      sunrise: DateTimeHelper.getCurrentTime(),
      sunset: DateTimeHelper.getCurrentTime(),
    ));

    expect(find.byKey(Key("sun_path_widget_sized_box")), findsOneWidget);
    expect(find.byKey(Key("sun_path_widget_custom_paint")), findsOneWidget);
  });
}

System setupSystem() {
  return System("", 0, 0);
}
