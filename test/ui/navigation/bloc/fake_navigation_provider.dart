import 'package:feather/src/ui/navigation/navigation_provider.dart';
import 'package:flutter/material.dart';

class FakeNavigationProvider extends NavigationProvider {
  String _path = "";

  @override
  void navigateToPath(
    String path,
    GlobalKey<NavigatorState> navigatorKey, {
    RouteSettings? routeSettings,
  }) {
    _path = path;
  }

  String get path => _path;
}
