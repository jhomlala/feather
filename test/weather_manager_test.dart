import 'package:feather/src/models/remote/weather_forecast_response.dart';
import 'package:feather/src/resources/weather_manager.dart';
import 'package:test/test.dart';

main() {
  test("Should return valid weather icon code", () {
    expect(WeatherManager.getWeatherIcon(0), "assets/icon_cloud.png");
    expect(WeatherManager.getWeatherIcon(200), "assets/icon_thunder.png");
    expect(WeatherManager.getWeatherIcon(250), "assets/icon_thunder.png");
    expect(WeatherManager.getWeatherIcon(299), "assets/icon_thunder.png");
    expect(WeatherManager.getWeatherIcon(300),
        "assets/icon_cloud_little_rain.png");
    expect(WeatherManager.getWeatherIcon(350),
        "assets/icon_cloud_little_rain.png");
    expect(WeatherManager.getWeatherIcon(399),
        "assets/icon_cloud_little_rain.png");
    expect(WeatherManager.getWeatherIcon(500), "assets/icon_rain.png");
    expect(WeatherManager.getWeatherIcon(550), "assets/icon_rain.png");
    expect(WeatherManager.getWeatherIcon(599), "assets/icon_rain.png");
    expect(WeatherManager.getWeatherIcon(600), "assets/icon_snow.png");
    expect(WeatherManager.getWeatherIcon(650), "assets/icon_snow.png");
    expect(WeatherManager.getWeatherIcon(699), "assets/icon_snow.png");
    expect(WeatherManager.getWeatherIcon(700), "assets/icon_dust.png");
    expect(WeatherManager.getWeatherIcon(750), "assets/icon_dust.png");
    expect(WeatherManager.getWeatherIcon(799), "assets/icon_dust.png");
    expect(WeatherManager.getWeatherIcon(800), "assets/icon_sun.png");
    expect(WeatherManager.getWeatherIcon(802), "assets/icon_cloud.png");
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

    var map = WeatherManager.mapForecastsForSameDay(list);
    expect(map != null, true);
    expect(map.length, 2);
    for (var element in map.entries){
      expect(element.key != null && element.key.length >0 , true);
      expect(element.value != null, true);
      expect(element.value.length > 0, true);
    }
  });


}
