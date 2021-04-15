import 'package:feather/src/models/internal/overflow_menu_element.dart';
import 'package:feather/src/resources/application_localization.dart';
import 'package:feather/src/resources/config/application_colors.dart';
import 'package:feather/src/ui/main/main_screen_event.dart';
import 'package:feather/src/ui/screen/about_screen.dart';
import 'package:feather/src/ui/screen/settings_screen.dart';
import 'package:feather/src/ui/widget/weather_main_widget.dart';
import 'package:feather/src/ui/widget/widget_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'main_screen_bloc.dart';
import 'main_screen_state.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late MainScreenBloc _mainScreenBloc;

  @override
  void initState() {
    super.initState();
    _mainScreenBloc = BlocProvider.of(context);
    _mainScreenBloc.add(MainScreenLocationCheckEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
              key: Key("weather_main_screen_container"),
              decoration: BoxDecoration(
                gradient: WidgetHelper.buildGradient(
                    ApplicationColors.nightStartColor,
                    ApplicationColors.nightEndColor),
              )),
          BlocBuilder<MainScreenBloc, MainScreenState>(
              builder: (context, state) {
            if (state is LoadingMainScreenState) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              );
            } else if (state is SuccessLoadMainScreenState) {
              return WeatherMainWidget(weatherResponse: state.weatherResponse);
            } else {
              return SizedBox();
            }
          }),
          _buildOverflowMenu()
        ],
      ),
    );
  }

  Widget _buildOverflowMenu() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
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
              return _getOverflowMenu(context).map((PopupMenuElement element) {
                return PopupMenuItem<PopupMenuElement>(
                  value: element,
                  child: Text(
                    element.title!,
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }).toList();
            },
          ),
        ),
      ],
    );
  }

  List<PopupMenuElement> _getOverflowMenu(BuildContext context) {
    var applicationLocalization = ApplicationLocalization.of(context)!;
    List<PopupMenuElement> menuList = [];
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
}
