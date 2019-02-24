import 'package:feather/src/blocs/base_bloc.dart';
import 'package:feather/src/models/internal/unit.dart';
import 'package:feather/src/resources/repository/local/application_local_repository.dart';

class ApplicationBloc extends BaseBloc {
  bool currentWeatherWidgetAnimationState = true;
  final _applicationLocalRepository = ApplicationLocalRepository();
  Unit unit = Unit.metric;
  int refreshTime = 600000;
  int lastRefreshTime = 0;

  @override
  void dispose() {}

  @override
  void handleTimerTimeout() {}

  @override
  void setupTimer() {}

  void loadSavedUnit() async {
    unit = await _applicationLocalRepository.getSavedUnit();
  }

  void saveUnit(Unit unit) async {
    _applicationLocalRepository.saveUnit(unit);
    this.unit = unit;
  }

  bool isMetricUnits() {
    return unit == Unit.metric;
  }

  void saveRefreshTime(int refreshTime) async {
    this.refreshTime = refreshTime;
    _applicationLocalRepository.saveRefreshTime(refreshTime);
  }

  void loadSavedRefreshTime() async {
    refreshTime = await _applicationLocalRepository.getSavedRefreshTime();
  }

  void saveLastRefreshTime(int lastRefreshTime) {
    this.lastRefreshTime = lastRefreshTime;
    _applicationLocalRepository.saveLastRefreshTime(lastRefreshTime);
  }

  void loadLastRefreshTime() async {
    this.lastRefreshTime =
        await _applicationLocalRepository.getLastRefreshTime();
  }
}

final applicationBloc = ApplicationBloc();
