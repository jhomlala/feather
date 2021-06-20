import 'dart:math';

import 'package:feather/src/data/repository/local/weather_helper.dart';
import 'package:feather/src/ui/widget/animated_state.dart';
import 'package:feather/src/utils/date_time_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SunPathWidget extends StatefulWidget {
  final int? sunrise;
  final int? sunset;

  const SunPathWidget({Key? key, this.sunrise, this.sunset}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SunPathWidgetState();
}

class _SunPathWidgetState extends AnimatedState<SunPathWidget> {
  double _fraction = 0.0;

  @override
  void initState() {
    super.initState();
    animateTween(duration: 2000);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: const Key("sun_path_widget_sized_box"),
      width: 300,
      height: 150,
      child: CustomPaint(
        key: const Key("sun_path_widget_custom_paint"),
        painter: _SunPathPainter(widget.sunrise, widget.sunset, _fraction),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void onAnimatedValue(double value) {
    setState(() {
      _fraction = value;
    });
  }
}

class _SunPathPainter extends CustomPainter {
  final double fraction;
  final double pi = 3.14159;
  final int dayAsMs = 86400000;
  final int? sunrise;
  final int? sunset;

  _SunPathPainter(this.sunrise, this.sunset, this.fraction);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint arcPaint = _getArcPaint();
    final Rect rect = Rect.fromLTWH(0, 5, size.width, size.height * 2);
    canvas.drawArc(rect, 0, -pi, false, arcPaint);
    final Paint circlePaint = _getCirclePaint();
    canvas.drawCircle(_getPosition(fraction), 10, circlePaint);
  }

  @override
  bool shouldRepaint(_SunPathPainter oldDelegate) {
    return oldDelegate.fraction != fraction;
  }

  Paint _getArcPaint() {
    final Paint paint = Paint();
    paint.color = Colors.white;
    paint.strokeWidth = 2;
    paint.style = PaintingStyle.stroke;
    return paint;
  }

  Paint _getCirclePaint() {
    final Paint circlePaint = Paint();
    final int mode =
        WeatherHelper.getDayModeFromSunriseSunset(sunrise!, sunset);
    if (mode == 0) {
      circlePaint.color = Colors.yellow;
    } else {
      circlePaint.color = Colors.white;
    }
    return circlePaint;
  }

  Offset _getPosition(double fraction) {
    final int now = DateTimeHelper.getCurrentTime();
    final int mode =
        WeatherHelper.getDayModeFromSunriseSunset(sunrise!, sunset);
    double difference = 0;
    if (mode == 0) {
      difference = (now - sunrise!) / (sunset! - sunrise!);
    } else if (mode == 1) {
      final DateTime nextSunrise =
          DateTime.fromMillisecondsSinceEpoch(sunrise! + dayAsMs);
      difference =
          (now - sunset!) / (nextSunrise.millisecondsSinceEpoch - sunset!);
    } else if (mode == -1) {
      final DateTime previousSunset =
          DateTime.fromMillisecondsSinceEpoch(sunset! - dayAsMs);
      difference = 1 -
          ((sunrise! - now) /
              (sunrise! - previousSunset.millisecondsSinceEpoch));
    }

    final x = 150 * cos((1 + difference * fraction) * pi) + 150;
    final y = 145 * sin((1 + difference * fraction) * pi) + 150;
    return Offset(x, y);
  }
}
