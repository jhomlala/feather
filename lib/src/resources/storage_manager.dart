import 'dart:convert';

import 'package:feather/src/models/internal/geo_position.dart';
import 'package:feather/src/resources/app_const.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageManager {
  final Logger _logger = Logger("StorageManager");


  saveLocation(GeoPosition geoPosition) async {
    var sharedPreferences = await SharedPreferences.getInstance();
    _logger.log(Level.FINE, "Store location: $geoPosition");
    sharedPreferences.setString(
        AppConst.storageLocationKey, json.encode(geoPosition));
  }

  Future<GeoPosition> getLocation() async {
    var sharedPreferences = await SharedPreferences.getInstance();

    String jsonData = sharedPreferences.getString(AppConst.storageLocationKey);
    _logger.log(Level.FINE, "Returned user location: $jsonData");
    if (jsonData != null) {
      return GeoPosition.fromJson(json.decode(jsonData));
    } else {
      return null;
    }
  }
}
