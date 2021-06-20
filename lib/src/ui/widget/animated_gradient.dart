import 'dart:async';

import 'package:feather/src/resources/config/application_colors.dart';
import 'package:flutter/material.dart';

class AnimatedGradientWidget extends StatefulWidget {
  final Duration duration;
  final List<Color> startGradientColors;

  const AnimatedGradientWidget({
    Key? key,
    this.duration = const Duration(seconds: 1),
    this.startGradientColors = const [],
  }) : super(key: key);

  @override
  _AnimatedGradientWidgetState createState() => _AnimatedGradientWidgetState();
}

class _AnimatedGradientWidgetState extends State<AnimatedGradientWidget> {
  List<Color> colorList = [
    ApplicationColors.dayStartColor,
    ApplicationColors.dayEndColor,
    ApplicationColors.midnightStartColor,
    ApplicationColors.midnightEndColor
  ];
  List<Alignment> alignmentList = [
    Alignment.bottomLeft,
    Alignment.bottomRight,
    Alignment.topRight,
    Alignment.topLeft,
  ];
  int index = 0;
  Color bottomColor = ApplicationColors.dayStartColor;
  Color topColor = ApplicationColors.midnightEndColor;
  Alignment begin = Alignment.bottomLeft;
  Alignment end = Alignment.topRight;
  Timer? _startTimer;

  @override
  void initState() {
    super.initState();
    if (widget.startGradientColors.isNotEmpty) {
      colorList.add( widget.startGradientColors[0]);
      colorList.add( widget.startGradientColors[1]);
      topColor = widget.startGradientColors[0];
      bottomColor = widget.startGradientColors[1];
    }

    _startTimer = Timer(const Duration(seconds: 1), (){
      if (mounted) {
        setState(() {
          bottomColor = colorList[1];
        });
      }
      _startTimer?.cancel();
      _startTimer = null;
    });
  }

  @override
  void dispose() {
    _startTimer?.cancel();
    _startTimer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: widget.duration,
      onEnd: () {
        setState(() {
          index = index + 1;
          bottomColor = colorList[index % colorList.length];
          topColor = colorList[(index + 1) % colorList.length];
        });
      },
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: begin,
          end: end,
          colors: [bottomColor, topColor],
        ),
      ),
    );
  }
}
