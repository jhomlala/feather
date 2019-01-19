import 'package:feather/src/blocs/base_bloc.dart';
import 'package:feather/src/models/internal/geo_position.dart';
import 'package:feather/src/models/remote/weather_forecast_list_response.dart';
import 'package:logging/logging.dart';
import 'package:rxdart/rxdart.dart';

class WeatherForecastBloc extends BaseBloc {
  final weatherForecastSubject = BehaviorSubject<WeatherForecastListResponse>();
  final Logger _logger = Logger("WeatherForecastBloc");
  Observable<WeatherForecastListResponse> get weatherForecastStream =>
      weatherForecastSubject.stream;


  fetchWeatherForecastForUserLocation() async {
    _logger.log(Level.FINE, "Fetch weather forecast for user location");

    GeoPosition geoPosition = await getPosition();
    if (geoPosition != null) {
      fetchWeatherForecast(geoPosition.lat, geoPosition.long);
    } else {
      _logger.log(Level.WARNING,
          "Fetch weather forecast for user location failed because location not selected");
      weatherForecastSubject.sink.add(WeatherForecastListResponse.withErrorCode(
          "ERROR_LOCATION_NOT_SELECTED"));
    }
  }

  fetchWeatherForecast(double latitude, double longitude) async {
    _logger.log(Level.FINE, "Fetch weather forecast");
    WeatherForecastListResponse weatherForecastResponse =
    await weatherRepository.fetchWeatherForecast(latitude, longitude);
    if (weatherForecastResponse.errorCode == null) {
      storageManager.saveWeatherForecast(weatherForecastResponse);
    } else {
      WeatherForecastListResponse weatherForecastResponseStorage =
      await storageManager.getWeatherForecast();
      if (weatherForecastResponseStorage != null) {
        weatherForecastResponse = weatherForecastResponseStorage;
        _logger.info("Using weather forecast data from storage");
      }
    }
    weatherForecastSubject.sink.add(weatherForecastResponse);
  }


  dispose(){
    _logger.log(Level.FINE, "Dispose");
    weatherForecastSubject.close();
  }
}

final bloc = WeatherForecastBloc();