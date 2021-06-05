import 'package:feather/src/ui/app/app_bloc.dart';
import 'package:feather/src/ui/main/bloc/main_screen_bloc.dart';
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
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<MainScreenBloc>(
            create: (context) => buildMainScreenBloc(),
          ),
          BlocProvider<AppBloc>(
            create: (context) => buildAppBloc(),
          ),
          BlocProvider<NavigationBloc>(
            create: (context) => buildNavigationBloc(),
          )
        ],
        child: TestHelper.wrapWidgetWithLocalizationApp(const MainScreen()),
      ),
      const Duration(seconds: 1),
    );
    expect(find.byKey(const Key("main_screen_overflow_menu")), findsOneWidget);
  });
}
