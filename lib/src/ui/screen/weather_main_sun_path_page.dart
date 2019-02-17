import 'dart:async';

import 'package:feather/src/models/remote/system.dart';
import 'package:feather/src/resources/application_localization.dart';
import 'package:feather/src/resources/weather_helper.dart';
import 'package:feather/src/ui/widget/animated_text_widget.dart';
import 'package:feather/src/ui/widget/sun_path_widget.dart';
import 'package:feather/src/ui/widget/widget_helper.dart';
import 'package:feather/src/utils/date_time_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WeatherMainSunPathPage extends StatefulWidget {
final System system;

  WeatherMainSunPathPage({Key key, this.system}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WeatherMainSunPathPageState(system);
}

class _WeatherMainSunPathPageState extends State<WeatherMainSunPathPage> {
  final int dayAsMs = DateTimeHelper.dayAsMs;
  Timer _timer;
  int _sunrise;
  int _sunset;
  _WeatherMainSunPathPageState(System system){
    _sunrise = system.sunrise * 1000;
    _sunset = system.sunset * 1000;

    var nowDateTime = DateTime.now();
    var sunriseDateTime = DateTime.fromMillisecondsSinceEpoch(_sunrise);
    if (sunriseDateTime.day != nowDateTime.day &&
        sunriseDateTime.month != nowDateTime.month) {
      var difference = nowDateTime.day - sunriseDateTime.day;
      sunriseDateTime = DateTime.fromMillisecondsSinceEpoch(
          _sunrise + difference * DateTimeHelper.dayAsMs);
      _sunrise = sunriseDateTime.millisecondsSinceEpoch;

      _sunset = DateTime.fromMillisecondsSinceEpoch(
          _sunset + difference * DateTimeHelper.dayAsMs)
          .millisecondsSinceEpoch;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: Column(children: _buildScreen(context)));
  }

  @override
  initState() {
    super.initState();
    _startTimer();
  }

  List<Widget> _buildScreen(BuildContext context) {
    List<Widget> widgets = new List();
    widgets.add(WidgetHelper.buildPadding(top: 30));
    widgets.add(SunPathWidget(
      sunrise: _sunrise,
      sunset: _sunset,
      key: Key("weather_main_sun_path_widget"),
    ));
    widgets.add(WidgetHelper.buildPadding(top: 30));
    int mode = WeatherHelper.getDayModeFromSunriseSunset(_sunrise, _sunset);
    if (mode == 0) {
      widgets.add(AnimatedTextWidget(
          textBefore: ApplicationLocalization.of(context).getText("day") + ':',
          maxValue: _getPathPercentage(),
          key: Key("weather_main_sun_path_percentage")));
      widgets.add(WidgetHelper.buildPadding(top: 10));
      widgets.add(Text(
          "${ApplicationLocalization.of(context).getText("sunset_in")}: ${_getTimeUntilSunset()}",
          key: Key("weather_main_sun_path_countdown"),
          textDirection: TextDirection.ltr,
          style: Theme.of(context).textTheme.subtitle));
    } else {
      widgets.add(AnimatedTextWidget(
          textBefore:
              ApplicationLocalization.of(context).getText("night") + ':',
          maxValue: _getPathPercentage(),
          key: Key("weather_main_sun_path_percentage")));
      widgets.add(WidgetHelper.buildPadding(top: 10));
      widgets.add(Text(
          "${ApplicationLocalization.of(context).getText("sunrise_in")}: ${_getTimeUntilSunrise()}",
          key: Key("weather_main_sun_path_countdown"),
          textDirection: TextDirection.ltr,
          style: Theme.of(context).textTheme.subtitle));
    }

    widgets.add(WidgetHelper.buildPadding(top: 30));
    widgets.add(Text(
        "${ApplicationLocalization.of(context).getText("sunrise")}: ${_getSunriseTime()}",
        key: Key("weather_main_sun_path_sunrise"),
        textDirection: TextDirection.ltr,
        style: Theme.of(context).textTheme.body1));
    widgets.add(Text(
        "${ApplicationLocalization.of(context).getText("sunset")}: ${_getSunsetTime()}",
        key: Key("weather_main_sun_path_sunset"),
        textDirection: TextDirection.ltr,
        style: Theme.of(context).textTheme.body1));

    return widgets;
  }

  _startTimer() {
    _timer = Timer(Duration(seconds: 1), _handleTimeout);
  }

  void _handleTimeout() {
    _timer = null;
    _startTimer();
    setState(() => {});
  }

  @override
  dispose() {
    super.dispose();
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
  }

  String _getSunsetTime() {
    return DateTimeHelper.getTimeFormatted(
        DateTime.fromMillisecondsSinceEpoch(_sunset));
  }

  String _getSunriseTime() {
    return DateTimeHelper.getTimeFormatted(
        DateTime.fromMillisecondsSinceEpoch(_sunrise));
  }

  double _getPathPercentage() {
    int now = DateTimeHelper.getCurrentTime();
    int mode = WeatherHelper.getDayModeFromSunriseSunset(_sunrise, _sunset);

    if (mode == 0) {
      return ((now - _sunrise) / (_sunset - _sunrise) * 100);
    } else if (mode == 1) {
      DateTime nextSunrise =
          DateTime.fromMillisecondsSinceEpoch(_sunrise + dayAsMs);
      return (now - _sunset) /
          (nextSunrise.millisecondsSinceEpoch - _sunset) *
          100;
    } else {
      DateTime previousSunset =
          DateTime.fromMillisecondsSinceEpoch(_sunset - dayAsMs);
      return (1 -
              ((_sunrise - now) /
                  (_sunrise - previousSunset.millisecondsSinceEpoch))) *
          100;
    }
  }

  String _getTimeUntilSunrise() {
    int timeLeft = 0;
    if (WeatherHelper.getDayModeFromSunriseSunset(_sunrise, _sunset) == 1) {
      DateTime nextSunrise =
          DateTime.fromMillisecondsSinceEpoch(_sunrise + dayAsMs);
      timeLeft =
          nextSunrise.millisecondsSinceEpoch - DateTimeHelper.getCurrentTime();
    } else {
      timeLeft = _sunrise - DateTimeHelper.getCurrentTime();
    }

    return DateTimeHelper.formatTime(timeLeft);
  }

  String _getTimeUntilSunset() {
    int timeLeft = _sunset - DateTimeHelper.getCurrentTime();
    return DateTimeHelper.formatTime(timeLeft);
  }
}
