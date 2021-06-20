import 'package:equatable/equatable.dart';
import 'package:feather/src/data/model/internal/unit.dart';

abstract class SettingsScreenState extends Equatable {
  const SettingsScreenState();

  @override
  List<Object> get props => [];
}

class InitialSettingsScreenState extends SettingsScreenState {}

class LoadingSettingsScreenState extends SettingsScreenState {}

class LoadedSettingsScreenState extends SettingsScreenState {
  final Unit unit;
  final int refreshTime;
  final int lastRefreshTime;

  const LoadedSettingsScreenState(
      this.unit, this.refreshTime, this.lastRefreshTime);

  @override
  List<Object> get props => [unit, refreshTime, lastRefreshTime];

  LoadedSettingsScreenState copyWith(
      {Unit? unit, int? refreshTime, int? lastRefreshTime}) {
    return LoadedSettingsScreenState(
      unit ?? this.unit,
      refreshTime ?? this.refreshTime,
      lastRefreshTime ?? this.lastRefreshTime,
    );
  }
}
