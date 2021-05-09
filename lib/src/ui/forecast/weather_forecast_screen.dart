import 'package:feather/src/data/model/internal/overflow_menu_element.dart';
import 'package:feather/src/data/model/internal/weather_forecast_holder.dart';
import 'package:feather/src/data/repository/local/application_localization.dart';
import 'package:feather/src/resources/config/application_colors.dart';
import 'package:feather/src/ui/app/app_bloc.dart';
import 'package:feather/src/ui/navigation/navigation_bloc.dart';
import 'package:feather/src/ui/navigation/navigation_event.dart';
import 'package:feather/src/ui/widget/weather_forecast_widget.dart';
import 'package:feather/src/ui/widget/widget_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WeatherForecastScreen extends StatefulWidget {
  final WeatherForecastHolder _holder;

  const WeatherForecastScreen(this._holder, {Key? key}) : super(key: key);

  @override
  _WeatherForecastScreenState createState() => _WeatherForecastScreenState();
}

class _WeatherForecastScreenState extends State<WeatherForecastScreen> {
  late AppBloc _appBloc;
  late NavigationBloc _navigationBloc;

  @override
  void initState() {
    _appBloc = BlocProvider.of(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final LinearGradient gradient = WidgetHelper.getGradient(
        sunriseTime: widget._holder.system!.sunrise,
        sunsetTime: widget._holder.system!.sunset);
    return Scaffold(
        body: Stack(
      children: <Widget>[
        BlocBuilder(
            bloc: _appBloc,
            builder: (context, state) {
              return Container(
                  key: const Key("weather_main_screen_container"),
                  decoration: BoxDecoration(gradient: gradient),
                  child: WeatherForecastWidget(
                    holder: widget._holder,
                    width: 300,
                    height: 150,
                    isMetricUnits: _appBloc.isMetricUnits(),
                  ));
            }),
        Positioned(
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
                    icon: const Icon(
                      Icons.more_vert,
                      color: Colors.white,
                    ),
                    itemBuilder: (BuildContext context) {
                      return _getOverflowMenu(context)
                          .map((PopupMenuElement element) {
                        return PopupMenuItem<PopupMenuElement>(
                          value: element,
                          child: Text(
                            element.title!,
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
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
    List<Color> startGradientColors = [];

    final LinearGradient gradient = WidgetHelper.getGradient(
        sunriseTime: widget._holder.system!.sunrise,
        sunsetTime: widget._holder.system!.sunset);
    startGradientColors = gradient.colors;

    if (value.key == const Key("menu_overflow_settings")) {
      _navigationBloc.add(SettingsScreenNavigationEvent(startGradientColors));
    }
    if (value.key == const Key("menu_overflow_about")) {
      _navigationBloc.add(AboutScreenNavigationEvent(startGradientColors));
    }
  }

  List<PopupMenuElement> _getOverflowMenu(BuildContext context) {
    final applicationLocalization = ApplicationLocalization.of(context)!;
    final List<PopupMenuElement> menuList = [];
    menuList.add(PopupMenuElement(
      key: const Key("menu_overflow_settings"),
      title: applicationLocalization.getText("settings"),
    ));
    menuList.add(PopupMenuElement(
      key: const Key("menu_overflow_about"),
      title: applicationLocalization.getText("about"),
    ));
    return menuList;
  }
}
