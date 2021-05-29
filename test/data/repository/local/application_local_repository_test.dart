import 'package:feather/src/data/model/internal/unit.dart';
import 'package:feather/src/data/repository/local/application_local_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fake_storage_manager.dart';

///Tests for application_local_repository.dart
void main() {
  late ApplicationLocalRepository applicationLocalRepository;

  setUp(() {
    applicationLocalRepository =
        ApplicationLocalRepository(FakeStorageManager());
  });

  group("Application Unit", () {
    test("getUnit returns default Unit", () async {
      final savedUnit = await applicationLocalRepository.getSavedUnit();
      expect(savedUnit, Unit.imperial);
    });

    test("getUnit returns saved Unit", () async {
      applicationLocalRepository.saveUnit(Unit.metric);
      var savedUnit = await applicationLocalRepository.getSavedUnit();
      expect(savedUnit, Unit.metric);

      applicationLocalRepository.saveUnit(Unit.imperial);
      savedUnit = await applicationLocalRepository.getSavedUnit();
      expect(savedUnit, Unit.imperial);
    });
  });

  group("Saved Refresh time", () {
    test("getSavedRefreshTime returns default time", () async {
      final savedRefreshTime =
          await applicationLocalRepository.getSavedRefreshTime();
      expect(savedRefreshTime, 0);
    });

    test("getSavedRefreshTime returns saved time", () async {
      var savedRefreshTime =
          await applicationLocalRepository.getSavedRefreshTime();
      expect(savedRefreshTime, 0);
      final time = DateTime.now();
      applicationLocalRepository.saveRefreshTime(time.millisecondsSinceEpoch);
      savedRefreshTime = await applicationLocalRepository.getSavedRefreshTime();
      expect(savedRefreshTime, time.millisecondsSinceEpoch);
    });
  });

  group("Refresh time", () {
    test("getSavedRefreshTime returns default time", () async {
      final savedRefreshTime =
          await applicationLocalRepository.getSavedRefreshTime();
      expect(savedRefreshTime, 0);
    });

    test("getSavedRefreshTime returns saved time", () async {
      var savedRefreshTime =
          await applicationLocalRepository.getSavedRefreshTime();
      expect(savedRefreshTime, 0);
      final time = DateTime.now();
      applicationLocalRepository.saveRefreshTime(time.millisecondsSinceEpoch);
      savedRefreshTime = await applicationLocalRepository.getSavedRefreshTime();
      expect(savedRefreshTime, time.millisecondsSinceEpoch);
    });
  });

  group("Last refresh time", () {
    test("getLastRefreshTime returns default time", () async {
      final savedLastRefreshTime =
          await applicationLocalRepository.getLastRefreshTime();
      expect(savedLastRefreshTime, 0);
    });

    test("getLastRefreshTime returns saved time", () async {
      var savedLastRefreshTime =
          await applicationLocalRepository.getLastRefreshTime();
      expect(savedLastRefreshTime, 0);
      final time = DateTime.now();
      applicationLocalRepository
          .saveLastRefreshTime(time.millisecondsSinceEpoch);
      savedLastRefreshTime =
          await applicationLocalRepository.getLastRefreshTime();
      expect(savedLastRefreshTime, time.millisecondsSinceEpoch);
    });
  });
}
