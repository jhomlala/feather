import 'package:feather/src/data/repository/local/application_local_repository.dart';
import 'package:feather/src/ui/settings/bloc/settings_screen_event.dart';
import 'package:feather/src/ui/settings/bloc/settings_screen_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreenBloc
    extends Bloc<SettingsScreenEvent, SettingsScreenState> {
  final ApplicationLocalRepository _applicationLocalRepository;

  SettingsScreenBloc(this._applicationLocalRepository)
      : super(InitialSettingsScreenState());

  @override
  Stream<SettingsScreenState> mapEventToState(
      SettingsScreenEvent event) async* {
    if (event is LoadSettingsScreenEvent) {
      final unit = await _applicationLocalRepository.getSavedUnit();
      final savedRefreshTime =
          await _applicationLocalRepository.getSavedRefreshTime();
      final lastRefreshedTime =
          await _applicationLocalRepository.getLastRefreshTime();
      yield LoadedSettingsScreenState(
          unit, savedRefreshTime, lastRefreshedTime);
    }

    if (event is ChangeUnitsSettingsScreenEvent) {
      final unitsEvent = event;
      _applicationLocalRepository.saveUnit(unitsEvent.unit);
      if (state is LoadedSettingsScreenState) {
        final loadedState = state as LoadedSettingsScreenState;
        yield loadedState.copyWith(unit: unitsEvent.unit);
      }
    }

    if (event is ChangeRefreshTimeSettingsScreenEvent) {
      _applicationLocalRepository.saveRefreshTime(event.refreshTime);
      if (state is LoadedSettingsScreenState) {
        final loadedState = state as LoadedSettingsScreenState;
        yield loadedState.copyWith(refreshTime: event.refreshTime);
      }
    }
  }
}
