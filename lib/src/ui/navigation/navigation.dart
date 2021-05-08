import 'package:feather/src/models/internal/navigation_params.dart';
import 'package:feather/src/ui/main/main_screen.dart';
import 'package:feather/src/ui/about/about_screen.dart';
import 'package:feather/src/ui/settings/settings_screen.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

class Navigation {
  final router = FluroRouter();

  final _mainScreenHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return const MainScreen();
  });

  final _forecastScreenHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return const SizedBox();
  });
  final _aboutScreenHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return const AboutScreen();
  });

  final _settingsScreenHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    List<Color> startGradientColors = [];
    if (context?.arguments != null) {
      final NavigationParams navigationParams =
          context!.arguments! as NavigationParams;
      startGradientColors = navigationParams.startGradientColors;
    }
    return SettingsScreen(
      startGradientColors: startGradientColors,
    );
  });

  void defineRoutes() {
    router.define("/", handler: _mainScreenHandler);
    router.define("/forecast", handler: _forecastScreenHandler);
    router.define("/about", handler: _aboutScreenHandler);
    router.define("/settings", handler: _settingsScreenHandler);
  }
}
