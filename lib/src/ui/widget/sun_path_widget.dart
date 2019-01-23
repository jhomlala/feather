import 'dart:math';

import 'package:feather/src/models/remote/system.dart';
import 'package:feather/src/resources/weather_helper.dart';
import 'package:feather/src/ui/widget/widget_helper.dart';
import 'package:feather/src/utils/date_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SunPathWidget extends StatefulWidget {
  final System system;

  const SunPathWidget({Key key, this.system}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SunPathWidgetState();
}

class _SunPathWidgetState extends State<SunPathWidget>
    with SingleTickerProviderStateMixin {
  double _fraction = 0.0;
  Animation<double> _animation;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WidgetHelper.animate(
        tickerProvider: this,
        start: 0,
        end: 1,
        curve: Curves.easeInOut,
        duration: 2000,
        callback: () => setState(() {
              _fraction = _controller.value;
            }));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        key: Key("sun_path_widget_sized_box"),
        width: 300,
        height: 150,
        child: CustomPaint(
          key: Key("sun_path_widget_custom_paint"),
          painter: _SunPathPainter(widget.system, _fraction),
        ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _SunPathPainter extends CustomPainter {
  final System system;
  final double fraction;
  final double pi = 3.14159;
  final int dayAsMs = 86400000;
  final int sunrise;
  final int sunset;

  _SunPathPainter(this.system, this.fraction)
      : sunrise = system.sunrise * 1000,
        sunset = system.sunset * 1000;

  @override
  void paint(Canvas canvas, Size size) {
    Paint arcPaint = _getArcPaint();
    Rect rect = Rect.fromLTWH(0, 5, size.width, size.height * 2);
    canvas.drawArc(rect, 0, -pi, false, arcPaint);
    Paint circlePaint = _getCirclePaint();
    canvas.drawCircle(_getPosition(fraction), 10, circlePaint);
  }

  @override
  bool shouldRepaint(_SunPathPainter oldDelegate) {
    return oldDelegate.fraction != fraction;
  }

  Paint _getArcPaint() {
    Paint paint = Paint();
    paint..color = Colors.white;
    paint..strokeWidth = 2;
    paint..style = PaintingStyle.stroke;
    return paint;
  }

  Paint _getCirclePaint() {
    Paint circlePaint = Paint();
    int mode = WeatherHelper.getDayMode(system);
    if (mode == 0) {
      circlePaint..color = Colors.yellow;
    } else {
      circlePaint..color = Colors.white;
    }
    return circlePaint;
  }

  Offset _getPosition(fraction) {
    int now = DateHelper.getCurrentTime();
    int mode = WeatherHelper.getDayMode(system);
    double difference = 0;
    if (mode == 0) {
      difference = (now - sunrise) / (sunset - sunrise);
    } else if (mode == 1) {
      DateTime nextSunrise =
          DateTime.fromMillisecondsSinceEpoch(sunrise + dayAsMs);
      difference =
          (now - sunset) / (nextSunrise.millisecondsSinceEpoch - sunset);
    } else if (mode == -1) {
      DateTime previousSunset =
          DateTime.fromMillisecondsSinceEpoch(sunset - dayAsMs);
      difference = 1 -
          ((sunrise - now) / (sunrise - previousSunset.millisecondsSinceEpoch));
    }

    var x = 150 * cos((1 + difference * fraction) * pi) + 150;
    var y = 145 * sin((1 + difference * fraction) * pi) + 150;
    return Offset(x, y);
  }
}
