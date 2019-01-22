import 'package:feather/src/blocs/weather_bloc.dart';
import 'package:feather/src/models/remote/weather_response.dart';
import 'package:feather/src/ui/screen/weather_main_page.dart';
import 'package:feather/src/ui/screen/weather_main_sun_path_page.dart';
import 'package:feather/src/ui/widget/widget_helper.dart';
import 'package:feather/src/utils/date_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class WeatherMainWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => WeatherMainWidgetState();
}

class WeatherMainWidgetState extends State<WeatherMainWidget> {
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
                context,
                snapshot.data.errorCode,
                    () => bloc.fetchWeatherForUserLocation());
          }
          return buildWeatherContainer(snapshot);
        } else if (snapshot.hasError) {
          return WidgetHelper.buildErrorWidget(context, snapshot.error,
                  () => bloc.fetchWeatherForUserLocation());
        }
        return WidgetHelper.buildProgressIndicator();
      },
    );
  }

  Widget buildWeatherContainer(AsyncSnapshot<WeatherResponse> snapshot) {
    return Container(
        key: Key("weather_widget_container"),
        decoration: BoxDecoration(
            gradient: WidgetHelper.getGradient(
                sunriseTime: snapshot.data.system.sunrise,
                sunsetTime: snapshot.data.system.sunset)),
        child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              Text(snapshot.data.name,
                  key: Key("weather_widget_city_name"),
                  textDirection: TextDirection.ltr,
                  style: Theme.of(context).textTheme.title),
              Text(_getCurrentDateFormatted(),
                  key: Key("weather_widget_date"),
                  textDirection: TextDirection.ltr,
                  style: Theme.of(context).textTheme.subtitle),

              SizedBox(
                  height: 460,
                  child: Swiper(
                    key: Key("weather_forecast_swiper"),
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) {
                        return WeatherMainPage(weatherResponse: snapshot.data,);
                      } else {
                        return WeatherMainSunPathPage(system: snapshot.data.system,);
                      }
                    },
                    itemCount: 2,
                    pagination: SwiperPagination(
                        builder: new DotSwiperPaginationBuilder(
                            color: Colors.white54, activeColor: Colors.white)),
                  ))
            ])));
  }

  String _getCurrentDateFormatted() {
    return DateHelper.formatDateTime(DateTime.now());
  }
}
