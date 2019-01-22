import 'package:feather/src/models/internal/chart_line.dart';
import 'package:feather/src/models/internal/point.dart';

class ChartData{
  final List<Point> points;
  final List<String> pointLabels;
  final double width;
  final double height;
  final List<ChartLine> axes;

  ChartData(this.points, this.pointLabels, this.width, this.height, this.axes);
}

enum ChartDataType{
  temperature,wind,rain,pressure
}