import 'dart:async';

import 'package:feather/src/models/remote/weather_forecast_list_response.dart';
import 'package:feather/src/models/remote/weather_response.dart';
import 'package:feather/src/resources/location_manager.dart';
import 'package:feather/src/resources/weather_repository.dart';
import 'package:rxdart/rxdart.dart';

class WeatherBloc {
  final _weatherRepository = WeatherRepository();
  final _locationManager = LocationManager();
  final _weatherFetcher = PublishSubject<WeatherResponse>();
  final _weatherForecastFetcher = PublishSubject<WeatherForecastListResponse>();
  final _weatherRefreshTimeInSeconds = 900;
  Timer _timer;

  Observable<WeatherResponse> get weather => _weatherFetcher.stream;

  Observable<WeatherForecastListResponse> get weatherForecast =>
      _weatherForecastFetcher.stream;

  fetchWeatherForUserLocation() async {
    print("Fetch weather for user location");
    var positionOptional = await _locationManager.getLocation();
    if (positionOptional.isPresent) {
      var position = positionOptional.value;
      fetchWeather(position.latitude, position.longitude);
    } else {
      _weatherFetcher.sink
          .add(WeatherResponse.withErrorCode("ERROR_LOCATION_NOT_SELECTED"));
    }
  }

  fetchWeather(double latitude, double longitude) async {
    print("Fetch weather");
    WeatherResponse weatherResponse =
        await _weatherRepository.fetchWeather(latitude, longitude);
    _weatherFetcher.sink.add(weatherResponse);
  }

  fetchWeatherForecastForUserLocation() async {
    print("Fetch weather forecast for user location");
    var positionOptional = await _locationManager.getLocation();
    if (positionOptional.isPresent) {
      var position = positionOptional.value;
      fetchWeatherForecast(position.latitude, position.longitude);
    } else {
      _weatherForecastFetcher.sink.add(
          WeatherForecastListResponse.withErrorCode(
              "ERROR_LOCATION_NOT_SELECTED"));
    }
  }

  fetchWeatherForecast(double latitude, double longitude) async {
    print("Fetch weather forecast");
    WeatherForecastListResponse weatherForecastResponse =
        await _weatherRepository.fetchWeatherForecast(latitude, longitude);
    _weatherForecastFetcher.sink.add(weatherForecastResponse);
  }

  setupTimer() {
    print("Setup timer");
    var duration = Duration(seconds: _weatherRefreshTimeInSeconds);
    _timer = new Timer(duration, handleTimerTimeout);
  }

  handleTimerTimeout() {
    print("handle timer timeout");
    setupTimer();
    fetchWeatherForUserLocation();
  }

  dispose() {
    print("Dispose");
    _weatherFetcher.close();
    _weatherForecastFetcher.close();
  }
}

final bloc = WeatherBloc();
