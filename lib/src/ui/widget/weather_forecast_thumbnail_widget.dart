import 'package:feather/src/blocs/application_bloc.dart';
import 'package:feather/src/models/internal/weather_forecast_holder.dart';
import 'package:feather/src/resources/weather_helper.dart';
import 'package:feather/src/ui/screen/weather_forecast_screen.dart';
import 'package:feather/src/ui/widget/widget_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WeatherForecastThumbnailWidget extends StatelessWidget {
  final WeatherForecastHolder _holder;
  final WeatherForecastScreen _screen;

  WeatherForecastThumbnailWidget(this._holder)
      : _screen = WeatherForecastScreen(_holder);

  @override
  Widget build(BuildContext context) {
    var temperature = _holder.averageTemperature;
    if (!applicationBloc.isMetricUnits()){
      temperature = WeatherHelper.convertCelsiusToFahrenheit(temperature);
    }


    return Material(
        key: Key("weather_forecast_thumbnail_widget"),
        color: Colors.transparent,
        child: Directionality(
            textDirection: TextDirection.ltr,
            child: InkWell(
                onTap: () {
                  _onWeatherForecastClicked(context);
                },
                child: Container(
                    padding: WidgetHelper.buildEdgeInsets(
                        left: 5, right: 5, top: 10),
                    child: Column(
                      children: <Widget>[
                        Text(_holder.dateShortFormatted,
                            key: Key("weather_forecast_thumbnail_date"),
                            textDirection: TextDirection.ltr,
                            style: Theme.of(context).textTheme.body1),
                        WidgetHelper.buildPadding(top: 5),
                        Image.asset(_holder.weatherCodeAsset,
                            key: Key("weather_forecast_thumbnail_icon"),
                            width: 30,
                            height: 30),
                        WidgetHelper.buildPadding(top: 5),
                        Text(
                            WeatherHelper.formatTemperature(
                                temperature: temperature,
                                metricUnits: applicationBloc.isMetricUnits(),
                                round: true),
                            key: Key("weather_forecast_thumbnai_temperature"),
                            textDirection: TextDirection.ltr,
                            style: Theme.of(context).textTheme.body1),
                        WidgetHelper.buildPadding(top: 5),
                      ],
                    )))));
  }

  _onWeatherForecastClicked(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => _screen),
    );
  }
}
