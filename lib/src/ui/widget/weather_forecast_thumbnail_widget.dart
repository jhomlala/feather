import 'package:feather/src/models/internal/weather_forecast_holder.dart';
import 'package:feather/src/ui/screen/weather_forecast_screen.dart';
import 'package:feather/src/ui/widget/widget_helper.dart';
import 'package:feather/src/utils/types_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WeatherForecastThumbnailWidget extends StatelessWidget {
  final WeatherForecastHolder _holder;

  WeatherForecastThumbnailWidget(this._holder);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          _onWeatherForecastClicked(context);
        },
        child: Container(
            padding: WidgetHelper.buildEdgeInsets(left: 10, top: 30),
            child: Column(
              children: <Widget>[
                Text(_holder.dateShortFormatted,
                    style: Theme.of(context).textTheme.body1),
                WidgetHelper.buildPadding(top: 5),
                Image.asset(_holder.weatherCodeAsset, width: 30, height: 30),
                WidgetHelper.buildPadding(top: 5),
                Text(
                    TypesHelper.formatTemperature(
                        temperature: _holder.averageTemperature, round: true),
                    style: Theme.of(context).textTheme.body1),
                WidgetHelper.buildPadding(top: 5),
              ],
            )));
  }

  _onWeatherForecastClicked(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => WeatherForecastScreen(_holder)),
    );
  }
}
