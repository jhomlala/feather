import 'package:feather/src/ui/widget/animated_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AnimatedTextWidget extends StatefulWidget {
  final String? textBefore;
  final double? maxValue;

  const AnimatedTextWidget({this.textBefore, this.maxValue, Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _AnimatedTextWidgetState();
}

class _AnimatedTextWidgetState extends AnimatedState<AnimatedTextWidget> {
  double _value = 0;

  @override
  void initState() {
    super.initState();
    animateTween(end: widget.maxValue, duration: 2000);
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      "${widget.textBefore} ${_value.toStringAsFixed(0)}%",
      textDirection: TextDirection.ltr,
      style: Theme.of(context).textTheme.headline6,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void onAnimatedValue(double value) {
    setState(() {
      _value = value;
    });
  }
}
