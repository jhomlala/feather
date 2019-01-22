import 'package:feather/src/blocs/weather_bloc.dart';
import 'package:feather/src/models/remote/overall_weather_data.dart';
import 'package:feather/src/models/remote/weather_response.dart';
import 'package:feather/src/resources/weather_helper.dart';
import 'package:feather/src/utils/date_helper.dart';
import 'package:feather/src/ui/widget/weather_forecast_thumbnail_list_widget.dart';
import 'package:feather/src/ui/widget/widget_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';

class WeatherWidget extends StatefulWidget {

  final WeatherResponse weatherResponse;

  const WeatherWidget({Key key, this.weatherResponse}) : super(key: key);
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
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildWeatherContainer(widget.weatherResponse);
  }

  Widget buildWeatherContainer(WeatherResponse response) {
    return Container(
        key: Key("weather_widget_container"),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            WidgetHelper.buildPadding(top: 30),
            Image.asset(
              _getWeatherImage(response),
              width: 100,
              height: 100,
            ),
            Text(
                WeatherHelper.formatTemperature(
                    temperature: response.mainWeatherData.temp),
                key: Key("weather_widget_temperature"),
                textDirection: TextDirection.ltr,
                style: Theme.of(context).textTheme.headline),
            WidgetHelper.buildPadding(top: 30),
            Text(_getMaxMinTemperatureRow(response),
                key: Key("weather_widget_min_max_temperature"),
                textDirection: TextDirection.ltr,
                style: Theme.of(context).textTheme.subtitle),
            WidgetHelper.buildPadding(top: 5),
            Text(_getPressureAndHumidityRow(response),
                textDirection: TextDirection.ltr,
                key: Key("weather_widget_pressure_humidity"),
                style: Theme.of(context).textTheme.subtitle),
            WidgetHelper.buildPadding(top: 20),
            WeatherForecastThumbnailListWidget(
                system: response.system,
                key: Key("weather_widget_thumbnail_list"))
          ],
        )));
  }


  String _getMaxMinTemperatureRow(WeatherResponse weatherResponse) {
    return "↑ ${WeatherHelper.formatTemperature(temperature: weatherResponse.mainWeatherData.tempMax)}" +
        "    ↓${WeatherHelper.formatTemperature(temperature: weatherResponse.mainWeatherData.tempMin)}";
  }

  String _getPressureAndHumidityRow(WeatherResponse weatherResponse) {
    return WeatherHelper.formatPressure(
            weatherResponse.mainWeatherData.pressure) +
        "    " +
        WeatherHelper.formatHumidity(weatherResponse.mainWeatherData.humidity);
  }

  String _getWeatherImage(WeatherResponse weatherResponse) {
    OverallWeatherData overallWeatherData =
        weatherResponse.overallWeatherData[0];
    int code = overallWeatherData.id;
    return WeatherHelper.getWeatherIcon(code);
  }
}
