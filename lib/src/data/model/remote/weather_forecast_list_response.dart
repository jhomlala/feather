import 'package:feather/src/data/model/internal/application_error.dart';
import 'package:feather/src/data/model/remote/city.dart';
import 'package:feather/src/data/model/remote/weather_forecast_response.dart';

class WeatherForecastListResponse {
  final List<WeatherForecastResponse>? list;
  final City? city;
  ApplicationError? _errorCode;

  WeatherForecastListResponse(this.list, this.city);

  WeatherForecastListResponse.fromJson(Map<String, dynamic> json)
      : list = (json["list"] as List)
            .map((dynamic data) =>
                WeatherForecastResponse.fromJson(data as Map<String, dynamic>))
            .toList(),
        city = City.fromJson(json["city"] as Map<String, dynamic>);

  Map<String, dynamic> toJson() =>
      <String, dynamic>{"list": list, "city": city};

  static WeatherForecastListResponse withErrorCode(ApplicationError errorCode) {
    final WeatherForecastListResponse response =
        WeatherForecastListResponse(null, null);
    response._errorCode = errorCode;
    return response;
  }

  ApplicationError? get errorCode => _errorCode;
}
