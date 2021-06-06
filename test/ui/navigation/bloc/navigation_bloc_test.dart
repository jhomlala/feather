import 'package:bloc_test/bloc_test.dart';
import 'package:feather/src/data/model/internal/navigation_route.dart';
import 'package:feather/src/data/model/internal/weather_forecast_holder.dart';
import 'package:feather/src/ui/navigation/bloc/navigation_bloc.dart';
import 'package:feather/src/ui/navigation/bloc/navigation_event.dart';
import 'package:feather/src/ui/navigation/bloc/navigation_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fake_navigation_provider.dart';

void main() {
  group("Should navigate to forecast screen", () {

    test("some test", () {
      final FakeNavigationProvider fakeNavigationProvider =
      FakeNavigationProvider();
      final NavigationBloc navigationBloc =
      buildNavigationBloc(fakeNavigationProvider: fakeNavigationProvider);

      testBloc<NavigationBloc, NavigationState>(
          build: () {
            return navigationBloc;
          },
          act: (bloc) =>
              bloc.add(
                ForecastScreenNavigationEvent(
                  WeatherForecastHolder.empty(),
                ),
              ),
          expect: () =>
          [
            const NavigationState(NavigationRoute.forecastScreen),
          ],
          verify: (_) {
            expect(fakeNavigationProvider.path, "/forecast");
          });
    });

    test("test",(){});
  });

  /*group("Navigation testes", () {
    test("Should navigate to main screen", () {
      final FakeNavigationProvider fakeNavigationProvider =
          FakeNavigationProvider();
      final NavigationBloc navigationBloc =
          buildNavigationBloc(fakeNavigationProvider: fakeNavigationProvider);

      testBloc<NavigationBloc, NavigationState>(
          build: () {
            return navigationBloc;
          },
          act: (bloc) => bloc.add(MainScreenNavigationEvent()),
          expect: () => [
                const NavigationState(NavigationRoute.mainScreen),
              ],
          verify: (_) {
            expect(fakeNavigationProvider.path, "/");
          });
    });

    test("Should navigate to about screen", () {
      final FakeNavigationProvider fakeNavigationProvider =
          FakeNavigationProvider();
      final NavigationBloc navigationBloc =
          buildNavigationBloc(fakeNavigationProvider: fakeNavigationProvider);

      testBloc<NavigationBloc, NavigationState>(
          build: () {
            return navigationBloc;
          },
          act: (bloc) => bloc.add(AboutScreenNavigationEvent([])),
          expect: () => [
                const NavigationState(NavigationRoute.mainScreen),
              ],
          verify: (_) {
            expect(fakeNavigationProvider.path, "/");
          });
    });
  });*/
}

NavigationBloc buildNavigationBloc(
        {FakeNavigationProvider? fakeNavigationProvider}) =>
    NavigationBloc(
      fakeNavigationProvider ?? FakeNavigationProvider(),
      GlobalKey(),
    );
