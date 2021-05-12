import 'package:feather/src/data/model/internal/weather_forecast_holder.dart';
import 'package:feather/src/data/repository/local/weather_helper.dart';
import 'package:feather/src/ui/navigation/navigation_bloc.dart';
import 'package:feather/src/ui/navigation/navigation_event.dart';
import 'package:feather/src/ui/widget/widget_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WeatherForecastThumbnailWidget extends StatefulWidget {
  final WeatherForecastHolder _holder;
  final bool _isMetricUnits;

  const WeatherForecastThumbnailWidget(this._holder, this._isMetricUnits,
      {Key? key})
      : super(key: key);

  @override
  _WeatherForecastThumbnailWidgetState createState() =>
      _WeatherForecastThumbnailWidgetState();
}

class _WeatherForecastThumbnailWidgetState
    extends State<WeatherForecastThumbnailWidget> {
  late NavigationBloc _navigationBloc;

  @override
  void initState() {
    _navigationBloc = BlocProvider.of(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final holder = widget._holder;
    var temperature = holder.averageTemperature;
    if (!widget._isMetricUnits) {
      temperature = WeatherHelper.convertCelsiusToFahrenheit(temperature!);
    }

    return Material(
      key: const Key("weather_forecast_thumbnail_widget"),
      color: Colors.transparent,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: InkWell(
          onTap: _onWeatherForecastClicked,
          child: Container(
            padding: WidgetHelper.buildEdgeInsets(left: 5, right: 5, top: 10),
            child: Column(
              children: <Widget>[
                Text(holder.dateShortFormatted!,
                    key: const Key("weather_forecast_thumbnail_date"),
                    textDirection: TextDirection.ltr,
                    style: Theme.of(context).textTheme.bodyText2),
                WidgetHelper.buildPadding(top: 5),
                Image.asset(holder.weatherCodeAsset!,
                    key: const Key("weather_forecast_thumbnail_icon"),
                    width: 30,
                    height: 30),
                WidgetHelper.buildPadding(top: 5),
                Text(
                    WeatherHelper.formatTemperature(
                      temperature: temperature,
                      metricUnits: widget._isMetricUnits,
                    ),
                    key: const Key("weather_forecast_thumbnai_temperature"),
                    textDirection: TextDirection.ltr,
                    style: Theme.of(context).textTheme.bodyText2),
                WidgetHelper.buildPadding(top: 5),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onWeatherForecastClicked() {
    _navigationBloc.add(ForecastScreenNavigationEvent(widget._holder));
  }
}
