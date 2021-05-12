import 'package:equatable/equatable.dart';
import 'package:feather/src/data/model/internal/application_error.dart';
import 'package:feather/src/data/model/internal/unit.dart';
import 'package:feather/src/data/model/remote/weather_forecast_list_response.dart';
import 'package:feather/src/data/model/remote/weather_response.dart';

abstract class MainScreenState extends Equatable {
  final Unit? unit;

  const MainScreenState({this.unit});

  @override
  List<Object?> get props => [unit];
}

class InitialMainScreenState extends MainScreenState {}

class CheckingLocationState extends MainScreenState {}

class LocationServiceDisabledMainScreenState extends MainScreenState {}

class PermissionNotGrantedMainScreenState extends MainScreenState {}

class LoadingMainScreenState extends MainScreenState {}

class SuccessLoadMainScreenState extends MainScreenState {
  final WeatherResponse weatherResponse;
  final WeatherForecastListResponse weatherForecastListResponse;

  const SuccessLoadMainScreenState(this.weatherResponse, this.weatherForecastListResponse);

  @override
  List<Object?> get props => [unit, weatherResponse];
}

class FailedLoadMainScreenState extends MainScreenState {
  final ApplicationError applicationError;

  const FailedLoadMainScreenState(this.applicationError);

  @override
  List<Object?> get props => [unit, applicationError];
}
