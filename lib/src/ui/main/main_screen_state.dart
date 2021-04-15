import 'package:equatable/equatable.dart';
import 'package:feather/src/models/remote/weather_response.dart';

abstract class MainScreenState extends Equatable {
  const MainScreenState();

  @override
  List<Object> get props => [];
}

class InitialMainScreenState extends MainScreenState {}

class CheckingLocationState extends MainScreenState {}

class LocationServiceDisabledMainScreenState extends MainScreenState {}

class PermissionNotGrantedMainScreenState extends MainScreenState {}

class LoadingMainScreenState extends MainScreenState {}

class SuccessLoadMainScreenState extends MainScreenState {
  final WeatherResponse weatherResponse;

  SuccessLoadMainScreenState(this.weatherResponse);

  @override
  List<Object> get props => [weatherResponse];
}

class FailedLoadMainScreenState extends MainScreenState {
  final String errorMessage;

  FailedLoadMainScreenState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
