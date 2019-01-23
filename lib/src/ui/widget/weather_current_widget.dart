import 'package:feather/src/blocs/application_bloc.dart';
import 'package:feather/src/models/remote/overall_weather_data.dart';
import 'package:feather/src/models/remote/weather_response.dart';
import 'package:feather/src/resources/weather_helper.dart';
import 'package:feather/src/ui/widget/empty_animation.dart';
import 'package:feather/src/ui/widget/weather_forecast_thumbnail_list_widget.dart';
import 'package:feather/src/ui/widget/widget_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';

class WeatherCurrentWidget extends StatefulWidget {
  final WeatherResponse weatherResponse;

  const WeatherCurrentWidget({Key key, this.weatherResponse}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return WeatherCurrentWidgetState();
  }

}

class WeatherCurrentWidgetState extends State<WeatherCurrentWidget> with SingleTickerProviderStateMixin {
  final Logger log = new Logger('CurrentWeatherWidget');
  AnimationController _controller;
  @override
  void initState() {
    super.initState();
    log.fine("Init weather widget state");
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
    applicationBloc.currentWeatherWidgetAnimationState = false;
  }

  @override
  Widget build(BuildContext context) {
    return buildWeatherContainer(widget.weatherResponse);
  }

  Widget buildWeatherContainer(WeatherResponse response) {
    return FadeTransition(
        opacity: _getAnimation(),
        child: Container(
            key: Key("weather_current_widget_container"),
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
                    key: Key("weather_current_widget_temperature"),
                    textDirection: TextDirection.ltr,
                    style: Theme.of(context).textTheme.headline),
                WidgetHelper.buildPadding(top: 30),
                Text(_getMaxMinTemperatureRow(response),
                    key: Key("weather_current_widget_min_max_temperature"),
                    textDirection: TextDirection.ltr,
                    style: Theme.of(context).textTheme.subtitle),
                WidgetHelper.buildPadding(top: 5),
                Text(_getPressureAndHumidityRow(response),
                    textDirection: TextDirection.ltr,
                    key: Key("weather_current_widget_pressure_humidity"),
                    style: Theme.of(context).textTheme.subtitle),
                WidgetHelper.buildPadding(top: 20),
                WeatherForecastThumbnailListWidget(
                    system: response.system,
                    key: Key("weather_current_widget_thumbnail_list")),
                WidgetHelper.buildPadding(top: 20),
              ],
            ))));
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

  Animation<double>_getAnimation(){
    if (applicationBloc.currentWeatherWidgetAnimationState) {
      return CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    } else {
      return EmptyAnimation();
    }
  }
}
