import 'package:geolocator/geolocator.dart';

class LocationProvider {
  Future<Position> providePosition() async {
    return Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }
}
