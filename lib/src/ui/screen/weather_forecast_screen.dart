import 'package:feather/src/models/internal/overflow_menu_element.dart';
import 'package:feather/src/models/internal/weather_forecast_holder.dart';
import 'package:feather/src/resources/application_localization.dart';
import 'package:feather/src/resources/config/application_colors.dart';
import 'package:feather/src/ui/screen/about_screen.dart';
import 'package:feather/src/ui/screen/settings_screen.dart';
import 'package:feather/src/ui/widget/weather_forecast_widget.dart';
import 'package:feather/src/ui/widget/widget_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WeatherForecastScreen extends StatelessWidget {
  final WeatherForecastHolder _holder;

  const WeatherForecastScreen(this._holder);

  @override
  Widget build(BuildContext context) {
    LinearGradient gradient = WidgetHelper.getGradient(
        sunriseTime: _holder.system.sunrise, sunsetTime: _holder.system.sunset);
    print("Rebuild weather forecast screen");
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Stack(
          children: <Widget>[
            Container(
                key: Key("weather_main_screen_container"),
                decoration: BoxDecoration(gradient: gradient),
                child: WeatherForecastWidget(
                  holder: _holder,
                  width: 300,
                  height: 150,
                )),
            new Positioned(
              //Place it at the top, and not use the entire screen
              top: 0.0,
              left: 0.0,
              right: 0.0,
              child: AppBar(
                actions: <Widget>[
                  Theme(
                      data: Theme.of(context).copyWith(
                        cardColor: ApplicationColors.nightStartColor,
                      ),
                      child: PopupMenuButton<PopupMenuElement>(
                        onSelected: (PopupMenuElement element) {
                          _onMenuElementClicked(element, context);
                        },
                        icon: Icon(
                          Icons.more_vert,
                          color: Colors.white,
                        ),
                        itemBuilder: (BuildContext context) {
                          return _getOverflowMenu(context)
                              .map((PopupMenuElement element) {
                            return PopupMenuItem<PopupMenuElement>(
                                value: element,
                                child: Text(element.title,
                                    style: TextStyle(color: Colors.white)));
                          }).toList();
                        },
                      ))
                ],
                backgroundColor: Colors.transparent, //No more green
                elevation: 0.0, //Shadow gone
              ),
            ),
          ],
        ));
  }

  void _onMenuElementClicked(PopupMenuElement value, BuildContext context) {
    if (value.key == Key("menu_overflow_settings")) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SettingsScreen()),
      );
    }
    if (value.key == Key("menu_overflow_about")) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AboutScreen()),
      );
    }
  }

  List<PopupMenuElement> _getOverflowMenu(BuildContext context) {
    var applicationLocalization = ApplicationLocalization.of(context);
    List<PopupMenuElement> menuList = List();
    menuList.add(PopupMenuElement(
      key: Key("menu_overflow_settings"),
      title: applicationLocalization.getText("settings"),
    ));
    menuList.add(PopupMenuElement(
      key: Key("menu_overflow_about"),
      title: applicationLocalization.getText("about"),
    ));
    return menuList;
  }
}
