import 'package:feather/src/blocs/weather_bloc.dart';
import 'package:feather/src/models/remote/overall_weather_data.dart';
import 'package:feather/src/models/remote/weather_response.dart';
import 'package:feather/src/resources/weather_manager.dart';
import 'package:feather/src/ui/widget/weather_forecast_thumbnail_list_widget.dart';
import 'package:feather/src/ui/widget/widget_helper.dart';
import 'package:feather/src/utils/types_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';

class WeatherWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return WeatherWidgetState();
  }
}

class WeatherWidgetState extends State<WeatherWidget> {
  final Logger log = new Logger('WeatherWidget');

  @override
  void initState() {
    super.initState();
    log.fine("Init weather widget state");
    bloc.setupTimer();
    bloc.fetchWeatherForUserLocation();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc.weather,
      builder: (context, AsyncSnapshot<WeatherResponse> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.errorCode != null) {
            return WidgetHelper.buildErrorWidget(
                context, snapshot.data.errorCode);
          }
          return buildWeatherContainer(snapshot);
        } else if (snapshot.hasError) {
          return WidgetHelper.buildErrorWidget(context, snapshot.error);
        }
        return WidgetHelper.buildProgressIndicator();
      },
    );
  }

  Widget buildWeatherContainer(AsyncSnapshot<WeatherResponse> snapshot) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(snapshot.data.name, style: Theme.of(context).textTheme.title),
        Text(_getCurrentDateFormatted(),
            style: Theme.of(context).textTheme.subtitle),
        WidgetHelper.buildPadding(top: 50),
        Image.asset(
          _getWeatherImage(snapshot.data),
          width: 100,
          height: 100,
        ),
        Text(
            TypesHelper.formatTemperature(
                temperature: snapshot.data.mainWeatherData.temp),
            style: Theme.of(context).textTheme.headline),
        WidgetHelper.buildPadding(top: 50),
        Text(_getMaxMinTemperatureRow(snapshot.data),
            style: Theme.of(context).textTheme.subtitle),
        WidgetHelper.buildPadding(top: 5),
        Text(_getPressureAndHumidityRow(snapshot.data),
            style: Theme.of(context).textTheme.subtitle),
        WeatherForecastThumbnailListWidget()
      ],
    ));
  }

  String _getCurrentDateFormatted() {
    return DateFormat('dd/MM/yyyy').format(DateTime.now());
  }

  String _getMaxMinTemperatureRow(WeatherResponse weatherResponse) {
    return "↑ ${TypesHelper.formatTemperature(temperature: weatherResponse.mainWeatherData.tempMax)}    ↓${TypesHelper.formatTemperature(temperature: weatherResponse.mainWeatherData.tempMin)}";
  }

  String _getPressureAndHumidityRow(WeatherResponse weatherResponse) {
    return "${weatherResponse.mainWeatherData.pressure.toStringAsFixed(0)} hPa    ${weatherResponse.mainWeatherData.humidity.toString()}%";
  }

  String _getWeatherImage(WeatherResponse weatherResponse) {
    OverallWeatherData overallWeatherData =
        weatherResponse.overallWeatherData[0];
    int code = overallWeatherData.id;
    return WeatherManager.getWeatherIcon(code);
  }
}
