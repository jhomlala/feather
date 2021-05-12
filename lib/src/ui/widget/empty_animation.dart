import 'package:flutter/animation.dart';

class EmptyAnimation extends Animation<double> {
  @override
  AnimationStatus get status => AnimationStatus.completed;

  @override
  double get value => 1;

  @override
  void addListener(dynamic listener) {}

  @override
  void addStatusListener(dynamic listener) {}

  @override
  void removeListener(dynamic listener) {}

  @override
  void removeStatusListener(dynamic listener) {}
}
