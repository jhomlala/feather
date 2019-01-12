import 'package:feather/src/blocs/weather_bloc.dart';
import 'package:feather/src/models/internal/weather_forecast_holder.dart';
import 'package:feather/src/models/remote/weather_forecast_list_response.dart';
import 'package:feather/src/models/remote/weather_forecast_response.dart';
import 'package:feather/src/resources/weather_manager.dart';
import 'package:feather/src/ui/widget/weather_forecast_thumbnail_widget.dart';
import 'package:feather/src/ui/widget/widget_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WeatherForecastThumbnailListWidget extends StatefulWidget {
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
    bloc.fetchWeatherForecastForUserLocation();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: bloc.weatherForecast,
        builder:
            (context, AsyncSnapshot<WeatherForecastListResponse> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.errorCode != null) {
              return WidgetHelper.buildErrorWidget(
                  context, snapshot.data.errorCode);
            }
            return buildForecastWeatherContainer(snapshot);
          } else if (snapshot.hasError) {
            return WidgetHelper.buildErrorWidget(context, snapshot.error);
          }
          return WidgetHelper.buildProgressIndicator();
        });
  }

  Widget buildForecastWeatherContainer(
      AsyncSnapshot<WeatherForecastListResponse> snapshot) {
    List<WeatherForecastResponse> forecastList = snapshot.data.data;
    var map = WeatherManager.mapForecastsForSameDay(forecastList);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: buildForecastWeatherWidgets(map,snapshot.data),
    );
  }

  List<Widget> buildForecastWeatherWidgets(
      Map<String, List<WeatherForecastResponse>> map, WeatherForecastListResponse data) {
    List<Widget> forecastWidgets = new List();
    map.forEach((key, value) {
      forecastWidgets.add(
          new WeatherForecastThumbnailWidget(new WeatherForecastHolder(value,data.city)));
    });
    return forecastWidgets;
  }
}
