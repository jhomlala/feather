import 'package:feather/src/data/model/remote/weather_forecast_list_response.dart';
import 'package:feather/src/data/model/remote/weather_forecast_response.dart';
import 'package:feather/src/data/model/remote/weather_response.dart';
import 'package:feather/src/data/repository/remote/weather_remote_repository.dart';
import 'package:test/test.dart';

void main() {
  late WeatherRemoteRepository weatherRepository;

  setUpAll(() {
    weatherRepository = WeatherRemoteRepository();
  });

  test("Fetched weather not null and not empty", () async {
    final WeatherResponse weatherResponse =
        await weatherRepository.fetchWeather(0, 0);
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
    final WeatherForecastListResponse weatherForecastListResponse =
        await weatherRepository.fetchWeatherForecast(0, 0);
    expect(weatherForecastListResponse.list!.isNotEmpty, true);

    final WeatherForecastResponse response =
        weatherForecastListResponse.list![0];
    expect(response.mainWeatherData != null, true);
    expect(response.wind != null, true);
    expect(response.clouds != null, true);
    expect(response.overallWeatherData != null, true);
    expect(response.overallWeatherData!.isNotEmpty, true);
  });
}
