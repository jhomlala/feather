import 'dart:core';
import 'package:feather/src/models/internal/weather_forecast_holder.dart';
import 'package:feather/src/ui/screen/weather_forecast_temperature_page.dart';
import 'package:feather/src/ui/screen/weather_forecast_wind_page.dart';
import 'package:feather/src/ui/widget/widget_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class WeatherForecastWidget extends StatelessWidget {
  final WeatherForecastHolder holder;
  final double width;
  final double height;

  const WeatherForecastWidget({Key key, this.holder, this.width, this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(holder.getLocationName(),
              style: Theme.of(context).textTheme.title),
          Text(holder.dateFullFormatted,
              style: Theme.of(context).textTheme.subtitle),
          WidgetHelper.buildPadding(top: 20),
          SizedBox(
              height: 450,
              child: Swiper(
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return WeatherForecastTemperaturePage(
                        holder, width, height);
                  } else {
                    return WeatherForecastWindPage(
                      holder,
                      width,
                      height,
                    );
                  }
                },
                itemCount: 2,
                pagination: SwiperPagination(
                    builder: new DotSwiperPaginationBuilder(
                        color: Colors.white54, activeColor: Colors.white)),
              ))
        ],
      ),
    );
  }
}
