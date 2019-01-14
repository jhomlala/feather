import 'package:geolocator/geolocator.dart';

class GeoPosition {
  final double lat;
  final double long;

  GeoPosition(this.lat, this.long);

  GeoPosition.fromJson(Map<String, dynamic> json)
      : lat = json["lat"],
        long = json["long"];

  GeoPosition.fromPosition(Position position)
      : lat = position.latitude,
        long = position.longitude;

  Map<String, dynamic> toJson() => {
        "lat": lat,
        "long": long,
      };

  @override
  String toString() {
    return 'GeoPosition{lat: $lat, long: $long}';
  }
}
