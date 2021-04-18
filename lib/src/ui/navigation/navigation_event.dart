import 'package:equatable/equatable.dart';

abstract class NavigationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class MainScreenNavigationEvent extends NavigationEvent {}

class ForecastScreenNavigationEvent extends NavigationEvent {}

class AboutScreenNavigationEvent extends NavigationEvent {}

class SettingsScreenNavigationEvent extends NavigationEvent {}
