import 'package:feather/src/ui/screen/about_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helper.dart';

main() {
  testWidgets("About screen should display widgets",
      (WidgetTester tester) async {
    await tester
        .pumpWidget(TestHelper.wrapWidgetWithLocalizationApp(AboutScreen()));
    expect(find.byKey(Key("about_screen_logo")), findsOneWidget);
    expect(find.byKey(Key("about_screen_app_name")), findsOneWidget);
    expect(find.byKey(Key("about_screen_app_version_and_build")), findsOneWidget);
    expect(find.byKey(Key("about_screen_contributors")), findsOneWidget);
    expect(find.byKey(Key("about_screen_credits")), findsOneWidget);
  });
}
