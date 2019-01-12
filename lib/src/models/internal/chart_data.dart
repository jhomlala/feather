import 'package:feather/src/models/internal/line_axis.dart';
import 'package:feather/src/models/internal/point.dart';

class ChartData{
  final List<Point> points;
  final List<String> pointLabels;
  final double width;
  final double height;
  final List<LineAxis> axes;

  ChartData(this.points, this.pointLabels, this.width, this.height, this.axes);
}

enum ChartDataType{
  temperature,wind,rain
}