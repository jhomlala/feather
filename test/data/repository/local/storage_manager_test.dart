import 'package:feather/src/data/model/internal/geo_position.dart';
import 'package:feather/src/data/model/internal/unit.dart';
import 'package:feather/src/data/repository/local/storage_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../model/weather_utils.dart';
import 'fake_storage_provider.dart';

void main() {
  late StorageManager _storageManager;
  setUpAll(() {
    _storageManager = StorageManager(FakeStorageProvider());
  });

  group("Unit", () {
    test("getUnit returns default unit", () async {
      expect(await _storageManager.getUnit(), Unit.metric);
    });

    test("getUnit returns saved Unit", () async {
      _storageManager.saveUnit(Unit.imperial);
      expect(await _storageManager.getUnit(), Unit.imperial);

      _storageManager.saveUnit(Unit.metric);
      expect(await _storageManager.getUnit(), Unit.metric);
    });

    test("saveUnit returns true", () async {
      expect(await _storageManager.saveUnit(Unit.imperial), true);
      expect(await _storageManager.saveUnit(Unit.metric), true);
    });
  });

  group("Refresh time", () {
    test("refreshTime returns default value", () async {
      expect(await _storageManager.getRefreshTime(), 600000);
    });

    test("Refresh time saves refresh time", () async {
      _storageManager.saveRefreshTime(1000);
      expect(await _storageManager.getRefreshTime(), 1000);
    });

    test("Save refresh time returns true", () async {
      expect(await _storageManager.saveRefreshTime(1000), true);
    });
  });

  group("Last Refresh time", () {
    test("Last Refresh time returns default value", () async {
      expect(await _storageManager.getLastRefreshTime() != 0, true);
    });

    test("Last refresh time saves refresh time", () async {
      await _storageManager.saveLastRefreshTime(1000);
      expect(await _storageManager.getLastRefreshTime(), 1000);
    });

    test("Save last refresh time returns true", () async {
      expect(await _storageManager.saveLastRefreshTime(1000), true);
    });
  });

  group("Last Refresh time", () {
    test("Last Refresh time returns default value", () async {
      expect(await _storageManager.getLastRefreshTime() != 0, true);
    });

    test("Last refresh time saves refresh time", () async {
      await _storageManager.saveLastRefreshTime(1000);
      expect(await _storageManager.getLastRefreshTime(), 1000);
    });

    test("Save last refresh time returns true", () async {
      expect(await _storageManager.saveLastRefreshTime(1000), true);
    });
  });

  group("Location", () {
    test("Location returns default value", () async {
      expect(await _storageManager.getLocation(), null);
    });

    test("Save location saves location", () async {
      await _storageManager.saveLocation(GeoPosition(1, 1));
      final position = await _storageManager.getLocation();
      expect(position != null, true);
      expect(position?.lat == 1.0, true);
      expect(position?.long == 1.0, true);
    });

    test("Save last refresh time returns true", () async {
      expect(await _storageManager.saveLocation(GeoPosition(1, 1)), true);
    });
  });

  group("Weather", () {
    test("Weather returns default value", () async {
      expect(await _storageManager.getWeather(), null);
    });

    test("Save weather saves weather", () async {
      final weatherResponse = WeatherUtils.getWeather();

      await _storageManager.saveWeather(weatherResponse);
      final weather = await _storageManager.getWeather();
      expect(weather != null, true);
      expect(weather?.id, 0);
    });

    test("Save weather returns true", () async {
      final result =
          await _storageManager.saveWeather(WeatherUtils.getWeather());
      expect(result, true);
    });
  });

  group("Weather forecast", () {
    test("Weather forecast returns default value", () async {
      expect(await _storageManager.getWeatherForecast(), null);
    });

    test("Save weather forecast saves weather", () async {
      final weatherForecastResponse =
          WeatherUtils.getWeatherForecastListResponse();

      await _storageManager.saveWeatherForecast(weatherForecastResponse);
      final weatherForecast = await _storageManager.getWeatherForecast();
      expect(weatherForecast != null, true);
    });

    test("Save weather forecast returns true", () async {
      final result = await _storageManager
          .saveWeatherForecast(WeatherUtils.getWeatherForecastListResponse());
      expect(result, true);
    });
  });
}
