import 'package:feather/src/data/model/remote/clouds.dart';
import 'package:feather/src/data/model/remote/coordinates.dart';
import 'package:feather/src/data/model/remote/main_weather_data.dart';
import 'package:feather/src/data/model/remote/overall_weather_data.dart';
import 'package:feather/src/data/model/remote/system.dart';
import 'package:feather/src/data/model/remote/weather_forecast_list_response.dart';
import 'package:feather/src/data/model/remote/weather_forecast_response.dart';
import 'package:feather/src/data/model/remote/weather_response.dart';
import 'package:feather/src/data/model/remote/wind.dart';
import 'package:feather/src/data/repository/remote/weather_api_provider.dart';
import 'package:test/test.dart';

void main() {
  late WeatherApiProvider weatherApiProvider;
  setUpAll(() {
    weatherApiProvider = WeatherApiProvider();
  });

  group("Current weather test", () {
    WeatherResponse? response;

    setUpAll(() async {
      response = await weatherApiProvider.fetchWeather(0, 0);
    });

    test("Weather object not null", () {
      expect(response != null, true);
    });

    test("Weather system object not null and not empty", () {
      final System system = response!.system!;
      expect(system.sunset != null, true);
      expect(system.sunrise != null, true);
      expect(system.sunrise! > 0, true);
      expect(system.sunset! > 0, true);
    });

    test("Weather main data object not null and not empty", () {
      final MainWeatherData mainWeatherData = response!.mainWeatherData!;
      expect(mainWeatherData.pressure > 0, true);
      expect(mainWeatherData.temp > 0, true);
      expect(mainWeatherData.humidity > 0, true);
      expect(mainWeatherData.tempMax > 0, true);
      expect(mainWeatherData.tempMin > 0, true);
    });

    test("Overall weather data object not null and not empty", () {
      final List<OverallWeatherData> overallWeatherDataList =
          response!.overallWeatherData!;
      expect(overallWeatherDataList.isNotEmpty, true);
      for (final OverallWeatherData overallWeatherData
          in overallWeatherDataList) {
        expect(overallWeatherData.id != null, true);
        expect(overallWeatherData.description != null, true);
        expect(overallWeatherData.icon != null, true);
        expect(overallWeatherData.main != null, true);
      }
    });

    test("Wind weather data object not null and not empty", () {
      final Wind wind = response!.wind!;
      expect(wind.deg >= 0 && wind.deg <= 360, true);
      expect(wind.speed >= 0, true);
    });

    test("Clouds weather data object not null and not empty", () {
      final Clouds clouds = response!.clouds!;
      expect(clouds.all != null, true);
    });

    test("Coordinates weather data object not null and not empty", () {
      final Coordinates coord = response!.cord!;
      expect(coord.longitude >= -180 && coord.longitude <= 180, true);
      expect(coord.latitude >= -180 && coord.latitude <= 180, true);
    });

    test("General weather data not null and not empty", () {
      expect(response!.id != null, true);
      expect(response!.name != null, true);
      expect(response!.cod != null, true);
    });
  });

  group("Weather forecast test", () {
    WeatherForecastListResponse? response;
    late WeatherForecastResponse forecastResponse;

    setUpAll(() async {
      response = await weatherApiProvider.fetchWeatherForecast(0, 0);
      forecastResponse = response!.list![0];
    });

    test("Weather forecast object not null and not empty", () {
      expect(response != null, true);
      expect(response!.list != null, true);
      expect(response!.list!.isNotEmpty, true);
    });

    test("Weather forecast city object not null and not empty", () {
      expect(response!.city != null, true);
      expect(response!.city!.name != null, true);
      expect(response!.city!.id != null, true);
    });

    test("Weather forecast element object not null and not empty", () {
      expect(forecastResponse.overallWeatherData != null, true);
      expect(forecastResponse.clouds != null, true);
      expect(forecastResponse.wind != null, true);
      expect(forecastResponse.mainWeatherData != null, true);
      expect(forecastResponse.snow != null, true);
      expect(forecastResponse.rain != null, true);
    });

    test(
        "Weather forecast element object overall weather data not null and not empty",
        () {
      final List<OverallWeatherData> overallWeatherDataList =
          forecastResponse.overallWeatherData!;
      expect(overallWeatherDataList.isNotEmpty, true);
      for (final OverallWeatherData overallWeatherData
          in overallWeatherDataList) {
        expect(overallWeatherData.id != null, true);
        expect(overallWeatherData.description != null, true);
        expect(overallWeatherData.icon != null, true);
        expect(overallWeatherData.main != null, true);
      }
    });

    test(
        "Weather forecast element object main data object not null and not empty",
        () {
      final MainWeatherData mainWeatherData = forecastResponse.mainWeatherData!;
      expect(mainWeatherData.pressure > 0, true);
      expect(mainWeatherData.temp > 0, true);
      expect(mainWeatherData.humidity > 0, true);
      expect(mainWeatherData.tempMax > 0, true);
      expect(mainWeatherData.tempMin > 0, true);
    });

    test("Weather forecast element object wind not null and not empty", () {
      final Wind wind = forecastResponse.wind!;
      expect(wind.deg >= 0 && wind.deg <= 360, true);
      expect(wind.speed >= 0, true);
    });

    test("Weather forecast element object clouds not null and not empty", () {
      final Clouds clouds = forecastResponse.clouds!;
      expect(clouds.all != null, true);
    });
  });
}
