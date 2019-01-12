import 'package:feather/src/utils/types_helper.dart';

class MainWeatherData{
  double _temp;
  double _pressure;
  double _humidity;
  double _tempMin;
  double _tempMax;
  double _pressureSeaLevel;
  double _pressureGroundLevel;

  MainWeatherData(Map<String,dynamic> data){
    _temp = TypesHelper.getDouble(data["temp"]);
    _pressure = TypesHelper.getDouble(data["pressure"]);
    _humidity = TypesHelper.getDouble(data["humidity"]);
    _tempMin = TypesHelper.getDouble(data["temp_min"]);
    _tempMax = TypesHelper.getDouble(data["temp_max"]);
    _pressureSeaLevel = TypesHelper.getDouble(data["sea_level"]);
  }

  double get pressureGroundLevel => _pressureGroundLevel;
  double get pressureSeaLevel => _pressureSeaLevel;
  double get tempMax => _tempMax;
  double get tempMin => _tempMin;
  double get humidity => _humidity;
  double get pressure => _pressure;
  double get temp => _temp;

}