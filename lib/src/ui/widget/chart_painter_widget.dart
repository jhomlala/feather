import 'package:feather/src/models/internal/line_axis.dart';
import 'package:feather/src/models/internal/point.dart';
import 'package:feather/src/ui/widget/widget_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';

class ChartWidget extends StatefulWidget {
  ChartWidget(
      {Key key,
      this.points,
      this.pointLabels,
      this.width,
      this.height,
      this.axes})
      : super(key: key);

  final List<Point> points;
  final List<String> pointLabels;
  final double width;
  final double height;
  final List<LineAxis> axes;

  @override
  State<StatefulWidget> createState() => _ChartWidgetState();
}

class _ChartWidgetState extends State<ChartWidget>
    with SingleTickerProviderStateMixin {
  double _fraction = 0.0;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    super.initState();
    var controller = AnimationController(
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
    if (widget.points.length < 3) {
      chartWidget = _getChartUnavailableWidget(context);
    } else {
      chartWidget = _getChartWidget();
    }

    return Container(
      width: widget.width,
      height: widget.height,
      child: chartWidget,
    );
  }

  Widget _getChartWidget() {
    return CustomPaint(
        painter: _ChartPainter(widget.points, widget.pointLabels, widget.width,
            widget.height, widget.axes, _fraction));
  }

  Widget _getChartUnavailableWidget(BuildContext context) {
    return Center(
        child: Text("Chart unavailable",
            style: Theme.of(context).textTheme.body1));
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
        _drawText(
            canvas, textOffset, pointLabels[index], lastLineFractionPercentage);
      } else {
        canvas.drawLine(_getOffsetFromPoint(points[index]),
            _getOffsetFromPoint(points[index + 1]), paint);
        _drawText(canvas, textOffset, pointLabels[index], 1);
      }
    }
    if (fraction > 0.99) {
      Offset textOffset = Offset(
          points[points.length - 1].x - 5, points[points.length - 1].y - 15);
      _drawText(canvas, textOffset, pointLabels[points.length - 1], 1);
    }
  }

  void _drawText(
      Canvas canvas, Offset offset, String text, double alphaFraction) {
    Color color = Color.fromARGB((179 * alphaFraction).floor(), 255, 255, 255);
    TextSpan textSpan = TextSpan(
        style: new TextStyle(color: color, fontSize: 10, letterSpacing: 0),
        text: text);
    TextPainter textPainter =
        TextPainter(text: textSpan, textDirection: TextDirection.ltr);
    textPainter.layout();
    textPainter.paint(canvas, offset);
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
        _drawText(canvas, lineAxis.textOffset, lineAxis.label, 1);
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
