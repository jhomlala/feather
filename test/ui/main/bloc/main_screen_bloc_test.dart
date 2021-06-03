import 'package:bloc_test/bloc_test.dart';
import 'package:feather/src/data/repository/local/application_local_repository.dart';
import 'package:feather/src/data/repository/local/location_manager.dart';
import 'package:feather/src/data/repository/local/weather_local_repository.dart';
import 'package:feather/src/data/repository/remote/weather_remote_repository.dart';
import 'package:feather/src/ui/main/bloc/main_screen_bloc.dart';
import 'package:feather/src/ui/main/bloc/main_screen_event.dart';
import 'package:feather/src/ui/main/bloc/main_screen_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../data/repository/local/fake_location_provider.dart';
import '../../../data/repository/local/fake_storage_manager.dart';
import '../../../data/repository/remote/fake_weather_api_provider.dart';

void main() {
  late MainScreenBloc mainScreenBloc;

  setUpAll(() {
    mainScreenBloc = MainScreenBloc(
      LocationManager(FakeLocationProvider()),
      WeatherLocalRepository(FakeStorageManager()),
      WeatherRemoteRepository(FakeWeatherApiProvider()),
      ApplicationLocalRepository(FakeStorageManager()),
    );
  });

  group("Initial state", () {
    test("Bloc has correct initial state", () {
      expect(mainScreenBloc.state, InitialMainScreenState());
    });
  });

  group("Location load", () {
    test("Bloc loads location of user", () async {
      mainScreenBloc.add(LocationCheckMainScreenEvent());
      testBloc<MainScreenBloc, MainScreenState>(
        build: () {
          return buildMainScreenBloc();
        },
        act: (bloc) => bloc.add(LocationCheckMainScreenEvent()),
        expect: () => [
          isA<CheckingLocationState>(),
          isA<LoadingMainScreenState>(),
          isA<SuccessLoadMainScreenState>()
        ],
      );
    });
  });
}

MainScreenBloc buildMainScreenBloc() => MainScreenBloc(
      LocationManager(FakeLocationProvider()),
      WeatherLocalRepository(FakeStorageManager()),
      WeatherRemoteRepository(FakeWeatherApiProvider()),
      ApplicationLocalRepository(FakeStorageManager()),
    );
