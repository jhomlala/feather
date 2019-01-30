import 'package:feather/src/resources/config/application_colors.dart';
import 'package:feather/src/ui/widget/weather_main_widget.dart';
import 'package:feather/src/ui/widget/widget_helper.dart';
import 'package:flutter/material.dart';

class WeatherMainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Container(
            key: Key("weather_main_screen_container"),
            decoration: BoxDecoration(
                gradient: WidgetHelper.buildGradient(
                    ApplicationColors.nightStartColor,
                    ApplicationColors.nightEndColor)),
            child: WeatherMainWidget()));
  }
}
