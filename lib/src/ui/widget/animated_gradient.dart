import 'package:feather/src/resources/config/application_colors.dart';
import 'package:flutter/material.dart';

class AnimatedGradient extends StatefulWidget {
  @override
  _AnimatedGradientState createState() => _AnimatedGradientState();
}

class _AnimatedGradientState extends State<AnimatedGradient> {
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
  Color bottomColor =  ApplicationColors.dayStartColor;
  Color topColor = ApplicationColors.midnightEndColor;
  Alignment begin = Alignment.bottomLeft;
  Alignment end = Alignment.topRight;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 1), (){
      setState(() {
        bottomColor = ApplicationColors.dayEndColor;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return
        AnimatedContainer(
          duration: Duration(seconds: 1),
          onEnd: () {
            setState(() {
              index = index + 1;
              // animate the color
              bottomColor = colorList[index % colorList.length];
              topColor = colorList[(index + 1) % colorList.length];

              //// animate the alignment
              // begin = alignmentList[index % alignmentList.length];
              // end = alignmentList[(index + 2) % alignmentList.length];
            });
          },
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: begin,
              end: end,
              colors: [bottomColor, topColor],
            ),
          ));
  }
}
