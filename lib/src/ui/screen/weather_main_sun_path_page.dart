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
  final int sunset;
  final int sunrise;
  Timer _timer;

  _WeatherMainSunPathPageState(System system)
      : sunset = system.sunset * 1000,
        sunrise = system.sunrise * 1000;

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
      system: widget.system,
      key: Key("weather_main_sun_path_widget"),
    ));
    widgets.add(WidgetHelper.buildPadding(top: 30));
    int mode = WeatherHelper.getDayMode(widget.system);
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
        DateTime.fromMillisecondsSinceEpoch(sunset));
  }

  String _getSunriseTime() {
    return DateTimeHelper.getTimeFormatted(
        DateTime.fromMillisecondsSinceEpoch(sunrise));
  }

  double _getPathPercentage() {
    int now = DateTimeHelper.getCurrentTime();
    int mode = WeatherHelper.getDayMode(widget.system);
    if (mode == 0) {
      return ((now - sunrise) / (sunset - sunrise) * 100);
    } else if (mode == 1) {
      DateTime nextSunrise =
          DateTime.fromMillisecondsSinceEpoch(sunrise + dayAsMs);
      return (now - sunset) /
          (nextSunrise.millisecondsSinceEpoch - sunset) *
          100;
    } else {
      DateTime previousSunset =
          DateTime.fromMillisecondsSinceEpoch(sunset - dayAsMs);
      return (1 -
              ((sunrise - now) /
                  (sunrise - previousSunset.millisecondsSinceEpoch))) *
          100;
    }
  }

  String _getTimeUntilSunrise() {
    int timeLeft = 0;
    if (WeatherHelper.getDayMode(widget.system) == 1) {
      DateTime nextSunrise =
          DateTime.fromMillisecondsSinceEpoch(sunrise + dayAsMs);
      timeLeft =
          nextSunrise.millisecondsSinceEpoch - DateTimeHelper.getCurrentTime();
    } else {
      timeLeft = sunrise - DateTimeHelper.getCurrentTime();
    }

    return DateTimeHelper.formatTime(timeLeft);
  }

  String _getTimeUntilSunset() {
    int timeLeft = sunset - DateTimeHelper.getCurrentTime();
    return DateTimeHelper.formatTime(timeLeft);
  }
}
