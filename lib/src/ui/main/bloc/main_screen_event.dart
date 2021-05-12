import 'package:equatable/equatable.dart';

abstract class MainScreenEvent extends Equatable {
  const MainScreenEvent();

  @override
  List<Object?> get props => [];
}

class LocationCheckMainScreenEvent extends MainScreenEvent {}

class LoadWeatherDataMainScreenEvent extends MainScreenEvent {}
