import 'package:equatable/equatable.dart';

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

class SuccessMainScreenState extends MainScreenState {}
