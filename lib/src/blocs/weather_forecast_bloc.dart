import 'dart:async';

import 'package:feather/src/blocs/application_bloc.dart';
import 'package:feather/src/blocs/base_bloc.dart';
import 'package:feather/src/models/internal/application_error.dart';
import 'package:feather/src/models/internal/geo_position.dart';
import 'package:feather/src/models/remote/weather_forecast_list_response.dart';
import 'package:logging/logging.dart';
import 'package:rxdart/rxdart.dart';

class WeatherForecastBloc extends BaseBloc {
  final Logger _logger = Logger("WeatherForecastBloc");
  final weatherForecastSubject = BehaviorSubject<WeatherForecastListResponse>();
  int lastRequestTime = 0;
  Timer _timer;

  @override
  setupTimer() {
    _logger.log(Level.FINE, "Setup timer");
    if (_timer == null) {
      var duration = Duration(milliseconds: applicationBloc.refreshTime);
      _timer = new Timer(duration, handleTimerTimeout);
    } else {
      _logger.warning(
          "Could not setup new timer, because previous isn't finished");
    }
  }

  @override
  void handleTimerTimeout() {
    _timer = null;
    setupTimer();
    fetchWeatherForecastForUserLocation();
  }

  @override
  void dispose() {
    weatherForecastSubject.close();
  }

  fetchWeatherForecastForUserLocation() async {
    _logger.log(Level.FINE, "Fetch weather forecast for user location");

    GeoPosition geoPosition = await getPosition();
    if (geoPosition != null) {
      fetchWeatherForecast(geoPosition.lat, geoPosition.long);
    } else {
      _logger.log(Level.WARNING,
          "Fetch weather forecast for user location failed because location not selected");
      weatherForecastSubject.sink.add(WeatherForecastListResponse.withErrorCode(
          ApplicationError.locationNotSelectedError));
    }
  }

  fetchWeatherForecast(double latitude, double longitude) async {
    lastRequestTime = DateTime.now().millisecondsSinceEpoch;
    _logger.log(Level.FINE, "Fetch weather forecast");
    WeatherForecastListResponse weatherForecastResponse =
        await weatherRemoteRepository.fetchWeatherForecast(latitude, longitude);
    if (weatherForecastResponse.errorCode == null) {
      weatherLocalRepository.saveWeatherForecast(weatherForecastResponse);
    } else {
      WeatherForecastListResponse weatherForecastResponseStorage =
          await weatherLocalRepository.getWeatherForecast();
      if (weatherForecastResponseStorage != null) {
        weatherForecastResponse = weatherForecastResponseStorage;
        _logger.info("Using weather forecast data from storage");
      }
    }

    weatherForecastSubject.sink.add(weatherForecastResponse);
  }

  bool shouldFetchWeatherForecast() {
    return DateTime.now().millisecondsSinceEpoch - lastRequestTime > 60000;
  }
}

final bloc = WeatherForecastBloc();
