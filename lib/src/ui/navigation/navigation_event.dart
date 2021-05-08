import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class NavigationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class MainScreenNavigationEvent extends NavigationEvent {}

class ForecastScreenNavigationEvent extends NavigationEvent {}

class AboutScreenNavigationEvent extends NavigationEvent {
  final List<Color> startGradientColors;

  AboutScreenNavigationEvent(this.startGradientColors);
}

class SettingsScreenNavigationEvent extends NavigationEvent {
  final List<Color> startGradientColors;

  SettingsScreenNavigationEvent(this.startGradientColors);
}
