import 'dart:async';

import 'package:feather/src/data/model/remote/system.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:feather/src/data/repository/local/weather_helper.dart';
import 'package:feather/src/ui/widget/animated_text_widget.dart';
import 'package:feather/src/ui/main/widget/sun_path_widget.dart';
import 'package:feather/src/utils/date_time_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WeatherMainSunPathWidget extends StatefulWidget {
  final System? system;

  const WeatherMainSunPathWidget({Key? key, this.system}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WeatherMainSunPathWidgetState();
}

class _WeatherMainSunPathWidgetState extends State<WeatherMainSunPathWidget> {
  final int dayAsMs = DateTimeHelper.dayAsMs;
  Timer? _timer;
  int? _sunrise;
  int? _sunset;

  @override
  void dispose() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: _buildScreen(context),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    final system = widget.system;
    if (system != null) {
      _sunrise = system.sunrise! * 1000;
      _sunset = system.sunset! * 1000;

      final nowDateTime = DateTime.now();
      var sunriseDateTime = DateTime.fromMillisecondsSinceEpoch(_sunrise!);
      if (sunriseDateTime.day != nowDateTime.day &&
          sunriseDateTime.month != nowDateTime.month) {
        final difference = nowDateTime.day - sunriseDateTime.day;
        sunriseDateTime = DateTime.fromMillisecondsSinceEpoch(
            _sunrise! + difference * DateTimeHelper.dayAsMs);
        _sunrise = sunriseDateTime.millisecondsSinceEpoch;

        _sunset = DateTime.fromMillisecondsSinceEpoch(
                _sunset! + difference * DateTimeHelper.dayAsMs)
            .millisecondsSinceEpoch;
      }
    }
    _startTimer();
  }

  List<Widget> _buildDayWidgets() {
    final applicationLocalization = AppLocalizations.of(context)!;
    return [
      AnimatedTextWidget(
          textBefore: '${applicationLocalization.day}:',
          maxValue: _getPathPercentage(),
          key: const Key("weather_main_sun_path_percentage")),
      const SizedBox(height: 10),
      Text("${applicationLocalization.sunset_in}: ${_getTimeUntilSunset()}",
          key: const Key("weather_main_sun_path_countdown"),
          textDirection: TextDirection.ltr,
          style: Theme.of(context).textTheme.subtitle2)
    ];
  }

  List<Widget> _buildNightWidgets() {
    final applicationLocalization = AppLocalizations.of(context)!;
    return [
      AnimatedTextWidget(
          textBefore: '${applicationLocalization.night}:',
          maxValue: _getPathPercentage(),
          key: const Key("weather_main_sun_path_percentage")),
      const SizedBox(height: 10),
      Text("${applicationLocalization.sunrise_in}: ${_getTimeUntilSunrise()}",
          key: const Key("weather_main_sun_path_countdown"),
          textDirection: TextDirection.ltr,
          style: Theme.of(context).textTheme.subtitle2),
    ];
  }

  List<Widget> _buildScreen(BuildContext context) {
    final applicationLocalizations = AppLocalizations.of(context)!;
    final List<Widget> widgets = [];
    widgets.add(const SizedBox(height: 30));
    widgets.add(SunPathWidget(
      sunrise: _sunrise,
      sunset: _sunset,
      key: const Key("weather_main_sun_path_widget"),
    ));
    widgets.add(const SizedBox(height: 30));
    final int mode =
        WeatherHelper.getDayModeFromSunriseSunset(_sunrise!, _sunset);
    if (mode == 0) {
      widgets.addAll(_buildDayWidgets());
    } else {
      widgets.addAll(_buildNightWidgets());
    }

    widgets.add(const SizedBox(height: 30));
    widgets.add(
      Text("${applicationLocalizations.sunrise}: ${_getSunriseTime()}",
          key: const Key("weather_main_sun_path_sunrise"),
          textDirection: TextDirection.ltr,
          style: Theme.of(context).textTheme.bodyText2),
    );
    widgets.add(
      Text("${applicationLocalizations.sunset}: ${_getSunsetTime()}",
          key: const Key("weather_main_sun_path_sunset"),
          textDirection: TextDirection.ltr,
          style: Theme.of(context).textTheme.bodyText2),
    );

    return widgets;
  }

  void _startTimer() {
    _timer = Timer(const Duration(seconds: 1), _handleTimeout);
  }

  void _handleTimeout() {
    _timer = null;
    _startTimer();
    setState(() {});
  }

  String _getSunsetTime() {
    return DateTimeHelper.getTimeFormatted(
        DateTime.fromMillisecondsSinceEpoch(_sunset!));
  }

  String _getSunriseTime() {
    return DateTimeHelper.getTimeFormatted(
        DateTime.fromMillisecondsSinceEpoch(_sunrise!));
  }

  double _getPathPercentage() {
    final int now = DateTimeHelper.getCurrentTime();
    final int mode =
        WeatherHelper.getDayModeFromSunriseSunset(_sunrise!, _sunset);

    if (mode == 0) {
      return (now - _sunrise!) / (_sunset! - _sunrise!) * 100;
    } else if (mode == 1) {
      final DateTime nextSunrise =
          DateTime.fromMillisecondsSinceEpoch(_sunrise! + dayAsMs);
      return (now - _sunset!) /
          (nextSunrise.millisecondsSinceEpoch - _sunset!) *
          100;
    } else {
      final DateTime previousSunset =
          DateTime.fromMillisecondsSinceEpoch(_sunset! - dayAsMs);
      return (1 -
              ((_sunrise! - now) /
                  (_sunrise! - previousSunset.millisecondsSinceEpoch))) *
          100;
    }
  }

  String _getTimeUntilSunrise() {
    int timeLeft = 0;
    if (WeatherHelper.getDayModeFromSunriseSunset(_sunrise!, _sunset) == 1) {
      final DateTime nextSunrise =
          DateTime.fromMillisecondsSinceEpoch(_sunrise! + dayAsMs);
      timeLeft =
          nextSunrise.millisecondsSinceEpoch - DateTimeHelper.getCurrentTime();
    } else {
      timeLeft = _sunrise! - DateTimeHelper.getCurrentTime();
    }

    return DateTimeHelper.formatTime(timeLeft);
  }

  String _getTimeUntilSunset() {
    final int timeLeft = _sunset! - DateTimeHelper.getCurrentTime();
    return DateTimeHelper.formatTime(timeLeft);
  }
}
