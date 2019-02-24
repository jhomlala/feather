import 'package:feather/src/blocs/application_bloc.dart';
import 'package:feather/src/models/internal/overflow_menu_element.dart';
import 'package:feather/src/models/internal/unit.dart';
import 'package:feather/src/resources/application_localization.dart';
import 'package:feather/src/resources/config/application_colors.dart';
import 'package:feather/src/ui/widget/widget_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SettingsScreen extends StatefulWidget {
  @override
  SettingsScreenState createState() {
    return new SettingsScreenState();
  }
}

class SettingsScreenState extends State<SettingsScreen> {
  bool unitImperial = !applicationBloc.isMetricUnits();
  int refreshTime = applicationBloc.refreshTime;

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
                child: _getSettingsContainer(context)),
            new Positioned(
              top: 0.0,
              left: 0.0,
              right: 0.0,
              child: AppBar(
                backgroundColor: Colors.transparent, //No more green
                elevation: 0.0, //Shadow gone
              ),
            ),
          ],
        ));
  }

  Widget _getSettingsContainer(BuildContext context) {
    var applicationLocalization = ApplicationLocalization.of(context);
    return Container(
        padding: WidgetHelper.buildEdgeInsets(left: 30, top: 80),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(
                  "${applicationLocalization.getText("units")}:",
                  style: Theme.of(context).textTheme.subtitle,
                ),
                Row(children: [
                  Text(applicationLocalization.getText("metric")),
                  Switch(
                      value: unitImperial,
                      activeColor: Colors.grey,
                      activeTrackColor: Colors.white,
                      inactiveTrackColor: Colors.white,
                      inactiveThumbColor: Colors.grey,
                      onChanged: onChangedUnitState),
                  Text(applicationLocalization.getText("imperial")),
                  WidgetHelper.buildPadding(right: 10)
                ])
              ]),
              Text(
                applicationLocalization.getText("units_description"),
                style: Theme.of(context).textTheme.body2,
              ),
              WidgetHelper.buildPadding(top: 30),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(
                  "${applicationLocalization.getText("refresh_time")}:",
                  style: Theme.of(context).textTheme.subtitle,
                ),
                Center(child: Row(children: [
                  Theme(
                      data: Theme.of(context).copyWith(
                        cardColor: ApplicationColors.nightStartColor,
                      ),
                      child: PopupMenuButton<PopupMenuElement>(
                        onSelected: (PopupMenuElement element) {
                          _onMenuClicked(element);
                        },
                        child: Container(
                          child: Text(_getSelectedMenuElementText(context)),
                          padding: WidgetHelper.buildEdgeInsets(right: 10),
                        ),
                        itemBuilder: (BuildContext context) {
                          return _getRefreshTimeMenu(context)
                              .map((PopupMenuElement element) {
                            return PopupMenuItem<PopupMenuElement>(
                                value: element,
                                child: Text(element.title,
                                    style: TextStyle(color: Colors.white)));
                          }).toList();
                        },
                      ))
                ])),
              ]),
              WidgetHelper.buildPadding(top: 10),
              Text(
                applicationLocalization.getText("refresh_time_description"),
                style: Theme.of(context).textTheme.body2,
              ),
              WidgetHelper.buildPadding(top: 30),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(
                  "${applicationLocalization.getText("last_refresh_time")}:",
                  style: Theme.of(context).textTheme.subtitle,
                ),
              ]),
              WidgetHelper.buildPadding(top: 10),
              Text(DateTime.fromMillisecondsSinceEpoch(
                      applicationBloc.lastRefreshTime)
                  .toString(),style: Theme.of(context).textTheme.body2),
            ]));
  }

  List<PopupMenuElement> _getRefreshTimeMenu(BuildContext context) {
    var applicationLocalization = ApplicationLocalization.of(context);
    List<PopupMenuElement> menuList = List();
    menuList.add(PopupMenuElement(
      key: Key("menu_settings_refresh_time_10_minutes"),
      title: "10 ${applicationLocalization.getText("minutes")}",
    ));
    menuList.add(PopupMenuElement(
      key: Key("menu_settings_refresh_time_15_minutes"),
      title: "15 ${applicationLocalization.getText("minutes")}",
    ));
    menuList.add(PopupMenuElement(
      key: Key("menu_settings_refresh_time_30_minutes"),
      title: "30 ${applicationLocalization.getText("minutes")}",
    ));
    menuList.add(PopupMenuElement(
      key: Key("menu_settings_refresh_time_60_minutes"),
      title: "60 ${applicationLocalization.getText("minutes")}",
    ));

    return menuList;
  }

  onChangedUnitState(bool state) {
    var unit;
    if (state) {
      unit = Unit.imperial;
    } else {
      unit = Unit.metric;
    }
    applicationBloc.saveUnit(unit);
    setState(() {
      unitImperial = state;
    });
  }

  String _getSelectedMenuElementText(BuildContext context) {
    var applicationLocalization = ApplicationLocalization.of(context);
    switch (refreshTime) {
      case 600000:
        return "10 ${applicationLocalization.getText("minutes")}";
      case 900000:
        return "15${applicationLocalization.getText("minutes")}";
      case 1800000:
        return "30 ${applicationLocalization.getText("minutes")}";
      case 3600000:
        return "60 ${applicationLocalization.getText("minutes")}";
      default:
        return "10 ${applicationLocalization.getText("minutes")}";
    }
  }

  void _onMenuClicked(PopupMenuElement element) {
    print("element key: " + element.key.toString());
    int selectedRefreshTime = 600000;
    if (element.key == Key("menu_settings_refresh_time_10_minutes")) {
      selectedRefreshTime = 600000;
    } else if (element.key == Key("menu_settings_refresh_time_15_minutes")) {
      selectedRefreshTime = 900000;
    } else if (element.key == Key("menu_settings_refresh_time_30_minutes")) {
      selectedRefreshTime = 1800000;
    } else {
      selectedRefreshTime = 3600000;
    }

    applicationBloc.saveRefreshTime(selectedRefreshTime);
    setState(() {
      refreshTime = selectedRefreshTime;
    });
  }
}
