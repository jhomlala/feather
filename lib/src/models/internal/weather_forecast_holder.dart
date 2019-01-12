import 'package:feather/src/models/remote/city.dart';
import 'package:feather/src/models/remote/weather_forecast_response.dart';
import 'package:feather/src/resources/weather_manager.dart';

class WeatherForecastHolder {
  double _temperature;
  String _dateShortFormatted;
  String _dateFullFormatted;
  int _weatherCode;
  String _weatherCodeAsset;
  List<WeatherForecastResponse> _forecastList;
  City _city;

  WeatherForecastHolder(List<WeatherForecastResponse> forecastList, City city) {
    setupDateFormatted(forecastList[0].dateTime);
    setupTemperature(forecastList);
    setupWeatherCode(forecastList);
    _forecastList = forecastList;
    _city = city;
  }

  void setupDateFormatted(DateTime dateTime) {
    int day = dateTime.day;
    String dayString = "";
    if (day < 10) {
      dayString = "0" + day.toString();
    } else {
      dayString = day.toString();
    }

    int month = dateTime.month;
    String monthString = "";
    if (month < 10) {
      monthString = "0" + month.toString();
    } else {
      monthString = month.toString();
    }

    _dateShortFormatted = dayString + "/" + monthString;
    _dateFullFormatted = _dateShortFormatted + "/" + dateTime.year.toString();
  }

  void setupTemperature(List<WeatherForecastResponse> forecastList) {
    double sum = 0;
    for (WeatherForecastResponse response in forecastList) {
      sum = response.mainWeatherData.temp;
    }
    _temperature = sum / forecastList.length;
  }

  void setupWeatherCode(List<WeatherForecastResponse> forecastList) {
    int index = (forecastList.length / 2).floor();
    _weatherCode = forecastList[index].overallWeatherData[0].id;
    _weatherCodeAsset = WeatherManager.getWeatherIcon(_weatherCode);
  }

  String getLocationName() {
    if (city != null && city.name != null && city.name.length > 0) {
      return city.name;
    } else {
      return "Your location";
    }
  }

  String get weatherCodeAsset => _weatherCodeAsset;

  int get weatherCode => _weatherCode;

  double get temperature => _temperature;

  String get dateFullFormatted => _dateFullFormatted;

  String get dateShortFormatted => _dateShortFormatted;

  List<WeatherForecastResponse> get forecastList => _forecastList;

  City get city => _city;
}
