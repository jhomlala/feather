
import 'package:feather/src/ui/widget/widget_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AnimatedTextWidget extends StatefulWidget{
  final String textBefore;
  final double maxValue;


  AnimatedTextWidget({this.textBefore, this.maxValue, Key key}): super(key:key);

  @override
  State<StatefulWidget> createState() => _AnimatedTextWidgetState();

}

class _AnimatedTextWidgetState extends State<AnimatedTextWidget> with SingleTickerProviderStateMixin{
  Animation<double> _animation;
  AnimationController _controller;
  double _value = 0;
  @override
  void initState() {
    super.initState();


    //_controller = WidgetHelper.getAnimationController(this, 2000);
   /* _controller = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
    final Animation curve =
    CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    var animation = Tween(begin: 0.0, end: 72.0).animate(curve)
      ..addListener(() {
        setState(() {
          print("Valuee: " + _value.toString());
          _value = _controller.value;
        });
      });
    _controller.forward();*/
    /*_controller = WidgetHelper.animate(
        tickerProvider: this,
        start: 0.0,
        end: 10.0,
        curve: Curves.easeInOut,
        duration: 2000,
        callback: () => setState(() {
          _value = _controller.value;
          print("_value: " + _value.toString());
        }));*/


    /*_controller = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
    final Animation curve =
    CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    var animation = Tween(begin: 0.0, end: 72.0).animate(curve)
      ..addListener(() {
        setState(() {
          print("Valuee: " + _value.toString());
          _value = _controller.value;
        });
      });*/


   /* _controller = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
    final Animation curve =
    CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _animation = Tween(begin: 0.0, end: widget.maxValue).animate(curve)
      ..addListener(() {
        setState(() {
          print("Value: " + _value.toString());
         _value = _animation.value;
        });
      });

    _controller.forward();*/

   /*var pair = WidgetHelper.test(this,() =>
     setState(() {
       print("Value: " + _value.toString());
       //_value = pair.second.value;
     }));*/

    var observable = WidgetHelper.animate2(
        tickerProvider: this,
        start: 0.0,
        end: 10.0,
        curve: Curves.easeInOut,
        duration: 2000,
        callback: () => setState(() {
          _value = _controller.value;
          print("_value: " + _value.toString());
        }));

    observable.doOnData((data) => (){
      print("Data: " + data.toString());
    });



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
    //_controller.dispose();
    super.dispose();
  }
}