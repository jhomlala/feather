import 'package:bloc_test/bloc_test.dart';
import 'package:feather/src/data/model/internal/application_error.dart';
import 'package:feather/src/data/repository/local/application_local_repository.dart';
import 'package:feather/src/data/repository/local/location_manager.dart';
import 'package:feather/src/data/repository/local/weather_local_repository.dart';
import 'package:feather/src/data/repository/remote/weather_remote_repository.dart';
import 'package:feather/src/ui/main/bloc/main_screen_bloc.dart';
import 'package:feather/src/ui/main/bloc/main_screen_event.dart';
import 'package:feather/src/ui/main/bloc/main_screen_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';

import '../../../data/repository/local/fake_location_provider.dart';
import '../../../data/repository/local/fake_storage_manager.dart';
import '../../../data/repository/remote/fake_weather_api_provider.dart';

void main() {
  group("Initial state", () {
    test("Bloc has correct initial state", () {
      expect(buildMainScreenBloc().state, InitialMainScreenState());
    });
  });

  group("Location tests", () {
    test("Loads location of user and loads weather data from API", () async {
      testBloc<MainScreenBloc, MainScreenState>(
        build: () {
          return buildMainScreenBloc();
        },
        act: (bloc) => bloc.add(LocationCheckMainScreenEvent()),
        expect: () => [
          isA<CheckingLocationMainScreenState>(),
          isA<LoadingMainScreenState>(),
          isA<SuccessLoadMainScreenState>()
        ],
      );
    });

    test("Location service is disabled ", () async {
      testBloc<MainScreenBloc, MainScreenState>(
        build: () {
          final FakeLocationProvider fakeLocationProvider =
              FakeLocationProvider();
          fakeLocationProvider.locationEnabled = false;
          return buildMainScreenBloc(
              fakeLocationProvider: fakeLocationProvider);
        },
        act: (bloc) => bloc.add(LocationCheckMainScreenEvent()),
        expect: () => [
          isA<CheckingLocationMainScreenState>(),
          isA<LocationServiceDisabledMainScreenState>(),
        ],
      );
    });

    test("Location permission is denied and request is also denied", () async {
      testBloc<MainScreenBloc, MainScreenState>(
        build: () {
          final FakeLocationProvider fakeLocationProvider =
              FakeLocationProvider();
          fakeLocationProvider.locationPermission = LocationPermission.denied;
          fakeLocationProvider.requestedLocationPermission =
              LocationPermission.denied;
          return buildMainScreenBloc(
              fakeLocationProvider: fakeLocationProvider);
        },
        act: (bloc) => bloc.add(LocationCheckMainScreenEvent()),
        expect: () => [
          isA<CheckingLocationMainScreenState>(),
          isA<PermissionNotGrantedMainScreenState>(),
        ],
      );
    });

    test("Location permission is denied and request is denied forever",
        () async {
      testBloc<MainScreenBloc, MainScreenState>(
        build: () {
          final FakeLocationProvider fakeLocationProvider =
              FakeLocationProvider();
          fakeLocationProvider.locationPermission =
              LocationPermission.deniedForever;
          fakeLocationProvider.requestedLocationPermission =
              LocationPermission.denied;
          return buildMainScreenBloc(
              fakeLocationProvider: fakeLocationProvider);
        },
        act: (bloc) => bloc.add(LocationCheckMainScreenEvent()),
        expect: () => [
          isA<CheckingLocationMainScreenState>(),
          isA<PermissionNotGrantedMainScreenState>(),
        ],
      );
    });

    test("Location permission is denied and request is always", () async {
      testBloc<MainScreenBloc, MainScreenState>(
        build: () {
          final FakeLocationProvider fakeLocationProvider =
              FakeLocationProvider();
          fakeLocationProvider.locationPermission = LocationPermission.denied;
          fakeLocationProvider.requestedLocationPermission =
              LocationPermission.always;
          return buildMainScreenBloc(
              fakeLocationProvider: fakeLocationProvider);
        },
        act: (bloc) => bloc.add(LocationCheckMainScreenEvent()),
        expect: () => [
          isA<CheckingLocationMainScreenState>(),
          isA<LoadingMainScreenState>(),
          isA<SuccessLoadMainScreenState>()
        ],
      );
    });

    test("Location permission is denied and request is while in use", () async {
      testBloc<MainScreenBloc, MainScreenState>(
        build: () {
          final FakeLocationProvider fakeLocationProvider =
              FakeLocationProvider();
          fakeLocationProvider.locationPermission = LocationPermission.denied;
          fakeLocationProvider.requestedLocationPermission =
              LocationPermission.whileInUse;
          return buildMainScreenBloc(
              fakeLocationProvider: fakeLocationProvider);
        },
        act: (bloc) => bloc.add(LocationCheckMainScreenEvent()),
        expect: () => [
          isA<CheckingLocationMainScreenState>(),
          isA<LoadingMainScreenState>(),
          isA<SuccessLoadMainScreenState>()
        ],
      );
    });
  });

  group("Bloc weather API tests", () {
    test("Weather API returns API Error", () async {
      testBloc<MainScreenBloc, MainScreenState>(
        build: () {
          final FakeStorageManager fakeStorageManager = FakeStorageManager();
          fakeStorageManager.weatherResponse = null;
          final FakeWeatherApiProvider fakeWeatherApiProvider =
              FakeWeatherApiProvider();
          fakeWeatherApiProvider.weatherError = ApplicationError.apiError;
          return buildMainScreenBloc(
            fakeWeatherApiProvider: fakeWeatherApiProvider,
            fakeStorageManger: fakeStorageManager,
          );
        },
        act: (bloc) => bloc.add(LocationCheckMainScreenEvent()),
        expect: () => [
          isA<CheckingLocationMainScreenState>(),
          isA<LoadingMainScreenState>(),
          const FailedLoadMainScreenState(ApplicationError.apiError)
        ],
      );
    });

    test("Weather API returns connection error", () async {
      testBloc<MainScreenBloc, MainScreenState>(
        build: () {
          final FakeStorageManager fakeStorageManager = FakeStorageManager();
          fakeStorageManager.weatherResponse = null;
          final FakeWeatherApiProvider fakeWeatherApiProvider =
              FakeWeatherApiProvider();
          fakeWeatherApiProvider.weatherError =
              ApplicationError.connectionError;
          return buildMainScreenBloc(
            fakeWeatherApiProvider: fakeWeatherApiProvider,
            fakeStorageManger: fakeStorageManager,
          );
        },
        act: (bloc) => bloc.add(LocationCheckMainScreenEvent()),
        expect: () => [
          isA<CheckingLocationMainScreenState>(),
          isA<LoadingMainScreenState>(),
          const FailedLoadMainScreenState(ApplicationError.connectionError)
        ],
      );
    });

    test("Weather API returns location not selected error", () async {
      testBloc<MainScreenBloc, MainScreenState>(
        build: () {
          final FakeStorageManager fakeStorageManager = FakeStorageManager();
          fakeStorageManager.weatherResponse = null;
          final FakeWeatherApiProvider fakeWeatherApiProvider =
              FakeWeatherApiProvider();
          fakeWeatherApiProvider.weatherError =
              ApplicationError.locationNotSelectedError;
          return buildMainScreenBloc(
            fakeWeatherApiProvider: fakeWeatherApiProvider,
            fakeStorageManger: fakeStorageManager,
          );
        },
        act: (bloc) => bloc.add(LocationCheckMainScreenEvent()),
        expect: () => [
          isA<CheckingLocationMainScreenState>(),
          isA<LoadingMainScreenState>(),
          const FailedLoadMainScreenState(
              ApplicationError.locationNotSelectedError)
        ],
      );
    });

    test("Weather Forecast API returns API Error", () async {
      testBloc<MainScreenBloc, MainScreenState>(
        build: () {
          final FakeStorageManager fakeStorageManager = FakeStorageManager();
          fakeStorageManager.weatherForecastListResponse = null;
          final FakeWeatherApiProvider fakeWeatherApiProvider =
              FakeWeatherApiProvider();
          fakeWeatherApiProvider.weatherForecastError =
              ApplicationError.apiError;
          return buildMainScreenBloc(
            fakeWeatherApiProvider: fakeWeatherApiProvider,
            fakeStorageManger: fakeStorageManager,
          );
        },
        act: (bloc) => bloc.add(LocationCheckMainScreenEvent()),
        expect: () => [
          isA<CheckingLocationMainScreenState>(),
          isA<LoadingMainScreenState>(),
          const FailedLoadMainScreenState(ApplicationError.apiError)
        ],
      );
    });

    test("Weather Forecast API returns connection Error", () async {
      testBloc<MainScreenBloc, MainScreenState>(
        build: () {
          final FakeStorageManager fakeStorageManager = FakeStorageManager();
          fakeStorageManager.weatherForecastListResponse = null;
          final FakeWeatherApiProvider fakeWeatherApiProvider =
              FakeWeatherApiProvider();
          fakeWeatherApiProvider.weatherForecastError =
              ApplicationError.connectionError;
          return buildMainScreenBloc(
            fakeWeatherApiProvider: fakeWeatherApiProvider,
            fakeStorageManger: fakeStorageManager,
          );
        },
        act: (bloc) => bloc.add(LocationCheckMainScreenEvent()),
        expect: () => [
          isA<CheckingLocationMainScreenState>(),
          isA<LoadingMainScreenState>(),
          const FailedLoadMainScreenState(ApplicationError.connectionError)
        ],
      );
    });

    test("Weather Forecast API returns location not selected error", () async {
      testBloc<MainScreenBloc, MainScreenState>(
        build: () {
          final FakeStorageManager fakeStorageManager = FakeStorageManager();
          fakeStorageManager.weatherForecastListResponse = null;
          final FakeWeatherApiProvider fakeWeatherApiProvider =
              FakeWeatherApiProvider();
          fakeWeatherApiProvider.weatherForecastError =
              ApplicationError.locationNotSelectedError;
          return buildMainScreenBloc(
            fakeWeatherApiProvider: fakeWeatherApiProvider,
            fakeStorageManger: fakeStorageManager,
          );
        },
        act: (bloc) => bloc.add(LocationCheckMainScreenEvent()),
        expect: () => [
          isA<CheckingLocationMainScreenState>(),
          isA<LoadingMainScreenState>(),
          const FailedLoadMainScreenState(
              ApplicationError.locationNotSelectedError)
        ],
      );
    });
  });

  group("Weather data", () {
    test("Main weather data is being loaded", () async {
      final MainScreenBloc bloc = buildMainScreenBloc();
      bloc.add(LocationCheckMainScreenEvent());
      await expectLater(
        bloc.stream,
        emitsInOrder(
          <TypeMatcher>[
            isA<CheckingLocationMainScreenState>(),
            isA<LoadingMainScreenState>(),
            isA<SuccessLoadMainScreenState>()
          ],
        ),
      );
      expect(
          (bloc.state as SuccessLoadMainScreenState)
              .weatherResponse
              .toJson()
              .isNotEmpty,
          true);
    });

    test("Weather forecast data is being loaded", () async {
      final MainScreenBloc bloc = buildMainScreenBloc();
      bloc.add(LocationCheckMainScreenEvent());
      await expectLater(
        bloc.stream,
        emitsInOrder(
          <TypeMatcher>[
            isA<CheckingLocationMainScreenState>(),
            isA<LoadingMainScreenState>(),
            isA<SuccessLoadMainScreenState>()
          ],
        ),
      );
      expect(
          (bloc.state as SuccessLoadMainScreenState)
              .weatherForecastListResponse
              .toJson()
              .isNotEmpty,
          true);
    });
  });
}

MainScreenBloc buildMainScreenBloc({
  FakeLocationProvider? fakeLocationProvider,
  FakeWeatherApiProvider? fakeWeatherApiProvider,
  FakeStorageManager? fakeStorageManger,
}) =>
    MainScreenBloc(
      LocationManager(fakeLocationProvider ?? FakeLocationProvider()),
      WeatherLocalRepository(fakeStorageManger ?? FakeStorageManager()),
      WeatherRemoteRepository(
          fakeWeatherApiProvider ?? FakeWeatherApiProvider()),
      ApplicationLocalRepository(FakeStorageManager()),
    );
