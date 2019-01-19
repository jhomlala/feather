import 'package:feather/src/models/internal/geo_position.dart';
import 'package:feather/src/resources/location_manager.dart';
import 'package:feather/src/resources/storage_manager.dart';
import 'package:feather/src/resources/weather_repository.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

class BaseBloc{
  @protected final weatherRepository = WeatherRepository();
  @protected final locationManager = LocationManager();
  @protected final storageManager = StorageManager();
  final Logger _logger = Logger("BaseBloc");

  @protected Future<GeoPosition> getPosition() async {
    try {
      var positionOptional = await locationManager.getLocation();
      if (positionOptional.isPresent) {
        _logger.fine("Position is present!");
        var position = positionOptional.value;
        GeoPosition geoPosition = GeoPosition.fromPosition(position);
        storageManager.saveLocation(geoPosition);
        return geoPosition;
      } else {
        _logger.fine("Position is not present!");
        return storageManager.getLocation();
      }
    } catch (exc, stackTrace) {
      _logger.warning("Exception: $exc in stackTrace: $stackTrace");
      return null;
    }
  }

}