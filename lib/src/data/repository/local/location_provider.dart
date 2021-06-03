import 'package:geolocator/geolocator.dart';

class LocationProvider {
  Future<Position> providePosition() async {
    return Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<bool> isLocationEnabled() {
    return Geolocator.isLocationServiceEnabled();
  }

  Future<LocationPermission> checkLocationPermission() async {
    return Geolocator.checkPermission();
  }

  Future<LocationPermission> requestLocationPermission() async {
    return Geolocator.requestPermission();
  }
}
