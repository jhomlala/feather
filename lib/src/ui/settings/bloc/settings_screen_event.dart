import 'package:equatable/equatable.dart';
import 'package:feather/src/data/model/internal/unit.dart';

abstract class SettingsScreenEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadSettingsScreenEvent extends SettingsScreenEvent {}

class ChangeUnitsSettingsScreenEvent extends SettingsScreenEvent {
  final Unit unit;

  ChangeUnitsSettingsScreenEvent(this.unit);

  @override
  List<Object?> get props => [unit];
}

class ChangeRefreshTimeSettingsScreenEvent extends SettingsScreenEvent {
  final int refreshTime;

  ChangeRefreshTimeSettingsScreenEvent(this.refreshTime);

  @override
  List<Object?> get props => [refreshTime];
}
