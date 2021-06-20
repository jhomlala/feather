import 'dart:core';

import 'package:feather/src/data/model/internal/weather_forecast_holder.dart';
import 'package:feather/src/resources/config/ids.dart';
import 'package:feather/src/ui/forecast/widget/weather_forecast_base_page.dart';
import 'package:feather/src/ui/forecast/widget/weather_forecast_wind_page.dart';
import 'package:feather/src/ui/forecast/widget/weather_forecast_pressure_page.dart';
import 'package:feather/src/ui/forecast/widget/weather_forecast_rain_page.dart';
import 'package:feather/src/ui/forecast/widget/weather_forecast_temperature_page.dart';
import 'package:feather/src/utils/app_logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';

class WeatherForecastWidget extends StatelessWidget {
  final WeatherForecastHolder? holder;
  final double? width;
  final double? height;
  final Map<String, WeatherForecastBasePage?> _pageMap = {};

  final bool isMetricUnits;

  WeatherForecastWidget({
    Key? key,
    this.holder,
    this.width,
    this.height,
    required this.isMetricUnits,
  }) : super(key: key);

  WeatherForecastBasePage? _getPage(String key, WeatherForecastHolder? holder,
      double? width, double? height) {
    if (_pageMap.containsKey(key)) {
      Log.d("Get page from map with key: $key");
      return _pageMap[key];
    } else {
      WeatherForecastBasePage? page;
      if (key == Ids.temperaturePage) {
        page = WeatherForecastTemperaturePage(
            holder, width, height, isMetricUnits);
      } else if (key == Ids.windPage) {
        page = WeatherForecastWindPage(holder, width, height, isMetricUnits);
      } else if (key == Ids.rainPage) {
        page = WeatherForecastRainPage(holder, width, height, isMetricUnits);
      } else if (key == Ids.pressurePage) {
        page =
            WeatherForecastPressurePage(holder, width, height, isMetricUnits);
      }
      _pageMap[key] = page;
      return page;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SingleChildScrollView(
            child: Directionality(
      textDirection: TextDirection.ltr,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        key: const Key("weather_forecast_container"),
        children: <Widget>[
          Text(
            holder!.getLocationName(context)!,
            textDirection: TextDirection.ltr,
            key: const Key("weather_forecast_location_name"),
            style: Theme.of(context).textTheme.headline6,
          ),
          Text(
            holder!.dateFullFormatted!,
            textDirection: TextDirection.ltr,
            key: const Key("weather_forecast_date_formatted"),
            style: Theme.of(context).textTheme.subtitle2,
          ),
          const SizedBox(height: 20),
          SizedBox(
              height: 450,
              child: Swiper(
                key: const Key("weather_forecast_swiper"),
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return _getPage(
                        Ids.temperaturePage, holder, width, height)!;
                  } else if (index == 1) {
                    return _getPage(Ids.windPage, holder, width, height)!;
                  } else if (index == 2) {
                    return _getPage(Ids.rainPage, holder, width, height)!;
                  } else {
                    return _getPage(Ids.pressurePage, holder, width, height)!;
                  }
                },
                loop: false,
                itemCount: 4,
                pagination: const SwiperPagination(
                  builder: DotSwiperPaginationBuilder(
                    color: Colors.white54,
                    activeColor: Colors.white,
                  ),
                ),
              ))
        ],
      ),
    )));
  }
}
