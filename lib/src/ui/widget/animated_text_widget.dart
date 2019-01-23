import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AnimatedTextWidget extends StatefulWidget{
  final String textBefore;
  final double maxValue;


  AnimatedTextWidget({this.textBefore, this.maxValue, Key key}): super(key:key);

  @override
  State<StatefulWidget> createState() => _AnimatedTextWidgetState();

}

class _AnimatedTextWidgetState extends State<AnimatedTextWidget> with TickerProviderStateMixin{
  Animation<double> _animation;
  AnimationController _controller;
  double _value = 0;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
    final Animation curve =
    CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _animation = Tween(begin: 0.0, end: widget.maxValue).animate(curve)
      ..addListener(() {
        setState(() {
         _value = _animation.value;
        });
      });

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      "${widget.textBefore} ${_value.toStringAsFixed(0)}%",
      textDirection: TextDirection.ltr,
      style: Theme.of(context).textTheme.title,
    );
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}