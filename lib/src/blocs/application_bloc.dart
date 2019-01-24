import 'package:feather/src/blocs/base_bloc.dart';

class ApplicationBloc extends BaseBloc {
  bool currentWeatherWidgetAnimationState = true;

  @override
  void dispose() {}

  @override
  void handleTimerTimeout() {}

  @override
  void setupTimer() {}
}

final applicationBloc = ApplicationBloc();
