import 'dart:async';

import 'package:feather/src/models/remote/system.dart';
import 'package:feather/src/resources/config/strings.dart';
import 'package:feather/src/resources/weather_helper.dart';
import 'package:feather/src/ui/widget/animated_text_widget.dart';
import 'package:feather/src/ui/widget/sun_path_widget.dart';
import 'package:feather/src/ui/widget/widget_helper.dart';
import 'package:feather/src/utils/date_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WeatherMainSunPathPage extends StatefulWidget {
  final System system;

  WeatherMainSunPathPage({Key key, this.system}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WeatherMainSunPathPageState(system);
}

class _WeatherMainSunPathPageState extends State<WeatherMainSunPathPage> {
  final int dayAsMs = 86400000;
  final int hoursAsMs = 3600000;
  final int minutesAsMs = 60000;
  final int secondsAsMs = 1000;
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
          textBefore: Strings.day + ':',
          maxValue: _getPathPercentage(),
          key: Key("weather_main_sun_path_percentage")));
      widgets.add(WidgetHelper.buildPadding(top: 10));
      widgets.add(Text("${Strings.sunset}: ${_getTimeUntilSunset()}",
          key: Key("weather_main_sun_path_countdown"),
          textDirection: TextDirection.ltr,
          style: Theme.of(context).textTheme.subtitle));
    } else {
      widgets.add(AnimatedTextWidget(
          textBefore: Strings.night + ':',
          maxValue: _getPathPercentage(),
          key: Key("weather_main_sun_path_percentage")));
      widgets.add(WidgetHelper.buildPadding(top: 10));
      widgets.add(Text("${Strings.sunrise}: ${_getTimeUntilSunrise()}",
          key: Key("weather_main_sun_path_countdown"),
          textDirection: TextDirection.ltr,
          style: Theme.of(context).textTheme.subtitle));
    }

    widgets.add(WidgetHelper.buildPadding(top: 30));
    widgets.add(Text("${Strings.sunrise}: ${_getSunriseTime()}",
        key: Key("weather_main_sun_path_sunrise"),
        textDirection: TextDirection.ltr,
        style: Theme.of(context).textTheme.body1));
    widgets.add(Text("${Strings.sunset}: ${_getSunsetTime()}",
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
    _timer.cancel();
    _timer = null;
  }

  String _getSunsetTime() {
    return _getTimeFormatted(DateTime.fromMillisecondsSinceEpoch(sunset));
  }

  String _getSunriseTime() {
    return _getTimeFormatted(DateTime.fromMillisecondsSinceEpoch(sunrise));
  }

  String _getTimeFormatted(DateTime dateTime) {
    return "${dateTime.hour}:${dateTime.minute}";
  }

  double _getPathPercentage() {
    int now = DateHelper.getCurrentTime();
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
          nextSunrise.millisecondsSinceEpoch - DateHelper.getCurrentTime();
    } else {
      timeLeft = sunrise - DateHelper.getCurrentTime();
    }

    return _formatTime(timeLeft);
  }

  String _formatTime(int time) {
    int hours = (time / (hoursAsMs)).floor();
    int minutes = ((time - hours * hoursAsMs) / minutesAsMs).floor();
    int seconds =
        ((time - hours * hoursAsMs - minutes * minutesAsMs) / secondsAsMs)
            .floor();
    String text = "";
    if (hours > 0) {
      text += hours.toString() + "h ";
    }
    if (minutes > 0) {
      text += minutes.toString() + "m ";
    }
    if (seconds >= 0) {
      text += seconds.toString() + "s";
    }
    return text;
  }

  String _getTimeUntilSunset() {
    int timeLeft = sunset - DateHelper.getCurrentTime();
    return _formatTime(timeLeft);
  }
}
