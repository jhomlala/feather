import 'package:feather/src/data/model/remote/city.dart';
import 'package:feather/src/data/model/remote/clouds.dart';
import 'package:feather/src/data/model/remote/coordinates.dart';
import 'package:feather/src/data/model/remote/main_weather_data.dart';
import 'package:feather/src/data/model/remote/overall_weather_data.dart';
import 'package:feather/src/data/model/remote/system.dart';
import 'package:feather/src/data/model/remote/weather_forecast_list_response.dart';
import 'package:feather/src/data/model/remote/weather_response.dart';
import 'package:feather/src/data/model/remote/wind.dart';

class WeatherUtils {
  static WeatherResponse getWeather({int id = 0}) {
    final Wind wind = Wind(5, 200);
    final MainWeatherData mainWeatherData =
        MainWeatherData(0, 0, 0, 0, 0, 0, 0);
    final OverallWeatherData overallWeatherData =
        OverallWeatherData(0, "", "", "");
    final List<OverallWeatherData> list = [];
    list.add(overallWeatherData);
    final System system = System("", 0, 0);
    final Coordinates coordinates = Coordinates(0, 0);
    final Clouds clouds = Clouds(0);
    final WeatherResponse weatherResponse = WeatherResponse(
      cord: coordinates,
      wind: wind,
      clouds: clouds,
      mainWeatherData: mainWeatherData,
      overallWeatherData: list,
      name: "",
      system: system,
      id: id,
      cod: 0,
      station: "",
    );
    return weatherResponse;
  }

  static WeatherForecastListResponse getWeatherForecastListResponse(
      {int id = 0}) {
    return WeatherForecastListResponse([], City(id, ""));
  }
}
