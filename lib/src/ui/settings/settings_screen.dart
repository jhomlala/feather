import 'package:feather/src/data/model/internal/overflow_menu_element.dart';
import 'package:feather/src/data/model/internal/unit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:feather/src/ui/app/app_bloc.dart';
import 'package:feather/src/ui/app/app_event.dart';
import 'package:feather/src/ui/settings/bloc/settings_screen_bloc.dart';
import 'package:feather/src/ui/settings/bloc/settings_screen_event.dart';
import 'package:feather/src/ui/settings/bloc/settings_screen_state.dart';
import 'package:feather/src/ui/widget/animated_gradient.dart';
import 'package:feather/src/ui/widget/loading_widget.dart';
import 'package:feather/src/ui/widget/transparent_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;

class SettingsScreen extends StatefulWidget {
  final List<Color> startGradientColors;

  const SettingsScreen({Key? key, this.startGradientColors = const []})
      : super(key: key);

  @override
  _SettingsScreenState createState() {
    return _SettingsScreenState();
  }
}

class _SettingsScreenState extends State<SettingsScreen> {
  late SettingsScreenBloc _settingsScreenBloc;
  late AppBloc _appBloc;

  @override
  void initState() {
    _settingsScreenBloc = BlocProvider.of(context);
    _settingsScreenBloc.add(LoadSettingsScreenEvent());
    _appBloc = BlocProvider.of(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          AnimatedGradientWidget(
            duration: const Duration(seconds: 3),
            startGradientColors: widget.startGradientColors,
          ),
          SafeArea(
            child: Stack(
              children: [
                BlocConsumer(
                  bloc: _settingsScreenBloc,
                  listener: (BuildContext context, state) {
                    _appBloc.add(LoadSettingsAppEvent());
                  },
                  builder: (context, state) {
                    if (state is InitialSettingsScreenState ||
                        state is LoadingSettingsScreenState) {
                      return const LoadingWidget();
                    } else if (state is LoadedSettingsScreenState) {
                      return Container(
                        key: const Key("settings_screen_container"),
                        child: _getSettingsContainer(state),
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
                const TransparentAppBar(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getSettingsContainer(LoadedSettingsScreenState state) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(state.lastRefreshTime);
    final applicationLocalization = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.only(left: 24, right: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 80),
          _buildUnitsChangeWidget(
              applicationLocalization, state.unit == Unit.imperial),
          Text(
            applicationLocalization.units_description,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          const SizedBox(height: 30),
          _buildRefreshTimePickerWidget(
              applicationLocalization, state.refreshTime),
          const SizedBox(height: 10),
          Text(
            applicationLocalization.refresh_time_description,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          const SizedBox(height: 30),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              "${applicationLocalization.last_refresh_time}:",
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ]),
          const SizedBox(height: 10),
          Text(
              "$dateTime (${timeago.format(dateTime, locale: Localizations.localeOf(context).languageCode)})",
              key: const Key("settings_screen_last_refresh_time"),
              style: Theme.of(context).textTheme.bodyText1),
        ],
      ),
    );
  }

  Widget _buildUnitsChangeWidget(
      AppLocalizations applicationLocalization, bool unitImperial) {
    return Row(
      key: const Key("settings_screen_units_picker"),
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "${applicationLocalization.units}:",
          style: Theme.of(context).textTheme.subtitle2,
        ),
        Row(
          children: [
            Text(applicationLocalization.metric),
            Switch(
                value: unitImperial,
                activeColor: Colors.grey,
                activeTrackColor: Colors.white,
                inactiveTrackColor: Colors.white,
                inactiveThumbColor: Colors.grey,
                onChanged: onChangedUnitState),
            Text(applicationLocalization.imperial),
            const SizedBox(height: 10),
          ],
        )
      ],
    );
  }

  Widget _buildRefreshTimePickerWidget(
      AppLocalizations applicationLocalization, int refreshTime) {
    return Row(
      key: const Key("settings_screen_refresh_timer"),
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "${applicationLocalization.refresh_time}:",
          style: Theme.of(context).textTheme.subtitle2,
        ),
        Center(
          child: Row(
            children: [
              Theme(
                data: Theme.of(context).copyWith(
                  cardColor: Colors.white,
                ),
                child: PopupMenuButton<PopupMenuElement>(
                  onSelected: (PopupMenuElement element) {
                    _onMenuClicked(element);
                  },
                  itemBuilder: (BuildContext context) {
                    return _getRefreshTimeMenu(context)
                        .map((PopupMenuElement element) {
                      return PopupMenuItem<PopupMenuElement>(
                        value: element,
                        child: Text(
                          element.title!,
                          style: const TextStyle(color: Colors.black),
                        ),
                      );
                    }).toList();
                  },
                  child: Container(
                    padding: const EdgeInsets.only(right: 10),
                    child: Text(
                      _getSelectedMenuElementText(refreshTime),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  List<PopupMenuElement> _getRefreshTimeMenu(BuildContext context) {
    final applicationLocalization = AppLocalizations.of(context)!;
    final List<PopupMenuElement> menuList = [];
    menuList.add(PopupMenuElement(
      key: const Key("menu_settings_refresh_time_10_minutes"),
      title: "10 ${applicationLocalization.minutes}",
    ));
    menuList.add(PopupMenuElement(
      key: const Key("menu_settings_refresh_time_15_minutes"),
      title: "15 ${applicationLocalization.minutes}",
    ));
    menuList.add(PopupMenuElement(
      key: const Key("menu_settings_refresh_time_30_minutes"),
      title: "30 ${applicationLocalization.minutes}",
    ));
    menuList.add(PopupMenuElement(
      key: const Key("menu_settings_refresh_time_60_minutes"),
      title: "60 ${applicationLocalization.minutes}",
    ));

    return menuList;
  }

  void onChangedUnitState(bool state) {
    Unit unit;
    if (state) {
      unit = Unit.imperial;
    } else {
      unit = Unit.metric;
    }
    _settingsScreenBloc.add(ChangeUnitsSettingsScreenEvent(unit));
  }

  String _getSelectedMenuElementText(int refreshTime) {
    final applicationLocalization = AppLocalizations.of(context)!;
    switch (refreshTime) {
      case 600000:
        return "10 ${applicationLocalization.minutes}";
      case 900000:
        return "15${applicationLocalization.minutes}";
      case 1800000:
        return "30 ${applicationLocalization.minutes}";
      case 3600000:
        return "60 ${applicationLocalization.minutes}";
      default:
        return "10 ${applicationLocalization.minutes}";
    }
  }

  void _onMenuClicked(PopupMenuElement element) {
    int selectedRefreshTime = 600000;
    if (element.key == const Key("menu_settings_refresh_time_10_minutes")) {
      selectedRefreshTime = 600000;
    } else if (element.key ==
        const Key("menu_settings_refresh_time_15_minutes")) {
      selectedRefreshTime = 900000;
    } else if (element.key ==
        const Key("menu_settings_refresh_time_30_minutes")) {
      selectedRefreshTime = 1800000;
    } else {
      selectedRefreshTime = 3600000;
    }

    _settingsScreenBloc
        .add(ChangeRefreshTimeSettingsScreenEvent(selectedRefreshTime));
  }
}
