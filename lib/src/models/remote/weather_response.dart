import 'package:feather/src/models/remote/clouds.dart';
import 'package:feather/src/models/remote/coord.dart';
import 'package:feather/src/models/remote/main_weather_data.dart';
import 'package:feather/src/models/remote/overall_weather_data.dart';
import 'package:feather/src/models/remote/system.dart';
import 'package:feather/src/models/remote/wind.dart';

class WeatherResponse {
  Coordinates _cord;
  List<OverallWeatherData> _overallWeatherData;
  MainWeatherData _mainWeatherData;
  Wind _wind;
  Clouds _clouds;
  System _system;
  int _id;
  String _name;
  int _cod;
  String _station;
  String _errorCode;

  WeatherResponse(Map<String, dynamic> data) {
    if (data.length == 0) {
      return;
    }

    _cord = Coordinates(data["coord"]);
    _system = System(data["sys"]);
    _overallWeatherData = (data["weather"] as List)
        .map((i) => new OverallWeatherData(i))
        .toList();
    _mainWeatherData = MainWeatherData(data["main"]);
    _wind = Wind(data["main"]);
    _clouds = Clouds(data["clouds"]);
    _system = System(data["sys"]);
    _id = data["id"];
    _name = data["name"];
    _cod = data["cod"];
    _station = data["station"];
  }

  static WeatherResponse withErrorCode(String errorCode){
    WeatherResponse response = new WeatherResponse(new Map<String,dynamic>());
    response._errorCode = errorCode;
    return response;
  }

  System get system => _system;

  Clouds get clouds => _clouds;

  Wind get wind => _wind;

  MainWeatherData get mainWeatherData => _mainWeatherData;

  List<OverallWeatherData> get overallWeatherData => _overallWeatherData;

  Coordinates get cord => _cord;

  String get station => _station;

  int get cod => _cod;

  String get name => _name;

  int get id => _id;

  String get errorCode => _errorCode;

}
