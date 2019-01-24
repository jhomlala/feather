import 'dart:async';

import 'package:feather/src/ui/widget/empty_animation.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

abstract class AnimatedState<T extends StatefulWidget> extends State<T>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Observable observable;
  StreamSubscription subscription;

  Widget build(BuildContext context);

  animateTween(
      {double start = 0.0,
      double end = 1.0,
      int duration: 1000,
      Curve curve = Curves.easeInOut}) {
    controller = _getAnimationController(this, duration);
    Animation animation = _getCurvedAnimation(controller, curve);
    var streamController = StreamController<double>();
    observable = Observable<double>(streamController.stream);
    Animation<double> tween = _getTween(start, end, animation);
    var valueListener = () {
      streamController.sink.add(tween.value);
    };
    tween..addListener(valueListener);
    tween.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        streamController.close();
      }
    });
    subscription =
        observable.listen((value) => onAnimatedValue(value as double));
    controller.forward();
  }

  Animation<double> setupAnimation(
      {Curve curve = Curves.easeInOut,
      int duration = 2000,
      bool noAnimation = false}) {
    if (controller == null) {
      controller = _getAnimationController(this, duration);
    }
    controller.forward();
    if (!noAnimation) {
      return _getCurvedAnimation(controller, curve);
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
      double start, double end, Animation animation) {
    return Tween(begin: start, end: end).animate(animation);
  }

  void onAnimatedValue(double value);

  @override
  void dispose() {
    if (controller != null) {
      controller.dispose();
    }
    if (observable != null) {
      subscription.cancel();
    }
    super.dispose();
  }
}
