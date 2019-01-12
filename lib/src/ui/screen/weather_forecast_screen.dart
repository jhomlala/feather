import 'package:feather/src/models/internal/weather_forecast_holder.dart';
import 'package:feather/src/resources/app_const.dart';
import 'package:feather/src/ui/widget/weather_forecast_widget.dart';
import 'package:feather/src/ui/widget/widget_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class WeatherForecastScreen extends StatelessWidget {
  final WeatherForecastHolder _holder;

  const WeatherForecastScreen(this._holder);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
                gradient: WidgetHelper.buildGradient(
                    AppConst.startGradientColor, AppConst.endGradient)),
            child: WeatherForecastWidget(
              holder: _holder,
              width: 300,
              height: 150,
            )));
  }
}
