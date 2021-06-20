import 'package:feather/src/data/model/internal/weather_forecast_holder.dart';
import 'package:feather/src/data/model/remote/system.dart';
import 'package:feather/src/data/model/remote/weather_forecast_list_response.dart';
import 'package:feather/src/data/model/remote/weather_forecast_response.dart';
import 'package:feather/src/data/repository/local/weather_helper.dart';
import 'package:feather/src/ui/app/app_bloc.dart';
import 'package:feather/src/ui/main/widget/weather_forecast_thumbnail_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WeatherForecastThumbnailListWidget extends StatefulWidget {
  final System? system;
  final WeatherForecastListResponse? forecastListResponse;

  const WeatherForecastThumbnailListWidget(
      {Key? key, this.system, this.forecastListResponse})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return WeatherForecastThumbnailListWidgetState();
  }
}

class WeatherForecastThumbnailListWidgetState
    extends State<WeatherForecastThumbnailListWidget> {
  late AppBloc _appBloc;

  @override
  void initState() {
    _appBloc = BlocProvider.of(context);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ///If forecast list response is empty, then it won't be displayed.
    ///MainScreen will present error to user.
    if (widget.forecastListResponse != null) {
      return buildForecastWeatherContainer(widget.forecastListResponse!);
    } else {
      return const SizedBox();
    }
  }

  Widget buildForecastWeatherContainer(
      WeatherForecastListResponse forecastListResponse) {
    final List<WeatherForecastResponse> forecastList =
        forecastListResponse.list!;
    final map = WeatherHelper.getMapForecastsForSameDay(forecastList);
    return Row(
      key: const Key("weather_forecast_thumbnail_list_widget_container"),
      textDirection: TextDirection.ltr,
      mainAxisAlignment: MainAxisAlignment.center,
      children: buildForecastWeatherWidgets(map, forecastListResponse),
    );
  }

  List<Widget> buildForecastWeatherWidgets(
      Map<String, List<WeatherForecastResponse>> map,
      WeatherForecastListResponse? data) {
    final List<Widget> forecastWidgets = [];
    map.forEach((key, value) {
      forecastWidgets.add(WeatherForecastThumbnailWidget(
        WeatherForecastHolder(value, data!.city, widget.system),
        _appBloc.isMetricUnits(),
      ));
    });
    return forecastWidgets;
  }
}
