import 'package:feather/src/utils/optional.dart';
import 'package:geolocator/geolocator.dart';

class LocationManager {
  Position _lastPosition;

  Future<Optional<Position>> getLocation() async {
    try {
      if (_lastPosition != null) {
        return Optional.of(_lastPosition);
      }
      Position positionSelected = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      _lastPosition = positionSelected;
      return Optional.of(_lastPosition);
    } catch (exc) {
      return Optional.absent();
    }
  }
}
