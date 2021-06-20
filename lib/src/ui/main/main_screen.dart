import 'package:feather/src/data/model/internal/application_error.dart';
import 'package:feather/src/data/model/internal/overflow_menu_element.dart';
import 'package:feather/src/data/model/remote/weather_forecast_list_response.dart';
import 'package:feather/src/data/model/remote/weather_response.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:feather/src/resources/config/application_colors.dart';
import 'package:feather/src/resources/config/dimensions.dart';
import 'package:feather/src/resources/config/ids.dart';
import 'package:feather/src/ui/app/app_bloc.dart';
import 'package:feather/src/ui/app/app_event.dart';
import 'package:feather/src/ui/main/bloc/main_screen_bloc.dart';
import 'package:feather/src/ui/main/bloc/main_screen_event.dart';
import 'package:feather/src/ui/main/bloc/main_screen_state.dart';
import 'package:feather/src/ui/main/widget/weather_main_sun_path_widget.dart';
import 'package:feather/src/ui/navigation/bloc/navigation_bloc.dart';
import 'package:feather/src/ui/navigation/bloc/navigation_event.dart';
import 'package:feather/src/ui/widget/animated_gradient.dart';
import 'package:feather/src/ui/widget/current_weather_widget.dart';
import 'package:feather/src/ui/widget/loading_widget.dart';
import 'package:feather/src/ui/widget/widget_helper.dart';
import 'package:feather/src/utils/app_logger.dart';
import 'package:feather/src/utils/date_time_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:app_settings/app_settings.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final Map<String, Widget?> _pageMap = <String, Widget?>{};
  late AppBloc _appBloc;
  late MainScreenBloc _mainScreenBloc;
  late NavigationBloc _navigationBloc;

  @override
  void initState() {
    super.initState();
    _appBloc = BlocProvider.of(context);
    _appBloc.add(LoadSettingsAppEvent());
    _mainScreenBloc = BlocProvider.of(context);
    _mainScreenBloc.add(LocationCheckMainScreenEvent());
    _navigationBloc = BlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          BlocBuilder<MainScreenBloc, MainScreenState>(
            builder: (context, state) {
              return Stack(
                children: [
                  if (state is InitialMainScreenState ||
                      state is LoadingMainScreenState ||
                      state is CheckingLocationMainScreenState) ...[
                    const AnimatedGradientWidget(),
                    const LoadingWidget(),
                  ] else ...[
                    _buildGradientWidget(),
                    if (state is LocationServiceDisabledMainScreenState)
                      _buildLocationServiceDisabledWidget()
                    else if (state is PermissionNotGrantedMainScreenState)
                      _buildPermissionNotGrantedWidget(
                          state.permanentlyDeniedPermission)
                    else if (state is SuccessLoadMainScreenState)
                      _buildWeatherWidget(state.weatherResponse,
                          state.weatherForecastListResponse)
                    else if (state is FailedLoadMainScreenState)
                      _buildFailedToLoadDataWidget(state.applicationError)
                    else
                      const SizedBox()
                  ]
                ],
              );
            },
          ),
          _buildOverflowMenu()
        ],
      ),
    );
  }

  Widget _buildWeatherWidget(WeatherResponse weatherResponse,
      WeatherForecastListResponse weatherForecastListResponse) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        key: const Key("main_screen_weather_widget_container"),
        decoration: BoxDecoration(
          gradient: WidgetHelper.getGradient(
            sunriseTime: weatherResponse.system!.sunrise,
            sunsetTime: weatherResponse.system!.sunset,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                weatherResponse.name!,
                key: const Key("main_screen_weather_widget_city_name"),
                textDirection: TextDirection.ltr,
                style: Theme.of(context).textTheme.headline6,
              ),
              Text(
                DateTimeHelper.formatDateTime(DateTime.now()),
                key: const Key("main_screen_weather_widget_date"),
                textDirection: TextDirection.ltr,
                style: Theme.of(context).textTheme.subtitle2,
              ),
              SizedBox(
                height: Dimensions.weatherMainWidgetSwiperHeight,
                child: _buildSwiperWidget(
                    weatherResponse, weatherForecastListResponse),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwiperWidget(WeatherResponse weatherResponse,
      WeatherForecastListResponse forecastListResponse) {
    return Swiper(
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return _getPage(
              Ids.mainWeatherPage, weatherResponse, forecastListResponse);
        } else {
          return _getPage(
            Ids.weatherMainSunPathPage,
            weatherResponse,
            forecastListResponse,
          );
        }
      },
      loop: false,
      itemCount: 2,
      pagination: SwiperPagination(
        builder: DotSwiperPaginationBuilder(
          color: ApplicationColors.swiperInactiveDotColor,
          activeColor: ApplicationColors.swiperActiveDotColor,
        ),
      ),
    );
  }

  Widget _getPage(String key, WeatherResponse response,
      WeatherForecastListResponse weatherForecastListResponse) {
    if (_pageMap.containsKey(key)) {
      return _pageMap[key] ?? const SizedBox();
    } else {
      Widget page;
      if (key == Ids.mainWeatherPage) {
        page = CurrentWeatherWidget(
          weatherResponse: response,
          forecastListResponse: weatherForecastListResponse,
        );
      } else if (key == Ids.weatherMainSunPathPage) {
        page = WeatherMainSunPathWidget(
          system: response.system,
        );
      } else {
        Log.e("Unsupported key: $key");
        page = const SizedBox();
      }
      _pageMap[key] = page;
      return page;
    }
  }

  Widget _buildGradientWidget() {
    return Container(
      key: const Key("main_screen_gradient_widget"),
      decoration: BoxDecoration(
        gradient: WidgetHelper.buildGradient(
          ApplicationColors.nightStartColor,
          ApplicationColors.nightEndColor,
        ),
      ),
    );
  }

  Widget _buildOverflowMenu() {
    return SafeArea(
      key: const Key("main_screen_overflow_menu"),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Theme(
            data: Theme.of(context).copyWith(cardColor: Colors.white),
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
                      style: const TextStyle(color: Colors.black),
                    ),
                  );
                }).toList();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationServiceDisabledWidget() {
    return _buildErrorWidget(
      AppLocalizations.of(context)!.error_location_disabled,
      () {
        _mainScreenBloc.add(
          LocationCheckMainScreenEvent(),
        );
      },
      key: const Key("main_screen_location_service_disabled_widget"),
    );
  }

  Widget _buildPermissionNotGrantedWidget(bool permanentlyDeniedPermission) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final String text = permanentlyDeniedPermission
        ? appLocalizations.error_permissions_not_granted_permanently
        : appLocalizations.error_permissions_not_granted;
    return Column(
        key: const Key("main_screen_permissions_not_granted_widget"),
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildErrorWidget(text, () {
            _mainScreenBloc.add(LocationCheckMainScreenEvent());
          }),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextButton(
              onPressed: () {
                AppSettings.openAppSettings();
              },
              child: Text(
                appLocalizations.open_app_settings,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ]);
  }

  Widget _buildFailedToLoadDataWidget(ApplicationError error) {
    final appLocalizations = AppLocalizations.of(context)!;
    String detailedDescription = "";
    switch (error) {
      case ApplicationError.apiError:
        detailedDescription = appLocalizations.error_api;
        break;
      case ApplicationError.connectionError:
        detailedDescription = appLocalizations.error_server_connection;
        break;
      case ApplicationError.locationNotSelectedError:
        detailedDescription = appLocalizations.error_location_not_selected;
        break;
    }

    return _buildErrorWidget(
      "${appLocalizations.error_failed_to_load_weather_data} $detailedDescription",
      () {
        _mainScreenBloc.add(LoadWeatherDataMainScreenEvent());
      },
      key: const Key("main_screen_failed_to_load_data_widget"),
    );
  }

  Widget _buildErrorWidget(
    String errorMessage,
    Function() onRetryClicked, {
    Key? key,
  }) {
    return Padding(
      key: key,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  errorMessage,
                  textAlign: TextAlign.center,
                ),
                TextButton(
                  onPressed: onRetryClicked,
                  child: Text(
                    AppLocalizations.of(context)!.retry,
                    style: const TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  List<PopupMenuElement> _getOverflowMenu(BuildContext context) {
    final applicationLocalization = AppLocalizations.of(context)!;
    final List<PopupMenuElement> menuList = [];
    menuList.add(PopupMenuElement(
        key: const Key("menu_overflow_settings"),
        title: applicationLocalization.settings));
    menuList.add(PopupMenuElement(
        key: const Key("menu_overflow_about"),
        title: applicationLocalization.about));
    return menuList;
  }

  void _onMenuElementClicked(PopupMenuElement value, BuildContext context) {
    List<Color> startGradientColors = [];
    if (_mainScreenBloc.state is SuccessLoadMainScreenState) {
      final weatherResponse =
          (_mainScreenBloc.state as SuccessLoadMainScreenState).weatherResponse;
      final LinearGradient gradient = WidgetHelper.getGradient(
          sunriseTime: weatherResponse.system!.sunrise,
          sunsetTime: weatherResponse.system!.sunset);
      startGradientColors = gradient.colors;
    }

    if (value.key == const Key("menu_overflow_settings")) {
      _navigationBloc.add(SettingsScreenNavigationEvent(startGradientColors));
    }
    if (value.key == const Key("menu_overflow_about")) {
      _navigationBloc.add(AboutScreenNavigationEvent(startGradientColors));
    }
  }
}
