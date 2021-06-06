import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fake_navigation_provider.dart';

void main() {
  late FakeNavigationProvider navigationProvider;
  late GlobalKey<NavigatorState> navigatorKey;

  setUp(() {
    navigationProvider = FakeNavigationProvider();
    navigatorKey = GlobalKey<NavigatorState>();
  });

  test("Updates path on route change", () {
    expect(navigationProvider.path, "");

    navigationProvider.navigateToPath("/about", navigatorKey);
    expect(navigationProvider.path, "/about");

    navigationProvider.navigateToPath("/settings", navigatorKey);
    expect(navigationProvider.path, "/settings");
  });
}
