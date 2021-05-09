import 'package:feather/src/data/model/remote/overall_weather_data.dart';
import 'package:feather/src/data/model/remote/weather_forecast_list_response.dart';
import 'package:feather/src/data/model/remote/weather_response.dart';
import 'package:feather/src/data/repository/local/application_localization.dart';
import 'package:feather/src/data/repository/local/weather_helper.dart';
import 'package:feather/src/ui/app/app_bloc.dart';
import 'package:feather/src/ui/screen/base/animated_state.dart';
import 'package:feather/src/ui/widget/weather_forecast_thumbnail_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CurrentWeatherWidget extends StatefulWidget {
  final WeatherResponse? weatherResponse;
  final WeatherForecastListResponse? forecastListResponse;

  const CurrentWeatherWidget(
      {Key? key, this.weatherResponse, this.forecastListResponse})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CurrentWeatherWidgetState();
  }
}

class CurrentWeatherWidgetState extends AnimatedState<CurrentWeatherWidget> {
  late AppBloc _appBloc;

  @override
  void initState() {
    _appBloc = BlocProvider.of(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: _appBloc,
      builder: (context, snapshot) {
        return buildWeatherContainer(widget.weatherResponse!, widget.forecastListResponse!);
      },
    );
  }

  Widget buildWeatherContainer(WeatherResponse response, WeatherForecastListResponse weatherForecastListResponse) {
    var currentTemperature = response.mainWeatherData!.temp;

    if (!_appBloc.isMetricUnits()) {
      currentTemperature =
          WeatherHelper.convertCelsiusToFahrenheit(currentTemperature);
    }

    return FadeTransition(
      opacity: setupAnimation(
        duration: 1000,
        noAnimation: true,
      ),
      child: Container(
        key: Key("weather_current_widget_container"),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 32),
              Image.asset(
                _getWeatherImage(response),
                width: 100,
                height: 100,
              ),
              Text(
                  WeatherHelper.formatTemperature(
                    temperature: currentTemperature,
                    metricUnits: _appBloc.isMetricUnits(),
                  ),
                  key: Key("weather_current_widget_temperature"),
                  textDirection: TextDirection.ltr,
                  style: Theme.of(context).textTheme.headline5),
              const SizedBox(height: 32),
              Text(_getMaxMinTemperatureRow(response),
                  key: Key("weather_current_widget_min_max_temperature"),
                  textDirection: TextDirection.ltr,
                  style: Theme.of(context).textTheme.subtitle2),
              const SizedBox(height: 4),
              _getPressureAndHumidityRow(response),
              const SizedBox(height: 24),
              WeatherForecastThumbnailListWidget(
                  system: response.system,
                  forecastListResponse: weatherForecastListResponse,
                  key: Key("weather_current_widget_thumbnail_list")),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  String _getMaxMinTemperatureRow(WeatherResponse weatherResponse) {
    var maxTemperature = weatherResponse.mainWeatherData!.tempMax;
    var minTemperature = weatherResponse.mainWeatherData!.tempMin;
    if (!_appBloc.isMetricUnits()) {
      maxTemperature = WeatherHelper.convertCelsiusToFahrenheit(maxTemperature);
      minTemperature = WeatherHelper.convertCelsiusToFahrenheit(minTemperature);
    }

    return "↑${WeatherHelper.formatTemperature(temperature: maxTemperature, metricUnits: _appBloc.isMetricUnits())}" +
        " ↓${WeatherHelper.formatTemperature(temperature: minTemperature, metricUnits: _appBloc.isMetricUnits())}";
  }

  Widget _getPressureAndHumidityRow(WeatherResponse weatherResponse) {
    var applicationLocalization = ApplicationLocalization.of(context)!;
    return RichText(
      textDirection: TextDirection.ltr,
      key: Key("weather_current_widget_pressure_humidity"),
      text: TextSpan(
        children: [
          TextSpan(
              text: "${applicationLocalization.getText("pressure")}: ",
              style: Theme.of(context).textTheme.bodyText1),
          TextSpan(
              text: WeatherHelper.formatPressure(
                  weatherResponse.mainWeatherData!.pressure,
                  _appBloc.isMetricUnits()),
              style: Theme.of(context).textTheme.subtitle2),
          TextSpan(
            text: "  ",
          ),
          TextSpan(
              text: "${applicationLocalization.getText("humidity")}: ",
              style: Theme.of(context).textTheme.bodyText1),
          TextSpan(
              text: WeatherHelper.formatHumidity(
                  weatherResponse.mainWeatherData!.humidity),
              style: Theme.of(context).textTheme.subtitle2)
        ],
      ),
    );
  }

  String _getWeatherImage(WeatherResponse weatherResponse) {
    OverallWeatherData overallWeatherData =
        weatherResponse.overallWeatherData![0];
    int code = overallWeatherData.id!;
    return WeatherHelper.getWeatherIcon(code);
  }

  @override
  void onAnimatedValue(double value) {}
}
