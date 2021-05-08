import 'package:feather/src/ui/main/main_screen.dart';
import 'package:feather/src/ui/about/about_screen.dart';
import 'package:feather/src/ui/screen/settings_screen.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

class Navigation {
  final router = FluroRouter();

  final _mainScreenHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return MainScreen();
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
    return SettingsScreen();
  });

  void defineRoutes() {
    router.define("/", handler: _mainScreenHandler);
    router.define("/forecast", handler: _forecastScreenHandler);
    router.define("/about", handler: _aboutScreenHandler);
    router.define("/settings", handler: _settingsScreenHandler);
  }
}
