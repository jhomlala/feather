import 'package:bloc_test/bloc_test.dart';
import 'package:feather/src/data/model/internal/unit.dart';
import 'package:feather/src/data/repository/local/application_local_repository.dart';
import 'package:feather/src/ui/app/app_bloc.dart';
import 'package:feather/src/ui/app/app_event.dart';
import 'package:feather/src/ui/app/app_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../data/repository/local/fake_storage_manager.dart';

void main() {
  late FakeStorageManager _fakeStorageManager;
  late AppBloc _appBloc;

  setUpAll(() {
    _fakeStorageManager = FakeStorageManager();
    _appBloc = buildAppBloc(fakeStorageManager: _fakeStorageManager);
  });

  group("Initial unit settings", () {
    test("Initial state has metric unit", () {
      expect(_appBloc.state.unit, Unit.metric);
    });
  });

  group("Is metric units returns correct flag", () {
    test("Returns false for imperial unit", () async {
      _fakeStorageManager.saveUnit(Unit.imperial);
      _appBloc.add(LoadSettingsAppEvent());
      await expectLater(_appBloc.stream,
          emitsInOrder(<AppState>[const AppState(Unit.imperial)]));
      expect(_appBloc.isMetricUnits(), equals(false));
    });

    test("Returns true for metric unit", () async {
      _fakeStorageManager.saveUnit(Unit.metric);
      _appBloc.add(LoadSettingsAppEvent());
      await expectLater(_appBloc.stream,
          emitsInOrder(<AppState>[const AppState(Unit.metric)]));
      expect(_appBloc.isMetricUnits(), equals(true));
    });
  });

  group("Updated bloc state", () {
    setUp(() {
      _fakeStorageManager.saveUnit(Unit.imperial);
    });

    blocTest<AppBloc, AppState>(
      "Load app settings updates unit",
      build: () => _appBloc,
      act: (AppBloc bloc) => bloc.add(
        LoadSettingsAppEvent(),
      ),
      expect: () => [
        const AppState(Unit.imperial),
      ],
    );
  });
}

AppBloc buildAppBloc({FakeStorageManager? fakeStorageManager}) {
  return AppBloc(
    ApplicationLocalRepository(
      fakeStorageManager ?? FakeStorageManager(),
    ),
  );
}
