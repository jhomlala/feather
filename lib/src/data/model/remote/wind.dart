import 'package:feather/src/utils/types_helper.dart';

class Wind {
  final double speed;
  final double deg;

  Wind(this.speed, this.deg);

  Wind.fromJson(Map<String, dynamic> json)
      : speed = TypesHelper.toDouble(json["speed"] as num),
        deg = TypesHelper.toDouble(json["deg"] as num);

  Map<String, dynamic> toJson() => <String, dynamic>{
        "speed": speed,
        "deg": deg,
      };

  String getDegCode() {
    if (deg == 0.0) {
      return "N";
    }
    if (deg >= 0 && deg < 45) {
      return "N";
    } else if (deg >= 45 && deg < 90) {
      return "NE";
    } else if (deg >= 90 && deg < 135) {
      return "E";
    } else if (deg >= 135 && deg < 180) {
      return "SE";
    } else if (deg >= 180 && deg < 225) {
      return "S";
    } else if (deg >= 225 && deg < 270) {
      return "SW";
    } else if (deg >= 270 && deg < 315) {
      return "W";
    } else if (deg >= 315 && deg <= 360) {
      return "NW";
    } else {
      return "N";
    }
  }
}
