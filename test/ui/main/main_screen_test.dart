import 'package:feather/src/data/model/internal/application_error.dart';
import 'package:feather/src/ui/app/app_bloc.dart';
import 'package:feather/src/ui/main/bloc/main_screen_bloc.dart';
import 'package:feather/src/ui/main/main_screen.dart';
import 'package:feather/src/ui/navigation/bloc/navigation_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import '../../data/repository/local/fake_location_provider.dart';
import '../../data/repository/local/fake_storage_manager.dart';
import '../../data/repository/remote/fake_weather_api_provider.dart';
import '../../test_helper.dart';
import '../app/app_bloc_test.dart';
import '../navigation/bloc/navigation_bloc_test.dart';
import 'bloc/main_screen_bloc_test.dart';

void main() {
  testWidgets("Main screen should display success widgets",
      (WidgetTester tester) async {
    final MainScreenBloc mainScreenBloc = buildMainScreenBloc();
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
    await tester.pump(const Duration(seconds: 1));

    expect(find.byKey(const Key("main_screen_overflow_menu")), findsOneWidget);
    expect(find.byKey(const Key("main_screen_weather_widget_container")),
        findsOneWidget);
    expect(find.byKey(const Key("main_screen_weather_widget_city_name")),
        findsOneWidget);
    expect(
        find.byKey(const Key("main_screen_gradient_widget")), findsOneWidget);
  });

  testWidgets("Main screen should display permission not granted widget",
      (WidgetTester tester) async {
    final FakeLocationProvider fakeLocationProvider = FakeLocationProvider();
    fakeLocationProvider.locationPermission = LocationPermission.deniedForever;
    fakeLocationProvider.requestedLocationPermission =
        LocationPermission.denied;
    final MainScreenBloc mainScreenBloc =
        buildMainScreenBloc(fakeLocationProvider: fakeLocationProvider);
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
        child: TestHelper.wrapWidgetWithLocalizationApp(
          const MainScreen(),
        ),
      ),
    );

    ///Wait until screen finishes loading
    await tester.pump(const Duration(seconds: 1));

    expect(find.byKey(const Key("main_screen_overflow_menu")), findsOneWidget);
    expect(find.byKey(const Key("main_screen_permissions_not_granted_widget")),
        findsOneWidget);
    expect(
        find.byKey(const Key("main_screen_gradient_widget")), findsOneWidget);
  });

  testWidgets("Main screen should display permission not granted widget",
      (WidgetTester tester) async {
    final FakeLocationProvider fakeLocationProvider = FakeLocationProvider();
    fakeLocationProvider.locationPermission = LocationPermission.deniedForever;
    fakeLocationProvider.requestedLocationPermission =
        LocationPermission.denied;
    final MainScreenBloc mainScreenBloc =
        buildMainScreenBloc(fakeLocationProvider: fakeLocationProvider);
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
        child: TestHelper.wrapWidgetWithLocalizationApp(
          const MainScreen(),
        ),
      ),
    );

    ///Wait until screen finishes loading
    await tester.pump(const Duration(seconds: 1));

    expect(find.byKey(const Key("main_screen_overflow_menu")), findsOneWidget);
    expect(find.byKey(const Key("main_screen_permissions_not_granted_widget")),
        findsOneWidget);
    expect(
        find.byKey(const Key("main_screen_gradient_widget")), findsOneWidget);
  });

  testWidgets(
      "Main screen should display location service is not enabled widget",
      (WidgetTester tester) async {
    final FakeLocationProvider fakeLocationProvider = FakeLocationProvider();
    fakeLocationProvider.locationEnabled = false;
    final MainScreenBloc mainScreenBloc =
        buildMainScreenBloc(fakeLocationProvider: fakeLocationProvider);
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
        child: TestHelper.wrapWidgetWithLocalizationApp(
          const MainScreen(),
        ),
      ),
    );

    ///Wait until screen finishes loading
    await tester.pump(const Duration(seconds: 1));

    expect(find.byKey(const Key("main_screen_overflow_menu")), findsOneWidget);
    expect(
        find.byKey(const Key("main_screen_gradient_widget")), findsOneWidget);
    expect(
        find.byKey(const Key("main_screen_location_service_disabled_widget")),
        findsOneWidget);
  });

  testWidgets("Main screen should display failed to load weather data from API",
      (WidgetTester tester) async {
    final FakeStorageManager fakeStorageManager = FakeStorageManager();
    fakeStorageManager.weatherResponse = null;
    final FakeWeatherApiProvider fakeWeatherApiProvider =
        FakeWeatherApiProvider();
    fakeWeatherApiProvider.weatherError = ApplicationError.apiError;
    final MainScreenBloc mainScreenBloc = buildMainScreenBloc(
      fakeWeatherApiProvider: fakeWeatherApiProvider,
      fakeStorageManger: fakeStorageManager,
    );
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
        child: TestHelper.wrapWidgetWithLocalizationApp(
          const MainScreen(),
        ),
      ),
    );

    ///Wait until screen finishes loading
    await tester.pump(const Duration(seconds: 1));

    expect(find.byKey(const Key("main_screen_overflow_menu")), findsOneWidget);
    expect(
        find.byKey(const Key("main_screen_gradient_widget")), findsOneWidget);
    expect(find.byKey(const Key("main_screen_failed_to_load_data_widget")),
        findsOneWidget);
  });

  testWidgets(
      "Main screen should display failed to load forecast list weather data from API",
      (WidgetTester tester) async {
    final FakeStorageManager fakeStorageManager = FakeStorageManager();
    fakeStorageManager.weatherForecastListResponse = null;
    final FakeWeatherApiProvider fakeWeatherApiProvider =
        FakeWeatherApiProvider();
    fakeWeatherApiProvider.weatherForecastError =
        ApplicationError.connectionError;
    final MainScreenBloc mainScreenBloc = buildMainScreenBloc(
      fakeWeatherApiProvider: fakeWeatherApiProvider,
      fakeStorageManger: fakeStorageManager,
    );
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
        child: TestHelper.wrapWidgetWithLocalizationApp(
          const MainScreen(),
        ),
      ),
    );

    ///Wait until screen finishes loading
    await tester.pump(const Duration(seconds: 1));

    expect(find.byKey(const Key("main_screen_overflow_menu")), findsOneWidget);
    expect(
        find.byKey(const Key("main_screen_gradient_widget")), findsOneWidget);
    expect(find.byKey(const Key("main_screen_failed_to_load_data_widget")),
        findsOneWidget);
  });
}
