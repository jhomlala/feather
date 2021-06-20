import 'package:feather/src/data/repository/local/location_provider.dart';
import 'package:feather/src/utils/app_logger.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

///Class used to provide location of the device.
class LocationManager {
  final LocationProvider _locationProvider;
  Position? _lastPosition;

  LocationManager(this._locationProvider);

  Future<Position?> getLocation() async {
    try {
      if (_lastPosition != null) {
        return _lastPosition;
      }
      // ignore: join_return_with_assignment
      _lastPosition = await _locationProvider.providePosition();
      return _lastPosition;
    } catch (exc, stackTrace) {
      Log.e("Exception occurred: $exc in $stackTrace");
      return null;
    }
  }

  Future<bool> isLocationEnabled() {
    return _locationProvider.isLocationEnabled();
  }

  Future<LocationPermission> checkLocationPermission() async{
    return _locationProvider.checkLocationPermission();
  }

  Future<LocationPermission> requestLocationPermission() async{
    return _locationProvider.requestLocationPermission();
  }


  @visibleForTesting
  Position? get lastPosition => _lastPosition;
}
