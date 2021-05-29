import 'package:feather/src/data/repository/local/location_manager.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fake_location_provider.dart';

void main() {
  late LocationManager locationManager;
  setUp(() {
    locationManager = LocationManager(FakeLocationProvider());
  });

  group("Location", () {
    test("Last position is null when location wasn't selected", () {
      expect(locationManager.lastPosition, null);
    });

    test("Get position returns value", () async {
      final location = await locationManager.getLocation();
      expect(location != null, true);
    });

    test("Last position is same as returned location by normal method",
        () async {
      final location = await locationManager.getLocation();
      final lastLocation = locationManager.lastPosition;
      expect(location == lastLocation, true);
    });

    test("Last position is cached", () async {
      final location = await locationManager.getLocation();
      final location2 = await locationManager.getLocation();
      expect(location == location2, true);
    });
  });
}
