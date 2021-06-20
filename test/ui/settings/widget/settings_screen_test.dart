import 'package:feather/src/data/repository/local/application_local_repository.dart';
import 'package:feather/src/ui/app/app_bloc.dart';
import 'package:feather/src/ui/settings/bloc/settings_screen_bloc.dart';
import 'package:feather/src/ui/settings/bloc/settings_screen_event.dart';
import 'package:feather/src/ui/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../data/repository/local/fake_storage_manager.dart';
import '../../../test_helper.dart';
import '../../app/app_bloc_test.dart';

void main() {
  testWidgets("Settings screen should display widgets",
      (WidgetTester tester) async {
    final settingsScreenBloc = SettingsScreenBloc(ApplicationLocalRepository(
      FakeStorageManager(),
    ));

    settingsScreenBloc.add(LoadSettingsScreenEvent());

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<AppBloc>(
            create: (context) => buildAppBloc(),
          ),
          BlocProvider<SettingsScreenBloc>(
            create: (context) => settingsScreenBloc,
          )
        ],
        child: TestHelper.wrapWidgetWithLocalizationApp(
          const SettingsScreen(),
        ),
      ),
      const Duration(seconds: 2),
    );

    expect(find.byKey(const Key("settings_screen_container")), findsOneWidget);
    expect(
        find.byKey(const Key("settings_screen_refresh_timer")), findsOneWidget);
    expect(
        find.byKey(const Key("settings_screen_units_picker")), findsOneWidget);
    expect(find.byKey(const Key("settings_screen_last_refresh_time")),
        findsOneWidget);
  });
}
