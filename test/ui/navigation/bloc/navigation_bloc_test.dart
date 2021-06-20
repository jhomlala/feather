import 'package:feather/src/data/model/internal/navigation_route.dart';
import 'package:feather/src/data/model/internal/weather_forecast_holder.dart';
import 'package:feather/src/ui/navigation/bloc/navigation_bloc.dart';
import 'package:feather/src/ui/navigation/bloc/navigation_event.dart';
import 'package:feather/src/ui/navigation/bloc/navigation_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fake_navigation_provider.dart';

void main() {
  late FakeNavigationProvider fakeNavigationProvider;
  late NavigationBloc navigationBloc;

  setUp(() {
    fakeNavigationProvider = FakeNavigationProvider();
    navigationBloc =
        buildNavigationBloc(fakeNavigationProvider: fakeNavigationProvider);
  });

  test("Should navigate to forecast screen", () async {
    navigationBloc.add(ForecastScreenNavigationEvent(
      WeatherForecastHolder.empty(),
    ));

    await expectLater(
      navigationBloc.stream,
      emitsInOrder(
        <NavigationState>[
          const NavigationState(NavigationRoute.forecastScreen)
        ],
      ),
    );

    expect(fakeNavigationProvider.path, "/forecast");
  });

  test("Should navigate to main screen", () async {
    navigationBloc.add(MainScreenNavigationEvent());

    await expectLater(
      navigationBloc.stream,
      emitsInOrder(
        <NavigationState>[const NavigationState(NavigationRoute.mainScreen)],
      ),
    );

    expect(fakeNavigationProvider.path, "/");
  });

  test("Should navigate to about screen", () async {
    navigationBloc.add(AboutScreenNavigationEvent(const []));

    await expectLater(
      navigationBloc.stream,
      emitsInOrder(
        <NavigationState>[const NavigationState(NavigationRoute.aboutScreen)],
      ),
    );

    expect(fakeNavigationProvider.path, "/about");
  });

  test("Should navigate to settings screen", () async {
    navigationBloc.add(SettingsScreenNavigationEvent(const []));

    await expectLater(
      navigationBloc.stream,
      emitsInOrder(
        <NavigationState>[
          const NavigationState(NavigationRoute.settingsScreen)
        ],
      ),
    );

    expect(fakeNavigationProvider.path, "/settings");
  });
}

NavigationBloc buildNavigationBloc(
        {FakeNavigationProvider? fakeNavigationProvider}) =>
    NavigationBloc(
      fakeNavigationProvider ?? FakeNavigationProvider(),
      GlobalKey(),
    );
