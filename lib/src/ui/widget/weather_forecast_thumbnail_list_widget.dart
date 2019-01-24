import 'package:feather/src/blocs/weather_forecast_bloc.dart';
import 'package:feather/src/models/internal/weather_forecast_holder.dart';
import 'package:feather/src/models/remote/system.dart';
import 'package:feather/src/models/remote/weather_forecast_list_response.dart';
import 'package:feather/src/models/remote/weather_forecast_response.dart';
import 'package:feather/src/resources/weather_helper.dart';
import 'package:feather/src/ui/widget/weather_forecast_thumbnail_widget.dart';
import 'package:feather/src/ui/widget/widget_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WeatherForecastThumbnailListWidget extends StatefulWidget {
  final System system;

  const WeatherForecastThumbnailListWidget({Key key, this.system})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return WeatherForecastThumbnailListWidgetState();
  }
}

class WeatherForecastThumbnailListWidgetState
    extends State<WeatherForecastThumbnailListWidget> {
  @override
  void initState() {
    super.initState();
    _fetchWeatherForecast();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: bloc.weatherForecastSubject.stream,
        builder:
            (context, AsyncSnapshot<WeatherForecastListResponse> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.errorCode != null) {
              return WidgetHelper.buildErrorWidget(
                  context: context,
                  applicationError: snapshot.data.errorCode,
                  voidCallback: () =>
                      bloc.fetchWeatherForecastForUserLocation(),
                  withRetryButton: false);
            }
            return buildForecastWeatherContainer(snapshot);
          } else if (snapshot.hasError) {
            return WidgetHelper.buildErrorWidget(
                context: context,
                applicationError: snapshot.error,
                voidCallback: () =>
                    bloc.fetchWeatherForecastForUserLocation(),
                withRetryButton: false);
          }
          return WidgetHelper.buildProgressIndicator();
        });
  }

  Widget buildForecastWeatherContainer(
      AsyncSnapshot<WeatherForecastListResponse> snapshot) {
    List<WeatherForecastResponse> forecastList = snapshot.data.list;
    var map = WeatherHelper.mapForecastsForSameDay(forecastList);
    return Row(
      key: Key("weather_forecast_thumbnail_list_widget_container"),
      textDirection: TextDirection.ltr,
      mainAxisAlignment: MainAxisAlignment.center,
      children: buildForecastWeatherWidgets(map, snapshot.data),
    );
  }

  List<Widget> buildForecastWeatherWidgets(
      Map<String, List<WeatherForecastResponse>> map,
      WeatherForecastListResponse data) {
    List<Widget> forecastWidgets = new List();
    map.forEach((key, value) {
      forecastWidgets.add(new WeatherForecastThumbnailWidget(
          new WeatherForecastHolder(value, data.city, widget.system)));
    });
    return forecastWidgets;
  }

  _fetchWeatherForecast() {
    if (bloc.shouldFetchWeatherForecast()) {
      bloc.fetchWeatherForecastForUserLocation();
    }
  }
}
