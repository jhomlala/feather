import 'package:geolocator/geolocator.dart';

class GeoPosition {
  final double? lat;
  final double? long;

  GeoPosition(this.lat, this.long);

  GeoPosition.fromJson(Map<String, dynamic> json)
      : lat = json["lat"] as double?,
        long = json["long"] as double?;

  GeoPosition.fromPosition(Position position)
      : lat = position.latitude,
        long = position.longitude;

  Map<String, dynamic> toJson() => <String, dynamic>{
        "lat": lat,
        "long": long,
      };

  @override
  String toString() {
    return 'GeoPosition{lat: $lat, long: $long}';
  }
}
