import 'package:feather/src/blocs/application_bloc.dart';
import 'package:feather/src/models/internal/unit.dart';
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
  bool unitImperial = applicationBloc.unit != Unit.metric;

  @override
  Widget build(BuildContext context) {
    print("Current unit: " + applicationBloc.unit.toString() + " metric? " + unitImperial.toString());

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
    return Container( padding: WidgetHelper.buildEdgeInsets(left:30, top: 80),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [

      Row( mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

        Text("Units:", style: Theme.of(context).textTheme.subtitle,),
        Row(children: [
        Text("Metric"),
        Switch(
          value: unitImperial,
          activeColor: Colors.grey,
          activeTrackColor: Colors.white,
          inactiveTrackColor: Colors.white,
          inactiveThumbColor: Colors.grey,
          onChanged: onChangedUnitState
        ),
        Text("Imperial"),WidgetHelper.buildPadding(right: 10)])
      ])
    ]));
  }

  onChangedUnitState(bool state){
    var unit;
    if (state) {
      unit = Unit.imperial;
    } else {
      unit = Unit.metric;
    }
    applicationBloc.saveUnit(unit);
      print("changed to $state");
      setState(() {
        unitImperial = state;
      });

  }

}
