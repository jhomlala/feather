import 'package:feather/src/models/internal/overflow_menu_element.dart';
import 'package:feather/src/models/remote/weather_response.dart';
import 'package:feather/src/resources/application_localization.dart';
import 'package:feather/src/resources/config/application_colors.dart';
import 'package:feather/src/resources/config/dimensions.dart';
import 'package:feather/src/resources/config/ids.dart';
import 'package:feather/src/ui/main/main_screen_bloc.dart';
import 'package:feather/src/ui/main/main_screen_event.dart';
import 'package:feather/src/ui/main/main_screen_state.dart';
import 'package:feather/src/ui/screen/about_screen.dart';
import 'package:feather/src/ui/screen/settings_screen.dart';
import 'package:feather/src/ui/screen/weather_main_sun_path_page.dart';
import 'package:feather/src/ui/widget/animated_gradient.dart';
import 'package:feather/src/ui/widget/current_weather_widget.dart';
import 'package:feather/src/ui/widget/widget_helper.dart';
import 'package:feather/src/utils/app_logger.dart';
import 'package:feather/src/utils/date_time_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final Map<String, Widget?> _pageMap = new Map();
  late MainScreenBloc _mainScreenBloc;

  @override
  void initState() {
    super.initState();
    _mainScreenBloc = BlocProvider.of(context);
    _mainScreenBloc.add(LocationCheckMainScreenEvent());
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
                      state is CheckingLocationState) ...[
                    AnimatedGradientWidget(),
                    _buildLoadingWidget()
                  ] else ...[
                    _buildGradientWidget(),
                    if (state is LocationServiceDisabledMainScreenState)
                      _buildLocationServiceDisabledWidget()
                    else if (state is PermissionNotGrantedMainScreenState)
                      _buildPermissionNotGrantedWidget()
                    else if (state is SuccessLoadMainScreenState)
                      _buildWeatherWidget(state.weatherResponse)
                    else if (state is FailedLoadMainScreenState)
                      _buildFailedToLoadDataWidget()
                    else
                      SizedBox()
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

  Widget _buildWeatherWidget(WeatherResponse weatherResponse) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        key: Key("weather_main_widget_container"),
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
                key: Key("weather_main_widget_city_name"),
                textDirection: TextDirection.ltr,
                style: Theme.of(context).textTheme.headline6,
              ),
              Text(
                DateTimeHelper.formatDateTime(DateTime.now()),
                key: Key("weather_main_widget_date"),
                textDirection: TextDirection.ltr,
                style: Theme.of(context).textTheme.subtitle2,
              ),
              SizedBox(
                height: Dimensions.weatherMainWidgetSwiperHeight,
                child: _buildSwiperWidget(
                  weatherResponse,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwiperWidget(WeatherResponse weatherResponse) {
    return Swiper(
      key: Key("weather_main_swiper"),
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return _getPage(
            Ids.mainWeatherPage,
            weatherResponse,
          );
        } else {
          return _getPage(
            Ids.weatherMainSunPathPage,
            weatherResponse,
          );
        }
      },
      loop: false,
      itemCount: 2,
      pagination: SwiperPagination(
        builder: new DotSwiperPaginationBuilder(
          color: ApplicationColors.swiperInactiveDotColor,
          activeColor: ApplicationColors.swiperActiveDotColor,
        ),
      ),
    );
  }

  Widget _getPage(String key, WeatherResponse response) {
    if (_pageMap.containsKey(key)) {
      return _pageMap[key] ?? SizedBox();
    } else {
      Widget page;
      if (key == Ids.mainWeatherPage) {
        page = CurrentWeatherWidget(weatherResponse: response);
      } else if (key == Ids.weatherMainSunPathPage) {
        page = WeatherMainSunPathPage(
          system: response.system,
        );
      } else {
        Log.e("Unsupported key: $key");
        page = SizedBox();
      }
      _pageMap[key] = page;
      return page;
    }
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      ),
    );
  }

  Widget _buildGradientWidget() {
    return Container(
      key: Key("weather_main_screen_container"),
      decoration: BoxDecoration(
        gradient: WidgetHelper.buildGradient(
            ApplicationColors.nightStartColor, ApplicationColors.nightEndColor),
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

  Widget _buildLocationServiceDisabledWidget() {
    return _buildErrorWidget(
        "Your location service is disabled. Please enable it and try again.",
        () {
      _mainScreenBloc.add(LocationCheckMainScreenEvent());
    });
  }

  Widget _buildPermissionNotGrantedWidget() {
    return _buildErrorWidget(
        "Permissions not granted. Please accept permission.", () {
      _mainScreenBloc.add(LocationCheckMainScreenEvent());
    });
  }

  Widget _buildFailedToLoadDataWidget() {
    return _buildErrorWidget("Failed to load weather data.", () {
      _mainScreenBloc.add(LoadWeatherDataMainScreenEvent());
    });
  }

  Widget _buildErrorWidget(String errorMessage, Function() onRetryClicked) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                errorMessage,
                textAlign: TextAlign.center,
              ),
              TextButton(
                child: Text(
                  "Retry",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: onRetryClicked,
              )
            ],
          )
        ],
      ),
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