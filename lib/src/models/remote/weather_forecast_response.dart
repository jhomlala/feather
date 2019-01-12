import 'package:feather/src/models/remote/city.dart';
import 'package:feather/src/models/remote/clouds.dart';
import 'package:feather/src/models/remote/main_weather_data.dart';
import 'package:feather/src/models/remote/overall_weather_data.dart';
import 'package:feather/src/models/remote/rain.dart';
import 'package:feather/src/models/remote/wind.dart';

class WeatherForecastResponse {
  MainWeatherData _mainWeatherData;
  List<OverallWeatherData> _overallWeatherData;
  Clouds _clouds;
  Wind _wind;
  DateTime _dateTime;
  Rain _rain;
  Rain _snow;

  WeatherForecastResponse(Map<String, dynamic> data) {
    _overallWeatherData = (data["weather"] as List)
        .map((i) => new OverallWeatherData(i))
        .toList();
    _mainWeatherData = MainWeatherData(data["main"]);
    _wind = Wind(data["wind"]);
    _clouds = Clouds(data["clouds"]);
    print(data["dt_txt"]);
    _dateTime = DateTime.parse(data["dt_txt"]);
    if (data.containsKey("rain")) {
      _rain = Rain(data["rain"]);
    }
    if (data.containsKey("snow")) {
      _snow = Rain(data["snow"]);
    }
  }

  DateTime get dateTime => _dateTime;

  Wind get wind => _wind;

  Clouds get clouds => _clouds;

  List<OverallWeatherData> get overallWeatherData => _overallWeatherData;

  MainWeatherData get mainWeatherData => _mainWeatherData;

  Rain get snow => _snow;

  Rain get rain => _rain;
}
