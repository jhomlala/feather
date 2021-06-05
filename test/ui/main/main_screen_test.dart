import 'package:feather/src/ui/app/app_bloc.dart';
import 'package:feather/src/ui/main/bloc/main_screen_bloc.dart';
import 'package:feather/src/ui/main/bloc/main_screen_event.dart';
import 'package:feather/src/ui/main/main_screen.dart';
import 'package:feather/src/ui/navigation/bloc/navigation_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../test_helper.dart';
import '../app/app_bloc_test.dart';
import '../navigation/navigation_bloc_test.dart';
import 'bloc/main_screen_bloc_test.dart';

void main() {
  testWidgets("Main screen should display widgets",
      (WidgetTester tester) async {
    MainScreenBloc mainScreenBloc = buildMainScreenBloc();
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<MainScreenBloc>(create: (context) => mainScreenBloc),
          BlocProvider<AppBloc>(
            create: (context) => buildAppBloc(),
          ),
          BlocProvider<NavigationBloc>(
            create: (context) => buildNavigationBloc(),
          )
        ],
        child: TestHelper.wrapWidgetWithLocalizationApp(const MainScreen()),
      ),
    );

    ///Wait until screen finishes loading
    await tester.pump(const Duration(seconds: 5));

    expect(find.byKey(const Key("main_screen_overflow_menu")), findsOneWidget);
    expect(find.byKey(const Key("main_screen_weather_widget_container")),
        findsOneWidget);
    expect(find.byKey(const Key("main_screen_weather_widget_city_name")),
        findsOneWidget);
    expect(find.byKey(const Key("main_screen_gradient_widget")),
        findsOneWidget);
  });
}
