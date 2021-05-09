import 'package:feather/src/models/internal/unit.dart';
import 'package:feather/src/resources/repository/local/application_local_repository.dart';
import 'package:feather/src/ui/app/app_event.dart';
import 'package:feather/src/ui/app/app_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final ApplicationLocalRepository _applicationLocalRepository;

  AppBloc(this._applicationLocalRepository)
      : super(const AppState(Unit.metric));

  @override
  Stream<AppState> mapEventToState(AppEvent event) async* {
    if (event is LoadSettingsAppEvent) {
      yield await _loadSettings();
    }
  }

  Future<AppState> _loadSettings() async {
    return AppState(await _applicationLocalRepository.getSavedUnit());
  }

  bool isMetricUnits() {
    return state.unit == Unit.metric;
  }
}