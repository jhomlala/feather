import 'package:feather/src/ui/about/about_screen.dart';
import 'package:feather/src/ui/about/bloc/about_screen_bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../test_helper.dart';

void main() {
  testWidgets("About screen should display widgets",
      (WidgetTester tester) async {
    await tester.pumpWidget(
      BlocProvider<AboutScreenBloc>(
        create: (context) => AboutScreenBloc(),
        child: TestHelper.wrapWidgetWithLocalizationApp(
          const AboutScreen(),
        ),
      ),
      const Duration(seconds: 2),
    );

    expect(find.byKey(const Key("about_screen_logo")), findsOneWidget);
    expect(find.byKey(const Key("about_screen_app_name")), findsOneWidget);
    expect(find.byKey(const Key("about_screen_app_version_and_build")),
        findsOneWidget);
    expect(find.byKey(const Key("about_screen_contributors")), findsOneWidget);
    expect(find.byKey(const Key("about_screen_credits")), findsOneWidget);
  });
}
