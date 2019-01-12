class Point {
  double _x;
  double _y;
  Point(double x, double y){
    _x = x;
    _y = y;
  }

  double get y => _y;

  set y(double value) {
    _y = value;
  }

  double get x => _x;

  set x(double value) {
    _x = value;
  }

  @override
  String toString() {
    return 'Point{_x: $_x, _y: $_y}';
  }


}