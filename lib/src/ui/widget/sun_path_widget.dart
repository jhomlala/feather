import 'dart:math';

import 'package:feather/src/models/remote/system.dart';
import 'package:feather/src/resources/weather_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SunPathWidget extends StatefulWidget {
  final System system;

  const SunPathWidget({Key key, this.system}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SunPathWidgetState();
}

class _SunPathWidgetState extends State<SunPathWidget>  with SingleTickerProviderStateMixin {
  double _fraction = 0.0;
  Animation<double> animation;
  AnimationController controller;
  
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);
    final Animation curve =
    CurvedAnimation(parent: controller, curve: Curves.decelerate);
    animation = Tween(begin: 0.0, end: 1.0).animate(curve)
      ..addListener(() {
        setState(() {
          _fraction = animation.value;
        });
      });

    controller.forward();
  }
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(width: 300, height: 150, child:
        CustomPaint(
        painter: _SunPathPainter(widget.system,_fraction),)
    );
  }
}

class _SunPathPainter extends CustomPainter {
  final System system;
  final double fraction;

  _SunPathPainter(this.system, this.fraction);
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint..color = Colors.white;
    paint..strokeWidth = 2;
    paint..style = PaintingStyle.stroke;
    var pi = 3.14;
    var rect = Rect.fromLTWH(0, 5, size.width, size.height*2);
    canvas.drawArc(rect, 0, -pi, false, paint);

    Paint circlePaint = Paint();
    int mode = WeatherHelper.getDayMode(system);
    if (mode == 0) {
      circlePaint..color = Colors.yellow;
    } else if (mode == 1){
      circlePaint..color = Colors.white;
    }

    canvas.drawCircle(_getPosition(fraction), 10, circlePaint);
  }

  @override
  bool shouldRepaint(_SunPathPainter oldDelegate) {
    return oldDelegate.fraction != fraction;
  }

  Offset _getPosition(fraction){
    int sunrise = system.sunrise * 1000;
    int sunset = system.sunset * 1000;
    int now = _getCurrentTime();
    int mode = WeatherHelper.getDayMode(system);
    double difference = 0;

    if (mode == 0){
      difference = (now  - sunrise) / (sunset - sunrise);
    } else if (mode == 1) {
      DateTime nextSunrise =
      DateTime.fromMillisecondsSinceEpoch(sunrise + 24 * 60 * 60 * 1000);
      difference = (now - sunset) / (nextSunrise.millisecondsSinceEpoch - sunset);
    }

    if (difference > 1){
      difference = 1;
    }

    var x = 150 * cos((1 + difference*fraction) * pi) + 150;
    var y = 145 * sin((1+difference*fraction)* pi) + 150;
    return Offset(x,y);
  }

  int _getCurrentTime(){
    return DateTime.now().millisecondsSinceEpoch;
  }
}
