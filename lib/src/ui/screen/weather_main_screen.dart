import 'package:feather/src/resources/app_const.dart';
import 'package:feather/src/ui/widget/weather_widget.dart';
import 'package:feather/src/ui/widget/widget_helper.dart';
import 'package:flutter/material.dart';

class WeatherMainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
                gradient: WidgetHelper.buildGradient(
                    AppConst.nightStartGradientColor,
                    AppConst.nightEndGradient)),
            child: WeatherWidget()));
  }
}
