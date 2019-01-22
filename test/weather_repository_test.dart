import 'package:feather/src/models/remote/weather_forecast_list_response.dart';
import 'package:feather/src/models/remote/weather_forecast_response.dart';
import 'package:feather/src/models/remote/weather_response.dart';
import 'package:feather/src/resources/repository/remote/weather_remote_repository.dart';
import 'package:test/test.dart';

main() {
  WeatherRemoteRepository weatherRepository;

  setUpAll(() {
    weatherRepository = new WeatherRemoteRepository();
  });

  test("Fetched weather not null and not empty", () async {
    WeatherResponse weatherResponse =
        await weatherRepository.fetchWeather(0, 0);
    expect(weatherResponse != null, true);
    expect(weatherResponse.mainWeatherData != null, true);
    expect(weatherResponse.wind != null, true);
    expect(weatherResponse.clouds != null, true);
    expect(weatherResponse.overallWeatherData != null, true);
    expect(weatherResponse.system != null, true);
    expect(weatherResponse.cord != null, true);
    expect(weatherResponse.id != null, true);
    expect(weatherResponse.name != null, true);
  });

  test("Fetched weather forecast not null and not empty", () async {
    WeatherForecastListResponse weatherForecastListResponse =
        await weatherRepository.fetchWeatherForecast(0, 0);
    expect(weatherForecastListResponse != null, true);
    expect(weatherForecastListResponse.list.length > 0, true);

    WeatherForecastResponse response = weatherForecastListResponse.list[0];
    expect(response != null, true);
    expect(response.mainWeatherData != null, true);
    expect(response.wind != null, true);
    expect(response.clouds != null, true);
    expect(response.overallWeatherData != null, true);
    expect(response.overallWeatherData.length > 0, true);
  });
}
