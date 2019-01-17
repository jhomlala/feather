import 'package:feather/src/utils/types_helper.dart';

class Coordinates {
  final double longitude;
  final double latitude;

  Coordinates(this.longitude, this.latitude);

  Coordinates.fromJson(Map<String, dynamic> json)
      : longitude = TypesHelper.getDouble(json["lon"]),
        latitude = TypesHelper.getDouble(json["lat"]);

  Map<String,dynamic> toJson() => {
    "longitude":longitude,
    "latitude":latitude
  };

}
