import 'package:feather/src/models/internal/geo_position.dart';
import 'package:feather/src/models/remote/weather_response.dart';
import 'package:feather/src/resources/location_manager.dart';
import 'package:feather/src/resources/repository/local/weather_local_repository.dart';
import 'package:feather/src/resources/repository/remote/weather_remote_repository.dart';
import 'package:feather/src/ui/main/main_screen_event.dart';
import 'package:feather/src/utils/app_logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import 'main_screen_state.dart';

class MainScreenBloc extends Bloc<MainScreenEvent, MainScreenState> {
  final LocationManager _locationManager;
  final WeatherLocalRepository _weatherLocalRepository;
  final WeatherRemoteRepository _weatherRemoteRepository;

  MainScreenBloc(
    this._locationManager,
    this._weatherLocalRepository,
    this._weatherRemoteRepository,
  ) : super(InitialMainScreenState());

  @override
  Stream<MainScreenState> mapEventToState(MainScreenEvent event) async* {
    if (event is LocationCheckMainScreenEvent) {
      yield CheckingLocationState();
      if (!await _checkLocationServiceEnabled()) {
        yield LocationServiceDisabledMainScreenState();
      } else if (!await _checkPermission()) {
        yield PermissionNotGrantedMainScreenState();
      } else {
        yield* _selectWeatherData();
      }
    }
    if (event is LoadWeatherDataMainScreenEvent) {
      yield* _selectWeatherData();
    }
  }

  Stream<MainScreenState> _selectWeatherData() async* {
    yield LoadingMainScreenState();

    GeoPosition? position = await _getPosition();
    Log.i("Got geo position: " + position.toString());
    if (position != null) {
      WeatherResponse? response =
          await _fetchWeather(position.lat, position.long);
      if (response != null) {
        yield SuccessLoadMainScreenState(response);
      } else {
        yield FailedLoadMainScreenState("Not received data");
      }
    } else {
      yield FailedLoadMainScreenState("Couldn't select location");
    }
  }

  Future<bool> _checkLocationServiceEnabled() async {
    return Geolocator.isLocationServiceEnabled();
  }

  Future<bool> _checkPermission() async {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      return permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse;
    } else if (permission == LocationPermission.deniedForever) {
      return false;
    } else {
      return true;
    }
  }

  Future<GeoPosition?> _getPosition() async {
    try {
      var positionOptional = await _locationManager.getLocation();
      if (positionOptional.isPresent) {
        Log.i("Position is present!");
        var position = positionOptional.value!;
        GeoPosition geoPosition = GeoPosition.fromPosition(position);
        _weatherLocalRepository.saveLocation(geoPosition);
        return geoPosition;
      } else {
        Log.i("Position is not present!");
        return _weatherLocalRepository.getLocation();
      }
    } catch (error, stackTrace) {
      Log.e("getPosition failed", error: error, stackTrace: stackTrace);
      return null;
    }
  }

  Future<WeatherResponse?> _fetchWeather(
      double? latitude, double? longitude) async {
    Log.i("Fetch weather");
    //lastRequestTime = DateTimeHelper.getCurrentTime();
    WeatherResponse weatherResponse =
        await _weatherRemoteRepository.fetchWeather(latitude, longitude);
    if (weatherResponse.errorCode == null) {
      _weatherLocalRepository.saveWeather(weatherResponse);
      return weatherResponse;
    } else {
      Log.i("Selected weather from storage");
      WeatherResponse? weatherResponseStorage =
          await _weatherLocalRepository.getWeather();
      if (weatherResponseStorage != null) {
        return weatherResponseStorage;
      } else {
        return null;
      }
    }

    //applicationBloc.saveLastRefreshTime(DateTimeHelper.getCurrentTime());
    //weatherSubject.sink.add(weatherResponse);
  }
}
