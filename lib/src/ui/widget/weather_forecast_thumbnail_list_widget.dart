import 'package:feather/src/data/model/internal/application_error.dart';
import 'package:feather/src/data/model/internal/weather_forecast_holder.dart';
import 'package:feather/src/data/model/remote/system.dart';
import 'package:feather/src/data/model/remote/weather_forecast_list_response.dart';
import 'package:feather/src/data/model/remote/weather_forecast_response.dart';
import 'package:feather/src/data/repository/local/weather_helper.dart';
import 'package:feather/src/ui/app/app_bloc.dart';
import 'package:feather/src/ui/widget/weather_forecast_thumbnail_widget.dart';
import 'package:feather/src/ui/widget/widget_helper.dart';
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
    return BlocBuilder(
        bloc: _appBloc,
        builder: (context, snapshot) {
          if (widget.forecastListResponse != null) {
            return buildForecastWeatherContainer(widget.forecastListResponse!);
          } else {
            return WidgetHelper.buildErrorWidget(
                context: context,
                applicationError: null,
                voidCallback: () => () {},
                withRetryButton: false);
          }
        }

        /*return StreamBuilder(
              stream: bloc.weatherForecastSubject.stream,
              builder: (context,
                  AsyncSnapshot<WeatherForecastListResponse> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.errorCode != null) {
                    return WidgetHelper.buildErrorWidget(
                        context: context,
                        applicationError: snapshot.data!.errorCode,
                        voidCallback: () =>
                            bloc.fetchWeatherForecastForUserLocation(),
                        withRetryButton: false);
                  }
                  return buildForecastWeatherContainer(snapshot);
                } else if (snapshot.hasError) {
                  return WidgetHelper.buildErrorWidget(
                      context: context,
                      applicationError: snapshot.error as ApplicationError?,
                      voidCallback: () =>
                          bloc.fetchWeatherForecastForUserLocation(),
                      withRetryButton: false);
                }
                return WidgetHelper.buildProgressIndicator();
              });*/

        );
  }

  Widget buildForecastWeatherContainer(
      WeatherForecastListResponse forecastListResponse) {
    List<WeatherForecastResponse> forecastList = forecastListResponse.list!;
    var map = WeatherHelper.mapForecastsForSameDay(forecastList);
    return Row(
      key: Key("weather_forecast_thumbnail_list_widget_container"),
      textDirection: TextDirection.ltr,
      mainAxisAlignment: MainAxisAlignment.center,
      children: buildForecastWeatherWidgets(map, forecastListResponse),
    );
  }

  List<Widget> buildForecastWeatherWidgets(
      Map<String, List<WeatherForecastResponse>> map,
      WeatherForecastListResponse? data) {
    List<Widget> forecastWidgets = [];
    map.forEach((key, value) {
      forecastWidgets.add(WeatherForecastThumbnailWidget(
        WeatherForecastHolder(value, data!.city, widget.system),
        _appBloc.isMetricUnits(),
      ));
    });
    return forecastWidgets;
  }
}
