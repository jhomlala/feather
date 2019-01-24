import 'package:flutter/animation.dart';

class EmptyAnimation extends Animation<double> {
  @override
  void addListener(listener) {
  }

  @override
  void addStatusListener(listener) {
  }

  @override
  void removeListener(listener) {

  }

  @override
  void removeStatusListener(listener) {
  }

  @override
  AnimationStatus get status => AnimationStatus.completed;

  @override
  double get value => 1;

}