import 'package:feather/src/blocs/base_bloc.dart';
import 'package:feather/src/models/internal/unit.dart';
import 'package:feather/src/resources/repository/local/application_local_repository.dart';

class ApplicationBloc extends BaseBloc {
  bool currentWeatherWidgetAnimationState = true;
  final _applicationLocalRepository = ApplicationLocalRepository();
  var unit =  Unit.metric;

  @override
  void dispose() {
  }

  @override
  void handleTimerTimeout() {}

  @override
  void setupTimer() {}


  void loadSavedUnit() async {
    unit = await _applicationLocalRepository.getSavedUnit();
    print("Loaded unit: "+ unit.toString());
  }

  void saveUnit(Unit unit) async {
    print("Saved unit: " + unit.toString());
    _applicationLocalRepository.saveUnit(unit);
    this.unit = unit;
  }

  bool isMetricUnits(){
    return unit == Unit.metric;
  }
}

final applicationBloc = ApplicationBloc();
