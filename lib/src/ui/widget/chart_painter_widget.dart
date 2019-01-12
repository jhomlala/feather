import 'package:feather/src/models/internal/line_axis.dart';
import 'package:feather/src/models/internal/point.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ChartPainterWidget extends StatelessWidget {
  ChartPainterWidget(
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
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _ChartPainter(points, pointLabels, width, height, axes),
      ),
    );
  }
}

class _ChartPainter extends CustomPainter {
  _ChartPainter(
      this.points, this.pointLabels, this.width, this.height, this.axes);

  final List<Point> points;
  final List<String> pointLabels;
  final double width;
  final double height;
  final List<LineAxis> axes;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = _getLinePaint(Colors.white);

    _drawAxes(canvas);
    for (int index = 0; index < points.length - 1; index++) {
      canvas.drawLine(_getOffsetFromPoint(points[index]),
          _getOffsetFromPoint(points[index + 1]), paint);
      Offset textOffset = Offset(points[index].x - 5, points[index].y - 15);
      _drawText(canvas, textOffset, pointLabels[index]);
    }

    Offset textOffset = Offset(
        points[points.length - 1].x - 5, points[points.length - 1].y - 15);
    _drawText(canvas, textOffset, pointLabels[points.length - 1]);
  }

  void _drawText(Canvas canvas, Offset offset, String text) {
    TextSpan textSpan = TextSpan(
        style: new TextStyle(
            color: Colors.white70, fontSize: 10, letterSpacing: 0),
        text: text);
    TextPainter textPainter =
        TextPainter(text: textSpan, textDirection: TextDirection.ltr);
    textPainter.layout();
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
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
        _drawText(canvas, lineAxis.textOffset, lineAxis.label);
      }
    }
  }

  Paint _getLinePaint(Color color){
    Paint paint = Paint();
    paint.color = color;
    paint..strokeWidth = 1;
    paint..style = PaintingStyle.stroke;
    return paint;
  }

}
