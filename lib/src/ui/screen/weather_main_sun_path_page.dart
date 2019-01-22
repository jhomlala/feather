import 'dart:async';

import 'package:feather/src/models/remote/system.dart';
import 'package:feather/src/ui/widget/sun_path_widget.dart';
import 'package:feather/src/ui/widget/widget_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WeatherMainSunPathPage extends StatefulWidget {
  final System system;

  WeatherMainSunPathPage({Key key, this.system}) : super(key: key);

  @override
  State<StatefulWidget> createState() => WeatherMainSunPathPageState();
}

class WeatherMainSunPathPageState extends State<WeatherMainSunPathPage> {
  Timer _timer;

  @override
  Widget build(BuildContext context) {
    return Center(child: Column(children: _buildScreen(context)));
  }

  @override
  initState() {
    super.initState();
    startTimer();
  }

  List<Widget> _buildScreen(BuildContext context) {
    List<Widget> widgets = new List();
    widgets.add(WidgetHelper.buildPadding(top: 30));
    widgets.add(SunPathWidget(
      system: widget.system,
    ));
    widgets.add(WidgetHelper.buildPadding(top: 30));
    int mode = _getMode();
    if (mode == 0) {
      widgets.add(Text(
        "Day: ${_getPathPercentage().toStringAsFixed(0)}%",
        textDirection: TextDirection.ltr,
        style: Theme.of(context).textTheme.title,
      ));
      widgets.add(WidgetHelper.buildPadding(top: 10));
      widgets.add(Text("Sunset: ${getTimeUntilSunset()}",
          textDirection: TextDirection.ltr,
          style: Theme.of(context).textTheme.subtitle));
    } else if (mode == 1) {
      widgets.add(Text("Moon: ${_getPathPercentage().toStringAsFixed(0)}%",
          textDirection: TextDirection.ltr,
          style: Theme.of(context).textTheme.title));
      widgets.add(WidgetHelper.buildPadding(top: 10));
      widgets.add(Text("Sunrise: ${getTimeUntilSunset()}",
          textDirection: TextDirection.ltr,
          style: Theme.of(context).textTheme.subtitle));
    }
    widgets.add(WidgetHelper.buildPadding(top: 30));
    widgets.add(Text("Sunrise: ${_getSunriseTime()}",
        textDirection: TextDirection.ltr,
        style: Theme.of(context).textTheme.body1));
    widgets.add(Text("Sunset: ${_getSunsetTime()}",
        textDirection: TextDirection.ltr,
        style: Theme.of(context).textTheme.body1));

    return widgets;
  }

  startTimer() {
    _timer = Timer(Duration(seconds: 1), handleTimeout);
  }

  void handleTimeout() {
    print("Handle timeout");
    _timer = null;
    startTimer();
    setState(() => {});
  }

  @override
  dispose() {
    super.dispose();
    print("Dispose");
    _timer.cancel();
    _timer = null;
  }

  String _getSunsetTime() {
    return _getTimeFormatted(
        DateTime.fromMillisecondsSinceEpoch(widget.system.sunset * 1000));
  }

  String _getSunriseTime() {
    return _getTimeFormatted(
        DateTime.fromMillisecondsSinceEpoch(widget.system.sunrise * 1000));
  }

  String _getTimeFormatted(DateTime dateTime) {
    return "${dateTime.hour}:${dateTime.minute}";
  }

  double _getPathPercentage() {
    int sunrise = widget.system.sunrise * 1000;
    int sunset = widget.system.sunset * 1000;
    int now = _getCurrentTime();
    if (now >= sunrise && now <= sunset) {
      return ((now - sunrise) / (sunset - sunrise) * 100);
    } else if (now >= sunset) {
      DateTime nextSunrise =
          DateTime.fromMillisecondsSinceEpoch(sunrise + 24 * 60 * 60 * 1000);
      return (now - sunset) / (nextSunrise.millisecondsSinceEpoch - sunset);
    } else {
      return 0;
    }
  }

  int _getMode() {
    int sunrise = widget.system.sunrise * 1000;
    int sunset = widget.system.sunset * 1000;
    int now = _getCurrentTime();
    if (now >= sunrise && now <= sunset) {
      return 0;
    } else if (now >= sunrise) {
      return 1;
    } else {
      return -1;
    }
  }

  int _getCurrentTime() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  String getTimeUntilSunset() {
    int hourMs = 60 * 60 * 1000;
    int minuteMs = 60 * 1000;
    int secondMs = 1000;

    int timeLeft =
        widget.system.sunset * 1000 - DateTime.now().millisecondsSinceEpoch;
    print("time left: " + timeLeft.toString());
    int hours = (timeLeft / (hourMs)).floor();
    int minutes = ((timeLeft - hours * hourMs) / minuteMs).floor();
    int seconds =
        ((timeLeft - hours * hourMs - minutes * minuteMs) / secondMs).floor();

    return "$hours h $minutes m $seconds s";
  }
}
