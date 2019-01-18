import 'package:feather/src/models/internal/chart_data.dart';
import 'package:feather/src/models/internal/line_axis.dart';
import 'package:feather/src/models/internal/point.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';

class ChartWidget extends StatefulWidget {
  final ChartData chartData;

  const ChartWidget({Key key, this.chartData}) : super(key: key);


  @override
  State<StatefulWidget> createState() => _ChartWidgetState();
}

class _ChartWidgetState extends State<ChartWidget>
    with SingleTickerProviderStateMixin {
  double _fraction = 0.0;
  Animation<double> animation;
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    super.initState();
    controller = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);

    animation = Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {
          _fraction = animation.value;
        });
      });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    Widget chartWidget;
    if (widget.chartData.points.length < 3) {
      chartWidget = _getChartUnavailableWidget(context);
    } else {
      chartWidget = _getChartWidget();
    }

    return Container(
      key: Key("chart_widget_container"),
      width: widget.chartData.width,
      height: widget.chartData.height,
      child: chartWidget,
    );
  }

  Widget _getChartWidget() {
    return CustomPaint(
        painter: _ChartPainter(
            widget.chartData.points,
            widget.chartData.pointLabels,
            widget.chartData.width,
            widget.chartData.height,
            widget.chartData.axes,
            _fraction));
  }

  Widget _getChartUnavailableWidget(BuildContext context) {
    return Center(
        child: Text("Chart unavailable",
            textDirection: TextDirection.ltr,
            style: Theme.of(context).textTheme.body1));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class _ChartPainter extends CustomPainter {
  _ChartPainter(this.points, this.pointLabels, this.width, this.height,
      this.axes, this.fraction);

  final List<Point> points;
  final List<String> pointLabels;
  final double width;
  final double height;
  final List<LineAxis> axes;
  final double fraction;
  final Logger log = new Logger('ChartPainter');

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = _getLinePaint(Colors.white);
    _drawAxes(canvas);

    int pointsFraction = (points.length * fraction).floor();
    double lastLineFraction = fraction - pointsFraction * (1 / points.length);
    double lastLineFractionPercentage = lastLineFraction / (1 / points.length);

    for (int index = 0; index < pointsFraction - 1; index++) {
      Offset textOffset = Offset(points[index].x - 5, points[index].y - 15);
      if (index == pointsFraction - 2 && lastLineFraction != 0) {
        Point startPoint = points[index];
        Point endPoint = points[index + 1];
        Offset startOffset = _getOffsetFromPoint(startPoint);

        double diffX = endPoint.x - startPoint.x;
        double diffY = endPoint.y - startPoint.y;

        Offset endOffset = Offset(
            startPoint.x + diffX * lastLineFractionPercentage,
            startPoint.y + diffY * lastLineFractionPercentage);
        canvas.drawLine(startOffset, endOffset, paint);
        _drawText(canvas, textOffset, pointLabels[index],
            lastLineFractionPercentage, true);
      } else {
        canvas.drawLine(_getOffsetFromPoint(points[index]),
            _getOffsetFromPoint(points[index + 1]), paint);
        _drawText(canvas, textOffset, pointLabels[index], 1, true);
      }
    }
    if (fraction > 0.999) {
      Offset textOffset = Offset(
          points[points.length - 1].x - 5, points[points.length - 1].y - 15);
      _drawText(canvas, textOffset, pointLabels[points.length - 1], 1, true);
    }
  }

  void _drawText(Canvas canvas, Offset offset, String text,
      double alphaFraction, bool textShadow) {
    TextStyle textStyle = _getTextStyle(alphaFraction, textShadow);
    TextSpan textSpan = TextSpan(style: textStyle, text: text);
    TextPainter textPainter =
        TextPainter(text: textSpan, textDirection: TextDirection.ltr);
    textPainter.layout();
    textPainter.paint(canvas, offset);
  }

  TextStyle _getTextStyle(double alphaFraction, bool textShadow) {
    Color color = Color.fromARGB((220 * alphaFraction).floor(), 255, 255, 255);
    if (textShadow) {
      return new TextStyle(
          color: color,
          fontSize: 10,
          letterSpacing: 0,
          shadows: [
            Shadow(
                // bottomLeft
                offset: Offset(-1.0, -1.0),
                color: Colors.black38),
            Shadow(
                // bottomRight
                offset: Offset(1.0, -1.0),
                color: Colors.black38),
            Shadow(
                // topRight
                offset: Offset(1.0, 1.0),
                color: Colors.black38),
            Shadow(
                // topLeft
                offset: Offset(-1.0, 1.0),
                color: Colors.black38),
          ]);
    } else {
      return new TextStyle(color: color, fontSize: 10, letterSpacing: 0);
    }
  }

  @override
  bool shouldRepaint(_ChartPainter oldDelegate) {
    return oldDelegate.fraction != fraction;
  }

  Offset _getOffsetFromPoint(Point point) {
    return Offset(point.x, point.y);
  }

  void _drawAxes(Canvas canvas) {
    Paint axesPaint = _getLinePaint(Colors.white30);

    if (axes != null) {
      for (LineAxis lineAxis in axes) {
        canvas.drawLine(
            lineAxis.lineStartOffset, lineAxis.lineEndOffset, axesPaint);
        _drawText(canvas, lineAxis.textOffset, lineAxis.label, 1, false);
      }
    }
  }

  Paint _getLinePaint(Color color) {
    Paint paint = Paint();
    paint.color = color;
    paint..strokeWidth = 1;
    paint..style = PaintingStyle.stroke;
    return paint;
  }
}
