import 'package:feather/src/utils/app_logger.dart';
import 'package:geolocator/geolocator.dart';

class LocationManager {
  Position? _lastPosition;

  static final LocationManager _instance = LocationManager._internal();

  LocationManager._internal();

  factory LocationManager() {
    return _instance;
  }

  Future<Position?> getLocation() async {
    try {
      if (_lastPosition != null) {
        return _lastPosition;
      }

      // ignore: join_return_with_assignment
      _lastPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      return _lastPosition;
    } catch (exc, stackTrace) {
      Log.e("Exception occurred: $exc in $stackTrace");
      return null;
    }
  }
}
