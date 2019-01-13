import 'package:feather/src/utils/types_helper.dart';

class Wind {
  double _speed;
  double _deg;
  String _degCode;

  Wind(Map<String, dynamic> data) {
    _speed = changeToKilometersPerHour(TypesHelper.getDouble(data["speed"]));
    _deg = TypesHelper.getDouble(data["deg"]);
    setupDegCode();
  }

  void setupDegCode() {
    if (_deg == null){
      _degCode = "N";
      return;
    }
    if (_deg >= 0 && _deg < 45) {
      _degCode = "N";
    } else if (_deg >= 45 && _deg < 90) {
      _degCode = "NE";
    } else if (_deg >= 90 && _deg < 135) {
      _degCode = "E";
    } else if (_deg >= 135 && _deg < 180) {
      _degCode = "SE";
    } else if (_deg >= 180 && _deg < 225) {
      _degCode = "S";
    } else if (_deg >= 225 && _deg < 270) {
      _degCode = "SW";
    } else if (_deg >= 270 && _deg < 315) {
      _degCode = "W";
    } else if (_deg >= 315 && deg <= 360) {
      _degCode = "NW";
    }
  }

  double changeToKilometersPerHour(double value){
    if (value != null) {
      return value * 3.6;
    } else {
      return 0;
    }
  }


  double get deg => _deg;

  double get speed => _speed;

  String get degCode => _degCode;
}
