import 'package:feather/src/models/remote/city.dart';
import 'package:feather/src/models/remote/weather_forecast_response.dart';

class WeatherForecastListResponse {
  List<WeatherForecastResponse> _data;
  City _city;
  String _errorCode;

  WeatherForecastListResponse(Map<String, dynamic> data) {
    if (data.length == 0){
      return;
    }
    _data = (data["list"] as List)
        .map((i) => new WeatherForecastResponse(i))
        .toList();
    if (data.containsKey("city")){
      _city = City(data["city"]);
    }
  }

  static WeatherForecastListResponse withErrorCode(String errorCode){
    WeatherForecastListResponse response = new WeatherForecastListResponse(new Map<String,dynamic>());
    response._errorCode = errorCode;
    return response;
  }

  List<WeatherForecastResponse> get data => _data;

  City get city => _city;

  String get errorCode => _errorCode;

}
