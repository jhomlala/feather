import 'package:feather/src/data/repository/local/location_provider.dart';
import 'package:geolocator/geolocator.dart';

///Fake location provider which always return fake data.
class FakeLocationProvider extends LocationProvider {
  final bool useSecondDataSet;

  FakeLocationProvider({this.useSecondDataSet = false});

  @override
  Future<Position> providePosition() async {
    return Position(
        longitude: 0.0,
        latitude: 0.0,
        timestamp: DateTime.now(),
        altitude: 0.0,
        accuracy: 0.0,
        heading: 0.0,
        floor: 0,
        speed: 0.0,
        speedAccuracy: 0.0);
  }

  @override
  Future<bool> isLocationEnabled() async {
    return true;
  }

  @override
  Future<LocationPermission> checkLocationPermission() async {
    return LocationPermission.always;
  }

  @override
  Future<LocationPermission> requestLocationPermission() async {
    return Geolocator.requestPermission();
  }
}
