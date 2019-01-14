import 'dart:core';

import 'package:feather/src/models/internal/weather_forecast_holder.dart';
import 'package:feather/src/resources/app_const.dart';
import 'package:feather/src/ui/screen/weather_forecast_base_page.dart';
import 'package:feather/src/ui/screen/weather_forecast_rain_page.dart';
import 'package:feather/src/ui/screen/weather_forecast_temperature_page.dart';
import 'package:feather/src/ui/screen/weather_forecast_wind_page.dart';
import 'package:feather/src/ui/widget/widget_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:logging/logging.dart';

class WeatherForecastWidget extends StatelessWidget {
  final WeatherForecastHolder holder;
  final double width;
  final double height;
  final Map<String, WeatherForecastBasePage> _pageMap = new Map();
  final Logger _logger = Logger("WeatherForecastWidget");

  WeatherForecastWidget({Key key, this.holder, this.width, this.height})
      : super(key: key);

  WeatherForecastBasePage _getPage(
      String key, WeatherForecastHolder holder, double width, double height) {
    if (_pageMap.containsKey(key)) {
      _logger.log(Level.INFO, "Get page from map with key: $key");
      return _pageMap[key];
    } else {
      WeatherForecastBasePage page;
      if (key == AppConst.temperaturePage) {
        page = WeatherForecastTemperaturePage(holder, width, height);
      } else if (key == AppConst.windPage) {
        page = WeatherForecastWindPage(holder, width, height);
      } else if (key == AppConst.rainPage){
        page = WeatherForecastRainPage(holder, width, height);
      }
      _pageMap[key] = page;
      return page;
    }
  }

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
                    return _getPage(
                        AppConst.temperaturePage, holder, width, height);
                  } else if (index == 1) {
                    return _getPage(AppConst.windPage, holder, width, height);
                  } else {
                    return _getPage(AppConst.rainPage, holder, width, height);
                  }
                },
                itemCount: 3,
                pagination: SwiperPagination(
                    builder: new DotSwiperPaginationBuilder(
                        color: Colors.white54, activeColor: Colors.white)),
              ))
        ],
      ),
    );
  }
}
