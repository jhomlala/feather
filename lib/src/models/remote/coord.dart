import 'package:feather/src/utils/types_helper.dart';

class Coordinates {
  double _longitude;
  double _latitude;

  Coordinates(Map<String, dynamic> data) {
    _longitude = TypesHelper.getDouble(data["lon"]);
    _latitude = TypesHelper.getDouble(data["lat"]);
  }

  double get latitude => _latitude;

  double get longitude => _longitude;


}
