import 'package:feather/src/data/model/internal/forecast_navigation_params.dart';
import 'package:feather/src/data/model/internal/settings_navigation_params.dart';
import 'package:feather/src/data/model/internal/navigation_route.dart';
import 'package:feather/src/ui/navigation/bloc/navigation_event.dart';
import 'package:feather/src/ui/navigation/navigation_provider.dart';
import 'package:feather/src/ui/navigation/bloc/navigation_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  final NavigationProvider _navigationProvider;
  final GlobalKey<NavigatorState> _navigatorKey;

  NavigationBloc(
    this._navigationProvider,
    this._navigatorKey,
  ) : super(const NavigationState(NavigationRoute.mainScreen));

  @override
  Stream<NavigationState> mapEventToState(NavigationEvent event) async* {
    if (event is MainScreenNavigationEvent) {
      _navigateToPath("/");
      yield const NavigationState(NavigationRoute.mainScreen);
    }
    if (event is ForecastScreenNavigationEvent) {
      _navigateToPath(
        "/forecast",
        routeSettings: RouteSettings(
          arguments: ForecastNavigationParams(event.holder),
        ),
      );
      yield const NavigationState(NavigationRoute.forecastScreen);
    }
    if (event is AboutScreenNavigationEvent) {
      _navigateToPath(
        "/about",
        routeSettings: RouteSettings(
          arguments: SettingsNavigationParams(event.startGradientColors),
        ),
      );
      yield const NavigationState(
        NavigationRoute.aboutScreen,
      );
    }
    if (event is SettingsScreenNavigationEvent) {
      _navigateToPath(
        "/settings",
        routeSettings: RouteSettings(
          arguments: SettingsNavigationParams(event.startGradientColors),
        ),
      );
      yield const NavigationState(NavigationRoute.settingsScreen);
    }
  }

  void _navigateToPath(String path, {RouteSettings? routeSettings}) {
    _navigationProvider.navigateToPath(path, _navigatorKey,
        routeSettings: routeSettings);
  }
}
