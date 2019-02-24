import 'package:feather/src/models/remote/weather_forecast_response.dart';
import 'package:feather/src/resources/weather_helper.dart';
import 'package:test/test.dart';

main() {
  test("Should return valid weather icon code", () {
    expect(WeatherHelper.getWeatherIcon(0), "assets/icon_cloud.png");
    expect(WeatherHelper.getWeatherIcon(200), "assets/icon_thunder.png");
    expect(WeatherHelper.getWeatherIcon(250), "assets/icon_thunder.png");
    expect(WeatherHelper.getWeatherIcon(299), "assets/icon_thunder.png");
    expect(WeatherHelper.getWeatherIcon(300),
        "assets/icon_cloud_little_rain.png");
    expect(WeatherHelper.getWeatherIcon(350),
        "assets/icon_cloud_little_rain.png");
    expect(WeatherHelper.getWeatherIcon(399),
        "assets/icon_cloud_little_rain.png");
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
    List<WeatherForecastResponse> list = new List();
    list.add(new WeatherForecastResponse(
        null, null, null, null, DateTime.now(), null, null));
    list.add(new WeatherForecastResponse(
        null, null, null, null, DateTime.now(), null, null));
    list.add(new WeatherForecastResponse(
        null, null, null, null, DateTime.now(), null, null));
    list.add(new WeatherForecastResponse(null, null, null, null,
        DateTime.parse("1969-07-20 20:18:04Z"), null, null));

    var map = WeatherHelper.mapForecastsForSameDay(list);
    expect(map != null, true);
    expect(map.length, 2);
    for (var element in map.entries){
      expect(element.key != null && element.key.length >0 , true);
      expect(element.value != null, true);
      expect(element.value.length > 0, true);
    }
  });

  test("Format temperature should return valid formatted string", () {
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
}
