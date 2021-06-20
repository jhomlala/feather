import 'package:feather/src/data/model/internal/application_error.dart';
import 'package:feather/src/data/model/remote/clouds.dart';
import 'package:feather/src/data/model/remote/coordinates.dart';
import 'package:feather/src/data/model/remote/main_weather_data.dart';
import 'package:feather/src/data/model/remote/overall_weather_data.dart';
import 'package:feather/src/data/model/remote/system.dart';
import 'package:feather/src/data/model/remote/wind.dart';

class WeatherResponse {
  final Coordinates? cord;
  final List<OverallWeatherData>? overallWeatherData;
  final MainWeatherData? mainWeatherData;
  final Wind? wind;
  final Clouds? clouds;
  final System? system;
  final int? id;
  final String? name;
  final int? cod;
  final String? station;
  ApplicationError? _errorCode;

  WeatherResponse({
    this.cord,
    this.overallWeatherData,
    this.mainWeatherData,
    this.wind,
    this.clouds,
    this.system,
    this.id,
    this.name,
    this.cod,
    this.station,
  });

  WeatherResponse.fromJson(Map<String, dynamic> json)
      : cord = Coordinates.fromJson(json["coord"] as Map<String, dynamic>),
        system = System.fromJson(json["sys"] as Map<String, dynamic>),
        overallWeatherData = (json["weather"] as List)
            .map((dynamic data) =>
                OverallWeatherData.fromJson(data as Map<String, dynamic>))
            .toList(),
        mainWeatherData =
            MainWeatherData.fromJson(json["main"] as Map<String, dynamic>),
        wind = Wind.fromJson(json["wind"] as Map<String, dynamic>),
        clouds = Clouds.fromJson(json["clouds"] as Map<String, dynamic>),
        id = json["id"] as int?,
        name = json["name"] as String?,
        cod = json["cod"] as int?,
        station = json["station"] as String?;

  Map<String, dynamic> toJson() => <String, dynamic>{
        "coord": cord,
        "sys": system,
        "weather": overallWeatherData,
        "main": mainWeatherData,
        "wind": wind,
        "clouds": clouds,
        "id": id,
        "name": name,
        "cod": cod,
        "station": station,
      };

  static WeatherResponse withErrorCode(ApplicationError errorCode) {
    final WeatherResponse response = WeatherResponse();
    response._errorCode = errorCode;
    return response;
  }

  ApplicationError? get errorCode => _errorCode;
}
