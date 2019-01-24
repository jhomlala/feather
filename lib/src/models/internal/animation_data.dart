import 'package:flutter/animation.dart';
import 'package:rxdart/rxdart.dart';

class AnimationData {
  final AnimationController controller;
  final Observable<double> observable;
  AnimationData(this.controller, this.observable);
}
