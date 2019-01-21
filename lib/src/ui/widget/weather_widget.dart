import 'package:feather/src/blocs/weather_bloc.dart';
import 'package:feather/src/models/remote/overall_weather_data.dart';
import 'package:feather/src/models/remote/weather_response.dart';
import 'package:feather/src/resources/weather_manager.dart';
import 'package:feather/src/utils/date_helper.dart';
import 'package:feather/src/ui/widget/weather_forecast_thumbnail_list_widget.dart';
import 'package:feather/src/ui/widget/widget_helper.dart';
import 'package:feather/src/utils/types_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';

class WeatherWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return WeatherWidgetState();
  }

  WeatherBloc getBloc() => bloc;
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
            WidgetHelper.buildPadding(top: 50),
            Image.asset(
              _getWeatherImage(snapshot.data),
              width: 100,
              height: 100,
            ),
            Text(
                TypesHelper.formatTemperature(
                    temperature: snapshot.data.mainWeatherData.temp),
                key: Key("weather_widget_temperature"),
                textDirection: TextDirection.ltr,
                style: Theme.of(context).textTheme.headline),
            WidgetHelper.buildPadding(top: 50),
            Text(_getMaxMinTemperatureRow(snapshot.data),
                key: Key("weather_widget_min_max_temperature"),
                textDirection: TextDirection.ltr,
                style: Theme.of(context).textTheme.subtitle),
            WidgetHelper.buildPadding(top: 5),
            Text(_getPressureAndHumidityRow(snapshot.data),
                textDirection: TextDirection.ltr,
                key: Key("weather_widget_pressure_humidity"),
                style: Theme.of(context).textTheme.subtitle),
            WidgetHelper.buildPadding(top: 20),
            WeatherForecastThumbnailListWidget(
                system: snapshot.data.system,
                key: Key("weather_widget_thumbnail_list"))
          ],
        )));
  }

  String _getCurrentDateFormatted() {
    return DateHelper.formatDateTime(DateTime.now());
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
