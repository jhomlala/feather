import 'package:feather/src/utils/types_helper.dart';

class Coordinates {
  final double longitude;
  final double latitude;

  Coordinates(this.longitude, this.latitude);

  Coordinates.fromJson(Map<String, dynamic> json)
      : longitude = TypesHelper.toDouble(json["lon"] as num?),
        latitude = TypesHelper.toDouble(json["lat"] as num?);

  Map<String, dynamic> toJson() =>
      <String, dynamic>{"longitude": longitude, "latitude": latitude};
}
