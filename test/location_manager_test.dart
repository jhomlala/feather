import 'package:feather/src/data/repository/local/location_manager.dart';
import 'package:flutter/material.dart';
import 'package:test/test.dart';

void main() {
  final LocationManager locationManager = LocationManager();

  test("Position should be optional with absent", () async {
    WidgetsFlutterBinding.ensureInitialized();
    final position = await locationManager.getLocation();
    expect(position, null);
  });
}
