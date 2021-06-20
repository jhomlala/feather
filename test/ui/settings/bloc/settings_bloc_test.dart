import 'package:feather/src/data/model/internal/unit.dart';
import 'package:feather/src/data/repository/local/application_local_repository.dart';
import 'package:feather/src/ui/settings/bloc/settings_screen_bloc.dart';
import 'package:feather/src/ui/settings/bloc/settings_screen_event.dart';
import 'package:feather/src/ui/settings/bloc/settings_screen_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../data/repository/local/fake_storage_manager.dart';

void main() {
  late SettingsScreenBloc settingsScreenBloc;

  setUp(() {
    settingsScreenBloc = buildSettingsScreenBloc();
  });

  test("Initial state is InitialSettingsScreenState", () {
    expect(settingsScreenBloc.state, InitialSettingsScreenState());
  });

  test("LoadSettingsScreenEvent loads settings", () async {
    settingsScreenBloc.add(LoadSettingsScreenEvent());
    await expectLater(
      settingsScreenBloc.stream,
      emitsInOrder(
        <TypeMatcher>[isA<LoadedSettingsScreenState>()],
      ),
    );

    final loadedSettingsScreenState =
        settingsScreenBloc.state as LoadedSettingsScreenState;
    expect(loadedSettingsScreenState.unit, Unit.imperial);
    expect(loadedSettingsScreenState.lastRefreshTime, 0);
    expect(loadedSettingsScreenState.refreshTime, 0);
  });

  test("ChangeUnitsSettingsScreenEvent changes unit", () async {
    settingsScreenBloc.add(LoadSettingsScreenEvent());
    await expectLater(
      settingsScreenBloc.stream,
      emitsInOrder(
        <TypeMatcher>[isA<LoadedSettingsScreenState>()],
      ),
    );

    settingsScreenBloc.add(ChangeUnitsSettingsScreenEvent(Unit.metric));
    await expectLater(
      settingsScreenBloc.stream,
      emitsInOrder(
        <TypeMatcher>[isA<LoadedSettingsScreenState>()],
      ),
    );

    final loadedSettingsScreenState =
        settingsScreenBloc.state as LoadedSettingsScreenState;
    expect(loadedSettingsScreenState.unit, Unit.metric);
  });

  test("ChangeRefreshTimeSettingsScreenEvent changes refresh time", () async {
    settingsScreenBloc.add(LoadSettingsScreenEvent());
    await expectLater(
      settingsScreenBloc.stream,
      emitsInOrder(
        <TypeMatcher>[isA<LoadedSettingsScreenState>()],
      ),
    );

    settingsScreenBloc.add(ChangeRefreshTimeSettingsScreenEvent(10));
    await expectLater(
      settingsScreenBloc.stream,
      emitsInOrder(
        <TypeMatcher>[isA<LoadedSettingsScreenState>()],
      ),
    );

    final loadedSettingsScreenState =
        settingsScreenBloc.state as LoadedSettingsScreenState;
    expect(loadedSettingsScreenState.refreshTime, 10);
  });
}

SettingsScreenBloc buildSettingsScreenBloc(
    {FakeStorageManager? fakeStorageManager}) {
  return SettingsScreenBloc(
    ApplicationLocalRepository(
      fakeStorageManager ?? FakeStorageManager(),
    ),
  );
}
