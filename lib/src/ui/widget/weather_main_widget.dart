import 'package:feather/src/blocs/weather_bloc.dart';
import 'package:feather/src/models/remote/weather_response.dart';
import 'package:feather/src/resources/config/application_colors.dart';
import 'package:feather/src/resources/config/dimensions.dart';
import 'package:feather/src/resources/config/ids.dart';
import 'package:feather/src/ui/screen/weather_main_page.dart';
import 'package:feather/src/ui/screen/weather_main_sun_path_page.dart';
import 'package:feather/src/ui/widget/widget_helper.dart';
import 'package:feather/src/utils/date_time_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:logging/logging.dart';

class WeatherMainWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => WeatherMainWidgetState();
}

class WeatherMainWidgetState extends State<WeatherMainWidget> {
  final Map<String, Widget> _pageMap = new Map();
  Logger _logger = Logger("WeatherMainWidgetState");

  @override
  void initState() {
    super.initState();
    bloc.setupTimer();
    bloc.fetchWeatherForUserLocation();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc.weatherSubject.stream,
      builder: (context, AsyncSnapshot<WeatherResponse> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.errorCode != null) {
            return WidgetHelper.buildErrorWidget(
                context: context,
                applicationError: snapshot.data.errorCode,
                voidCallback: () => bloc.fetchWeatherForUserLocation(),
                withRetryButton: true);
          }
          _logger.fine("Build weather container");
          return buildWeatherContainer(snapshot);
        } else if (snapshot.hasError) {
          return WidgetHelper.buildErrorWidget(
              context: context,
              applicationError: snapshot.error,
              voidCallback: () => bloc.fetchWeatherForUserLocation(),
              withRetryButton: true);
        }
        return WidgetHelper.buildProgressIndicator();
      },
    );
  }

  Widget _getPage(String key, WeatherResponse response) {
    if (_pageMap.containsKey(key)) {
      return _pageMap[key];
    } else {
      Widget page;
      if (key == Ids.mainWeatherPage) {
        page = WeatherMainPage(weatherResponse: response);
      } else if (key == Ids.weatherMainSunPathPage) {
        page = WeatherMainSunPathPage(
          system: response.system,
        );
      }
      _pageMap[key] = page;
      return page;
    }
  }

  Widget buildWeatherContainer(AsyncSnapshot<WeatherResponse> snapshot) {
    return Directionality(
        textDirection: TextDirection.ltr,
        child: Container(
            key: Key("weather_main_widget_container"),
            decoration: BoxDecoration(
                gradient: WidgetHelper.getGradient(
                    sunriseTime: snapshot.data.system.sunrise,
                    sunsetTime: snapshot.data.system.sunset)),
            child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                  Text(snapshot.data.name,
                      key: Key("weather_main_widget_city_name"),
                      textDirection: TextDirection.ltr,
                      style: Theme.of(context).textTheme.title),
                  Text(_getCurrentDateFormatted(),
                      key: Key("weather_main_widget_date"),
                      textDirection: TextDirection.ltr,
                      style: Theme.of(context).textTheme.subtitle),
                  SizedBox(
                      height: Dimensions.weatherMainWidgetSwiperHeight,
                      child: Swiper(
                        key: Key("weather_main_swiper"),
                        itemBuilder: (BuildContext context, int index) {
                          if (index == 0) {
                            return _getPage(Ids.mainWeatherPage, snapshot.data);
                          } else {
                            return _getPage(
                                Ids.weatherMainSunPathPage, snapshot.data);
                          }
                        },
                        loop: false,
                        itemCount: 2,
                        pagination: SwiperPagination(
                            builder: new DotSwiperPaginationBuilder(
                                color: ApplicationColors.swiperInactiveDotColor,
                                activeColor:
                                    ApplicationColors.swiperActiveDotColor)),
                      ))
                ]))));
  }

  String _getCurrentDateFormatted() {
    return DateTimeHelper.formatDateTime(DateTime.now());
  }
}
