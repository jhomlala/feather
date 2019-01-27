import 'package:feather/src/models/internal/weather_forecast_holder.dart';
import 'package:feather/src/ui/widget/weather_forecast_widget.dart';
import 'package:feather/src/ui/widget/widget_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WeatherForecastScreen extends StatelessWidget {
  final WeatherForecastHolder _holder;

  const WeatherForecastScreen(this._holder);

  @override
  Widget build(BuildContext context) {
    LinearGradient gradient = WidgetHelper.getGradient(
        sunriseTime: _holder.system.sunrise, sunsetTime: _holder.system.sunset);

    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(30),
            child: AppBar(
                bottom: PreferredSize(
                  child: new Container(width: 0.0, height: 0.0),
                  preferredSize: Size.fromHeight(0),
                ),
                backgroundColor: gradient.colors[0],
                elevation: 0)),
        body: Container(
            decoration: BoxDecoration(gradient: gradient),
            child: WeatherForecastWidget(
              holder: _holder,
              width: 300,
              height: 150,
            )));
  }
}
