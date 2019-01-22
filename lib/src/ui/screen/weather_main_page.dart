import 'package:feather/src/models/remote/weather_response.dart';
import 'package:feather/src/ui/widget/weather_widget.dart';
import 'package:flutter/widgets.dart';

class WeatherMainPage extends StatelessWidget {
  final WeatherResponse weatherResponse;

  const WeatherMainPage({Key key, this.weatherResponse}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WeatherWidget(weatherResponse: weatherResponse,);
  }

}