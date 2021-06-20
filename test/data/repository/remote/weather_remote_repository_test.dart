import 'package:feather/src/data/model/remote/weather_forecast_list_response.dart';
import 'package:feather/src/data/model/remote/weather_response.dart';
import 'package:feather/src/data/repository/remote/weather_remote_repository.dart';
import 'package:test/test.dart';

import 'fake_weather_api_provider.dart';

void main() {
  late WeatherRemoteRepository weatherRepository;

  setUpAll(() {
    weatherRepository = WeatherRemoteRepository(FakeWeatherApiProvider());
  });

  group("Weather", () {
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
  });

  group("Forecast weather", () {
    test("Fetched weather forecast not null", () async {
      final WeatherForecastListResponse weatherForecastListResponse =
          await weatherRepository.fetchWeatherForecast(0, 0);
      expect(weatherForecastListResponse.city != null, true);
    });
  });
}
