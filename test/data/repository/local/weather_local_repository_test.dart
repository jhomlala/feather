import 'package:feather/src/data/model/internal/geo_position.dart';
import 'package:feather/src/data/repository/local/weather_local_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../model/weather_utils.dart';
import 'fake_storage_manager.dart';

void main() {
  late WeatherLocalRepository weatherLocalRepository;

  setUp(() {
    weatherLocalRepository = WeatherLocalRepository(FakeStorageManager());
  });

  group("Location", () {
    test("get location returns default location", () async {
      final savedLocation = await weatherLocalRepository.getLocation();
      expect(savedLocation != null, true);
      expect(savedLocation?.lat == 0, true);
      expect(savedLocation?.long == 0, true);
    });

    test("save location saves location", () async {
      weatherLocalRepository.saveLocation(GeoPosition(1, 1));
      final savedLocation = await weatherLocalRepository.getLocation();
      expect(savedLocation != null, true);
      expect(savedLocation?.lat == 1, true);
      expect(savedLocation?.long == 1, true);
    });
  });

  group("Weather", () {
    test("get weather returns default weather data", () async {
      final savedWeather = await weatherLocalRepository.getWeather();
      expect(savedWeather != null, true);
      expect(savedWeather?.id, WeatherUtils.getWeather().id);
    });

    test("save weather saves weather data", () async {
      weatherLocalRepository.saveWeather(WeatherUtils.getWeather(id: 1));
      final savedWeather = await weatherLocalRepository.getWeather();
      expect(savedWeather != null, true);
      expect(savedWeather?.id == 1, true);
    });
  });

  group("Weather forecast", () {
    test("get weather forecast returns default weather data", () async {
      final savedWeatherForecast =
          await weatherLocalRepository.getWeatherForecast();
      expect(savedWeatherForecast != null, true);
      expect(savedWeatherForecast?.city!.id == 0, true);
    });

    test("save weather saves weather data", () async {
      weatherLocalRepository.saveWeatherForecast(
          WeatherUtils.getWeatherForecastListResponse(id: 1));
      final savedWeatherForecast =
          await weatherLocalRepository.getWeatherForecast();
      expect(savedWeatherForecast != null, true);
      expect(savedWeatherForecast?.city?.id == 1, true);
    });
  });
}
