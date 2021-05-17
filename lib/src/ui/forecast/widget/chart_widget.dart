import 'package:feather/src/data/model/internal/chart_data.dart';
import 'package:feather/src/data/model/internal/chart_line.dart';
import 'package:feather/src/data/model/internal/point.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:feather/src/ui/widget/animated_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ChartWidget extends StatefulWidget {
  final ChartData? chartData;

  const ChartWidget({Key? key, this.chartData}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ChartWidgetState();
}

class _ChartWidgetState extends AnimatedState<ChartWidget> {
  double _fraction = 0.0;

  @override
  void initState() {
    super.initState();
    // ignore: avoid_redundant_argument_values
    animateTween(duration: 1000, curve: Curves.linear);
  }

  @override
  Widget build(BuildContext context) {
    Widget chartWidget;
    if (widget.chartData!.points!.length < 3) {
      chartWidget = _getChartUnavailableWidget(context);
    } else {
      chartWidget = _getChartWidget();
    }

    return Container(
      key: const Key("chart_widget_container"),
      width: widget.chartData!.width,
      height: widget.chartData!.height,
      child: chartWidget,
    );
  }

  Widget _getChartWidget() {
    return CustomPaint(
      key: const Key("chart_widget_custom_paint"),
      painter: _ChartPainter(
          widget.chartData!.points,
          widget.chartData!.pointLabels,
          widget.chartData!.width,
          widget.chartData!.height,
          widget.chartData!.axes,
          _fraction),
    );
  }

  Widget _getChartUnavailableWidget(BuildContext context) {
    return Center(
      key: const Key("chart_widget_unavailable"),
      child: Text(
        AppLocalizations.of(context)!.chart_unavailable,
        textDirection: TextDirection.ltr,
        style: Theme.of(context).textTheme.bodyText2,
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

class _ChartPainter extends CustomPainter {
  _ChartPainter(this.points, this.pointLabels, this.width, this.height,
      this.axes, this.fraction);

  final List<Point>? points;
  final List<String>? pointLabels;
  final double? width;
  final double? height;
  final List<ChartLine>? axes;
  final double fraction;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = _getLinePaint(Colors.white);
    _drawAxes(canvas);

    final double fractionLinePerPoint = 1 / points!.length;
    final int pointsFraction = (points!.length * fraction).ceil();
    final double lastLineFraction =
        fraction - (pointsFraction - 1) * fractionLinePerPoint;
    final double lastLineFractionPercentage =
        lastLineFraction / (1 / points!.length);

    for (int index = 0; index < pointsFraction - 1; index++) {
      final Offset textOffset =
          Offset(points![index].x - 5, points![index].y - 15);
      if (index == pointsFraction - 2) {
        final Point startPoint = points![index];
        final Point endPoint = points![index + 1];
        final Offset startOffset = _getOffsetFromPoint(startPoint);

        final double diffX = endPoint.x - startPoint.x;
        final double diffY = endPoint.y - startPoint.y;

        final Offset endOffset = Offset(
            startPoint.x + diffX * lastLineFractionPercentage,
            startPoint.y + diffY * lastLineFractionPercentage);
        canvas.drawLine(startOffset, endOffset, paint);
        _drawText(canvas, textOffset, pointLabels![index + 1],
            lastLineFractionPercentage, true);
      } else {
        canvas.drawLine(_getOffsetFromPoint(points![index]),
            _getOffsetFromPoint(points![index + 1]), paint);
        _drawText(canvas, textOffset, pointLabels![index], 1, true);
      }
    }
    if (fraction > 0.999) {
      final Offset textOffset = Offset(points![points!.length - 1].x - 5,
          points![points!.length - 1].y - 15);
      _drawText(canvas, textOffset, pointLabels![points!.length - 1], 1, true);
    }
  }

  void _drawText(Canvas canvas, Offset offset, String? text,
      double alphaFraction, bool textShadow) {
    final TextStyle textStyle = _getTextStyle(alphaFraction, textShadow);
    final TextSpan textSpan = TextSpan(style: textStyle, text: text);
    final TextPainter textPainter =
        TextPainter(text: textSpan, textDirection: TextDirection.ltr);
    textPainter.layout();
    textPainter.paint(canvas, offset);
  }

  TextStyle _getTextStyle(double alphaFraction, bool textShadow) {
    final Color color =
        Color.fromARGB((220 * alphaFraction).floor(), 255, 255, 255);
    if (textShadow) {
      return TextStyle(
        color: color,
        fontSize: 10,
        letterSpacing: 0,
        shadows: const [
          Shadow(offset: Offset(-1.0, -1.0)),
          Shadow(offset: Offset(1.0, -1.0)),
          Shadow(offset: Offset(1.0, 1.0)),
          Shadow(offset: Offset(-1.0, 1.0)),
        ],
      );
    } else {
      return TextStyle(color: color, fontSize: 10, letterSpacing: 0);
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
    final Paint axesPaint = _getLinePaint(Colors.white30);

    if (axes != null) {
      for (final ChartLine lineAxis in axes!) {
        canvas.drawLine(
            lineAxis.lineStartOffset, lineAxis.lineEndOffset, axesPaint);
        _drawText(canvas, lineAxis.textOffset, lineAxis.label, 1, false);
      }
    }
  }

  Paint _getLinePaint(Color color) {
    final Paint paint = Paint();
    paint.color = color;
    paint.strokeWidth = 1;
    paint.style = PaintingStyle.stroke;
    return paint;
  }
}
