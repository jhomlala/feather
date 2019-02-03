import 'package:feather/src/resources/config/application_colors.dart';
import 'package:feather/src/ui/screen/about_screen.dart';
import 'package:feather/src/ui/widget/weather_main_widget.dart';
import 'package:feather/src/ui/widget/widget_helper.dart';
import 'package:flutter/material.dart';

class WeatherMainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Stack(
          children: <Widget>[
            Container(
                key: Key("weather_main_screen_container"),
                decoration: BoxDecoration(
                    gradient: WidgetHelper.buildGradient(
                        ApplicationColors.nightStartColor,
                        ApplicationColors.nightEndColor)),
                child: WeatherMainWidget()),
            new Positioned(
              //Place it at the top, and not use the entire screen
              top: 0.0,
              left: 0.0,
              right: 0.0,
              child: AppBar(
                actions: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.info_outline,
                      color: Colors.white,
                    ),
                    onPressed: () => _onInfoButtonPressed(context),
                  )
                ],
                backgroundColor: Colors.transparent, //No more green
                elevation: 0.0, //Shadow gone
              ),
            ),
          ],
        ));
  }

  _onInfoButtonPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AboutScreen()),
    );
  }
}
