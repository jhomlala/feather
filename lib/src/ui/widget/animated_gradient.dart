import 'package:feather/src/resources/config/application_colors.dart';
import 'package:flutter/material.dart';

class AnimatedGradientWidget extends StatefulWidget {
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

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        bottomColor = ApplicationColors.dayEndColor;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(seconds: 1),
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
