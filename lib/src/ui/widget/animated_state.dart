import 'dart:async';

import 'package:feather/src/ui/widget/empty_animation.dart';
import 'package:flutter/widgets.dart';

abstract class AnimatedState<T extends StatefulWidget> extends State<T>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;
  late StreamController _streamController;
  StreamSubscription? subscription;

  void animateTween({
    double start = 0.0,
    double? end = 1.0,
    int duration = 1000,
    Curve curve = Curves.easeInOut,
  }) {
    controller = _getAnimationController(this, duration);
    final Animation animation = _getCurvedAnimation(controller!, curve);
    _streamController = StreamController<double>();

    final Animation<double> tween = _getTween(start, end, animation);

    tween.addListener(() {
      _streamController.sink.add(tween.value);
    });
    tween.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        _streamController.close();
      }
    });
    subscription = _streamController.stream
        .listen((dynamic value) => onAnimatedValue(value as double));
    controller!.forward();
  }

  Animation<double> setupAnimation(
      {Curve curve = Curves.easeInOut,
      int duration = 2000,
      bool noAnimation = false}) {
    controller ??= _getAnimationController(this, duration);
    controller!.forward();
    if (!noAnimation) {
      return _getCurvedAnimation(controller!, curve) as Animation<double>;
    } else {
      return EmptyAnimation();
    }
  }

  AnimationController _getAnimationController(
      SingleTickerProviderStateMixin object, int duration) {
    return AnimationController(
        duration: Duration(milliseconds: duration), vsync: object);
  }

  Animation _getCurvedAnimation(AnimationController controller, Curve curve) {
    return CurvedAnimation(parent: controller, curve: curve);
  }

  static Animation<double> _getTween(
      double start, double? end, Animation animation) {
    return Tween(begin: start, end: end)
        .animate(animation as Animation<double>);
  }

  void onAnimatedValue(double value);

  @override
  void dispose() {
    if (controller != null) {
      controller!.dispose();
    }
    subscription?.cancel();
    super.dispose();
  }
}
