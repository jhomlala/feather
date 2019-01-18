import 'package:feather/src/models/internal/weather_forecast_holder.dart';
import 'package:feather/src/resources/app_const.dart';
import 'package:feather/src/resources/weather_manager.dart';
import 'package:feather/src/ui/widget/weather_forecast_widget.dart';
import 'package:feather/src/ui/widget/widget_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WeatherForecastScreen extends StatelessWidget {
  final WeatherForecastHolder _holder;

  const WeatherForecastScreen(this._holder);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
                gradient: WidgetHelper.getGradient(
                    sunriseTime: _holder.system.sunrise,
                    sunsetTime: _holder.system.sunset)),
            child: WeatherForecastWidget(
              holder: _holder,
              width: 300,
              height: 150,
            )));
  }
}
