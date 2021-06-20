import 'package:feather/src/data/model/remote/system.dart';
import 'package:feather/src/data/model/remote/weather_forecast_response.dart';
import 'package:feather/src/data/repository/local/weather_helper.dart';

import 'package:test/test.dart';

void main() {
  test("Get weather returns valid weather icon code", () {
    expect(WeatherHelper.getWeatherIcon(0), "assets/icon_cloud.png");
    expect(WeatherHelper.getWeatherIcon(200), "assets/icon_thunder.png");
    expect(WeatherHelper.getWeatherIcon(250), "assets/icon_thunder.png");
    expect(WeatherHelper.getWeatherIcon(299), "assets/icon_thunder.png");
    expect(
        WeatherHelper.getWeatherIcon(300), "assets/icon_cloud_little_rain.png");
    expect(
        WeatherHelper.getWeatherIcon(350), "assets/icon_cloud_little_rain.png");
    expect(
        WeatherHelper.getWeatherIcon(399), "assets/icon_cloud_little_rain.png");
    expect(WeatherHelper.getWeatherIcon(500), "assets/icon_rain.png");
    expect(WeatherHelper.getWeatherIcon(550), "assets/icon_rain.png");
    expect(WeatherHelper.getWeatherIcon(599), "assets/icon_rain.png");
    expect(WeatherHelper.getWeatherIcon(600), "assets/icon_snow.png");
    expect(WeatherHelper.getWeatherIcon(650), "assets/icon_snow.png");
    expect(WeatherHelper.getWeatherIcon(699), "assets/icon_snow.png");
    expect(WeatherHelper.getWeatherIcon(700), "assets/icon_dust.png");
    expect(WeatherHelper.getWeatherIcon(750), "assets/icon_dust.png");
    expect(WeatherHelper.getWeatherIcon(799), "assets/icon_dust.png");
    expect(WeatherHelper.getWeatherIcon(800), "assets/icon_sun.png");
    expect(WeatherHelper.getWeatherIcon(802), "assets/icon_cloud.png");
  });

  test("Should map forecasts for same day", () {
    final List<WeatherForecastResponse> list = [];
    list.add(WeatherForecastResponse(
        null, null, null, null, DateTime.now(), null, null));
    list.add(WeatherForecastResponse(
        null, null, null, null, DateTime.now(), null, null));
    list.add(WeatherForecastResponse(
        null, null, null, null, DateTime.now(), null, null));
    list.add(WeatherForecastResponse(null, null, null, null,
        DateTime.parse("1969-07-20 20:18:04Z"), null, null));

    final map = WeatherHelper.getMapForecastsForSameDay(list);
    expect(map.length, 2);
    for (final element in map.entries) {
      expect(element.value.isNotEmpty, true);
    }
  });

  test("Format temperature returns valid formatted string", () {
    expect(WeatherHelper.formatTemperature(temperature: 0.0), "0 °C");
    expect(WeatherHelper.formatTemperature(temperature: 5.531), "5 °C");
    expect(
        WeatherHelper.formatTemperature(
            temperature: -5.531, positions: 1, round: false),
        "-5.5 °C");
    expect(WeatherHelper.formatTemperature(temperature: -5.531, positions: 1),
        "-6.0 °C");
    expect(
        WeatherHelper.formatTemperature(
            temperature: 5.555, positions: 2, round: false),
        "5.55 °C");
  });

  test("Convert celsius to fahrenheit returns valid values", () {
    expect(WeatherHelper.convertCelsiusToFahrenheit(0), 32);
    expect(WeatherHelper.convertCelsiusToFahrenheit(10), 50);
    expect(WeatherHelper.convertCelsiusToFahrenheit(50), 122);
    expect(WeatherHelper.convertCelsiusToFahrenheit(100), 212);
  });

  test("Convert fahrenheit to celsius returns valid values", () {
    expect(WeatherHelper.convertFahrenheitToCelsius(32), 0);
    expect(WeatherHelper.convertFahrenheitToCelsius(50), 10);
    expect(WeatherHelper.convertFahrenheitToCelsius(122), 50);
    expect(WeatherHelper.convertFahrenheitToCelsius(212), 100);
  });

  test("Convert meters per second to kilometers per hour returns valid values",
      () {
    expect(WeatherHelper.convertMetersPerSecondToKilometersPerHour(0), 0);
    expect(WeatherHelper.convertMetersPerSecondToKilometersPerHour(10), 36);
    expect(WeatherHelper.convertMetersPerSecondToKilometersPerHour(50), 180);
    expect(WeatherHelper.convertMetersPerSecondToKilometersPerHour(100), 360);
  });

  test("Convert meters per second to miles per hour returns valid values", () {
    expect(WeatherHelper.convertMetersPerSecondToMilesPerHour(0), 0);
    expect(WeatherHelper.convertMetersPerSecondToMilesPerHour(10).round(),
        22.3694.round());
    expect(WeatherHelper.convertMetersPerSecondToMilesPerHour(50).round(),
        111.847.round());
    expect(WeatherHelper.convertMetersPerSecondToMilesPerHour(100).round(),
        223.694.round());
  });

  test("Format rain returns formatted value", () {
    expect(WeatherHelper.formatRain(0), "0.00 mm/h");
    expect(WeatherHelper.formatRain(1.56), "1.56 mm/h");
    expect(WeatherHelper.formatRain(10), "10.00 mm/h");
    expect(WeatherHelper.formatRain(100.23), "100.23 mm/h");
    expect(WeatherHelper.formatRain(1000.10234), "1000.10 mm/h");
    expect(WeatherHelper.formatRain(1000.10634), "1000.11 mm/h");
  });

  test("Format wind returns formatted value", () {
    expect(WeatherHelper.formatWind(0, true), "0.0 km/h");
    expect(WeatherHelper.formatWind(1.56, true), "1.6 km/h");
    expect(WeatherHelper.formatWind(10, true), "10.0 km/h");
    expect(WeatherHelper.formatWind(100.23, true), "100.2 km/h");
    expect(WeatherHelper.formatWind(1000.10234, true), "1000.1 km/h");
    expect(WeatherHelper.formatWind(1000.10634, true), "1000.1 km/h");

    expect(WeatherHelper.formatWind(0, false), "0.0 mi/h");
    expect(WeatherHelper.formatWind(1.56, false), "1.6 mi/h");
    expect(WeatherHelper.formatWind(10, false), "10.0 mi/h");
    expect(WeatherHelper.formatWind(100.23, false), "100.2 mi/h");
    expect(WeatherHelper.formatWind(1000.10234, false), "1000.1 mi/h");
    expect(WeatherHelper.formatWind(1000.10634, false), "1000.1 mi/h");
  });

  test("Format humidity returns formatted value", () {
    expect(WeatherHelper.formatHumidity(0), "0%");
    expect(WeatherHelper.formatHumidity(1.56), "2%");
    expect(WeatherHelper.formatHumidity(10), "10%");
    expect(WeatherHelper.formatHumidity(100.23), "100%");
    expect(WeatherHelper.formatHumidity(1000.10234), "1000%");
    expect(WeatherHelper.formatHumidity(1000.10634), "1000%");
  });

  test("Get day mode returns valid value", () {
    final sunrise = DateTime.now().add(const Duration(hours: 1));
    final sunset = DateTime.now().add(const Duration(hours: 8));
    final System system = System(
        "", sunrise.millisecondsSinceEpoch, sunset.millisecondsSinceEpoch);
    expect(WeatherHelper.getDayMode(system), -1);
  });

  test("get day mode from sunrise sunset returns valid value", () {
    final sunrise =
        DateTime.now().add(const Duration(hours: 1)).millisecondsSinceEpoch;
    final sunset =
        DateTime.now().add(const Duration(hours: 8)).millisecondsSinceEpoch;
    expect(WeatherHelper.getDayModeFromSunriseSunset(sunrise, sunset), -1);

    final sunriseLowerThaNow = DateTime.now()
        .subtract(const Duration(hours: 1))
        .millisecondsSinceEpoch;
    expect(
        WeatherHelper.getDayModeFromSunriseSunset(sunriseLowerThaNow, sunset),
        0);

    expect(
        WeatherHelper.getDayModeFromSunriseSunset(
            sunriseLowerThaNow, sunriseLowerThaNow),
        1);
  });
}
