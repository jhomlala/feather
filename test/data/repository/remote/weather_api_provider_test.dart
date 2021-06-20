import 'dart:convert';

import 'package:feather/src/data/model/internal/application_error.dart';
import 'package:feather/src/data/model/remote/clouds.dart';
import 'package:feather/src/data/model/remote/coordinates.dart';
import 'package:feather/src/data/model/remote/main_weather_data.dart';
import 'package:feather/src/data/model/remote/overall_weather_data.dart';
import 'package:feather/src/data/model/remote/system.dart';
import 'package:feather/src/data/model/remote/weather_forecast_list_response.dart';
import 'package:feather/src/data/model/remote/weather_forecast_response.dart';
import 'package:feather/src/data/model/remote/weather_response.dart';
import 'package:feather/src/data/model/remote/wind.dart';
import 'package:feather/src/data/repository/remote/weather_api_provider.dart';
import 'package:feather/src/resources/config/application_config.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  late WeatherApiProvider mockWeatherApiProvider;
  late WeatherApiProvider weatherApiProvider;
  late DioAdapter dioAdapter;
  setUpAll(() {
    mockWeatherApiProvider = WeatherApiProvider();
    weatherApiProvider = WeatherApiProvider();
    dioAdapter = DioAdapter();
    mockWeatherApiProvider.dio.httpClientAdapter = dioAdapter;
  });

  group("Mock fetch weather", () {
    test("Fetch weather returns valid data with 200 status", () async {
      dioAdapter.onGet(
          "https://api.openweathermap.org/data/2.5/weather?lat=0.0&lon=0.0&apiKey=${ApplicationConfig.apiKey}&units=metric",
          (request) {
        return request.reply(200, jsonDecode(
            // ignore: avoid_escaping_inner_quotes
            "{\"coord\":{\"lon\":0,\"lat\":0},\"weather\":[{\"id\":804,\"main\":\"Clouds\",\"description\":\"overcast clouds\",\"icon\":\"04d\"}],\"base\":\"stations\",\"main\":{\"temp\":26.98,\"feels_like\":29.6,\"temp_min\":26.98,\"temp_max\":26.98,\"pressure\":1010,\"humidity\":79,\"sea_level\":1010,\"grnd_level\":1010},\"visibility\":10000,\"wind\":{\"speed\":7.54,\"deg\":176,\"gust\":7.91},\"clouds\":{\"all\":100},\"dt\":1622396965,\"sys\":{\"sunrise\":1622354049,\"sunset\":1622397678},\"timezone\":0,\"id\":6295630,\"name\":\"Globe\",\"cod\":200}"));
      });
      final result = await mockWeatherApiProvider.fetchWeather(0, 0);
      assert(result.clouds != null, true);
      assert(result.cod != null, true);
      assert(result.cord != null, true);
      assert(result.id != null, true);
      assert(result.mainWeatherData != null, true);
      assert(result.name != null, true);
      assert(result.overallWeatherData != null, true);
      assert(result.system != null, true);
      assert(result.wind != null, true);
    });

    test("Fetch weather returns connection error", () async {
      dioAdapter.onGet(
          "https://api.openweathermap.org/data/2.5/weather?lat=0.0&lon=0.0&apiKey=${ApplicationConfig.apiKey}&units=metric",
          (request) {
        request.reply(400, "Error");
      });
      final result = await mockWeatherApiProvider.fetchWeather(0, 0);
      assert(result.errorCode == ApplicationError.connectionError, true);
    });

    test("Fetch weather returns api error", () async {
      dioAdapter.onGet(
          "https://api.openweathermap.org/data/2.5/weather?lat=0.0&lon=0.0&apiKey=${ApplicationConfig.apiKey}&units=metric",
          (request) {
        request.reply(201, "Error");
      });
      final result = await mockWeatherApiProvider.fetchWeather(0, 0);
      assert(result.errorCode == ApplicationError.connectionError, true);
    });
  });

  group("Mock fetch weather forecast", () {
    test("Fetch weather forecast returns valid data with 200 status", () async {
      dioAdapter.onGet(
          "https://api.openweathermap.org/data/2.5/forecast?lat=0.0&lon=0.0&apiKey=${ApplicationConfig.apiKey}&units=metric",
          (request) {
        return request.reply(200, jsonDecode(
            // ignore: avoid_escaping_inner_quotes
            "{\"cod\":\"200\",\"message\":0,\"cnt\":40,\"list\":[{\"dt\":1622408400,\"main\":{\"temp\":25.34,\"feels_like\":25.86,\"temp_min\":25.34,\"temp_max\":27.13,\"pressure\":1015,\"sea_level\":1015,\"grnd_level\":1011,\"humidity\":74,\"temp_kf\":-1.79},\"weather\":[{\"id\":804,\"main\":\"Clouds\",\"description\":\"overcast clouds\",\"icon\":\"04n\"}],\"clouds\":{\"all\":89},\"wind\":{\"speed\":7.6,\"deg\":171,\"gust\":8.21},\"visibility\":10000,\"pop\":0,\"sys\":{\"pod\":\"n\"},\"dt_txt\":\"2021-05-30 21:00:00\"},{\"dt\":1622419200,\"main\":{\"temp\":26.13,\"feels_like\":26.13,\"temp_min\":26.13,\"temp_max\":26.98,\"pressure\":1012,\"sea_level\":1012,\"grnd_level\":1010,\"humidity\":76,\"temp_kf\":-0.85},\"weather\":[{\"id\":803,\"main\":\"Clouds\",\"description\":\"broken clouds\",\"icon\":\"04n\"}],\"clouds\":{\"all\":80},\"wind\":{\"speed\":7.33,\"deg\":161,\"gust\":7.81},\"visibility\":10000,\"pop\":0,\"sys\":{\"pod\":\"n\"},\"dt_txt\":\"2021-05-31 00:00:00\"},{\"dt\":1622430000,\"main\":{\"temp\":26.82,\"feels_like\":29.18,\"temp_min\":26.82,\"temp_max\":26.82,\"pressure\":1010,\"sea_level\":1010,\"grnd_level\":1010,\"humidity\":78,\"temp_kf\":0},\"weather\":[{\"id\":804,\"main\":\"Clouds\",\"description\":\"overcast clouds\",\"icon\":\"04n\"}],\"clouds\":{\"all\":86},\"wind\":{\"speed\":6.35,\"deg\":161,\"gust\":6.34},\"visibility\":10000,\"pop\":0,\"sys\":{\"pod\":\"n\"},\"dt_txt\":\"2021-05-31 03:00:00\"},{\"dt\":1622440800,\"main\":{\"temp\":26.67,\"feels_like\":28.88,\"temp_min\":26.67,\"temp_max\":26.67,\"pressure\":1011,\"sea_level\":1011,\"grnd_level\":1011,\"humidity\":78,\"temp_kf\":0},\"weather\":[{\"id\":803,\"main\":\"Clouds\",\"description\":\"broken clouds\",\"icon\":\"04d\"}],\"clouds\":{\"all\":79},\"wind\":{\"speed\":5.89,\"deg\":169,\"gust\":5.92},\"visibility\":10000,\"pop\":0,\"sys\":{\"pod\":\"d\"},\"dt_txt\":\"2021-05-31 06:00:00\"},{\"dt\":1622451600,\"main\":{\"temp\":26.74,\"feels_like\":29.02,\"temp_min\":26.74,\"temp_max\":26.74,\"pressure\":1013,\"sea_level\":1013,\"grnd_level\":1013,\"humidity\":78,\"temp_kf\":0},\"weather\":[{\"id\":803,\"main\":\"Clouds\",\"description\":\"broken clouds\",\"icon\":\"04d\"}],\"clouds\":{\"all\":76},\"wind\":{\"speed\":6.18,\"deg\":168,\"gust\":6.01},\"visibility\":10000,\"pop\":0,\"sys\":{\"pod\":\"d\"},\"dt_txt\":\"2021-05-31 09:00:00\"},{\"dt\":1622462400,\"main\":{\"temp\":26.78,\"feels_like\":28.94,\"temp_min\":26.78,\"temp_max\":26.78,\"pressure\":1011,\"sea_level\":1011,\"grnd_level\":1011,\"humidity\":76,\"temp_kf\":0},\"weather\":[{\"id\":804,\"main\":\"Clouds\",\"description\":\"overcast clouds\",\"icon\":\"04d\"}],\"clouds\":{\"all\":88},\"wind\":{\"speed\":5.68,\"deg\":177,\"gust\":6.21},\"visibility\":10000,\"pop\":0,\"sys\":{\"pod\":\"d\"},\"dt_txt\":\"2021-05-31 12:00:00\"},{\"dt\":1622473200,\"main\":{\"temp\":27,\"feels_like\":29.28,\"temp_min\":27,\"temp_max\":27,\"pressure\":1009,\"sea_level\":1009,\"grnd_level\":1009,\"humidity\":75,\"temp_kf\":0},\"weather\":[{\"id\":804,\"main\":\"Clouds\",\"description\":\"overcast clouds\",\"icon\":\"04d\"}],\"clouds\":{\"all\":100},\"wind\":{\"speed\":5.78,\"deg\":183,\"gust\":6.14},\"visibility\":10000,\"pop\":0,\"sys\":{\"pod\":\"d\"},\"dt_txt\":\"2021-05-31 15:00:00\"},{\"dt\":1622484000,\"main\":{\"temp\":27.08,\"feels_like\":29.53,\"temp_min\":27.08,\"temp_max\":27.08,\"pressure\":1011,\"sea_level\":1011,\"grnd_level\":1011,\"humidity\":76,\"temp_kf\":0},\"weather\":[{\"id\":500,\"main\":\"Rain\",\"description\":\"light rain\",\"icon\":\"10d\"}],\"clouds\":{\"all\":100},\"wind\":{\"speed\":5.72,\"deg\":166,\"gust\":5.81},\"visibility\":10000,\"pop\":0.2,\"rain\":{\"3h\":0.13},\"sys\":{\"pod\":\"d\"},\"dt_txt\":\"2021-05-31 18:00:00\"},{\"dt\":1622494800,\"main\":{\"temp\":27.13,\"feels_like\":29.35,\"temp_min\":27.13,\"temp_max\":27.13,\"pressure\":1012,\"sea_level\":1012,\"grnd_level\":1012,\"humidity\":73,\"temp_kf\":0},\"weather\":[{\"id\":500,\"main\":\"Rain\",\"description\":\"light rain\",\"icon\":\"10n\"}],\"clouds\":{\"all\":100},\"wind\":{\"speed\":5.49,\"deg\":166,\"gust\":5.52},\"visibility\":10000,\"pop\":0.2,\"rain\":{\"3h\":0.13},\"sys\":{\"pod\":\"n\"},\"dt_txt\":\"2021-05-31 21:00:00\"},{\"dt\":1622505600,\"main\":{\"temp\":27.14,\"feels_like\":29.28,\"temp_min\":27.14,\"temp_max\":27.14,\"pressure\":1012,\"sea_level\":1012,\"grnd_level\":1012,\"humidity\":72,\"temp_kf\":0},\"weather\":[{\"id\":804,\"main\":\"Clouds\",\"description\":\"overcast clouds\",\"icon\":\"04n\"}],\"clouds\":{\"all\":85},\"wind\":{\"speed\":4.64,\"deg\":163,\"gust\":4.52},\"visibility\":10000,\"pop\":0,\"sys\":{\"pod\":\"n\"},\"dt_txt\":\"2021-06-01 00:00:00\"},{\"dt\":1622516400,\"main\":{\"temp\":26.95,\"feels_like\":29.02,\"temp_min\":26.95,\"temp_max\":26.95,\"pressure\":1010,\"sea_level\":1010,\"grnd_level\":1010,\"humidity\":73,\"temp_kf\":0},\"weather\":[{\"id\":804,\"main\":\"Clouds\",\"description\":\"overcast clouds\",\"icon\":\"04n\"}],\"clouds\":{\"all\":100},\"wind\":{\"speed\":3.9,\"deg\":159,\"gust\":3.7},\"visibility\":10000,\"pop\":0,\"sys\":{\"pod\":\"n\"},\"dt_txt\":\"2021-06-01 03:00:00\"},{\"dt\":1622527200,\"main\":{\"temp\":26.82,\"feels_like\":28.86,\"temp_min\":26.82,\"temp_max\":26.82,\"pressure\":1011,\"sea_level\":1011,\"grnd_level\":1011,\"humidity\":74,\"temp_kf\":0},\"weather\":[{\"id\":804,\"main\":\"Clouds\",\"description\":\"overcast clouds\",\"icon\":\"04d\"}],\"clouds\":{\"all\":100},\"wind\":{\"speed\":3.52,\"deg\":168,\"gust\":3.2},\"visibility\":10000,\"pop\":0,\"sys\":{\"pod\":\"d\"},\"dt_txt\":\"2021-06-01 06:00:00\"},{\"dt\":1622538000,\"main\":{\"temp\":26.77,\"feels_like\":28.85,\"temp_min\":26.77,\"temp_max\":26.77,\"pressure\":1013,\"sea_level\":1013,\"grnd_level\":1013,\"humidity\":75,\"temp_kf\":0},\"weather\":[{\"id\":804,\"main\":\"Clouds\",\"description\":\"overcast clouds\",\"icon\":\"04d\"}],\"clouds\":{\"all\":100},\"wind\":{\"speed\":4.74,\"deg\":173,\"gust\":4.31},\"visibility\":10000,\"pop\":0,\"sys\":{\"pod\":\"d\"},\"dt_txt\":\"2021-06-01 09:00:00\"},{\"dt\":1622548800,\"main\":{\"temp\":26.66,\"feels_like\":26.66,\"temp_min\":26.66,\"temp_max\":26.66,\"pressure\":1011,\"sea_level\":1011,\"grnd_level\":1011,\"humidity\":77,\"temp_kf\":0},\"weather\":[{\"id\":804,\"main\":\"Clouds\",\"description\":\"overcast clouds\",\"icon\":\"04d\"}],\"clouds\":{\"all\":94},\"wind\":{\"speed\":6.47,\"deg\":191,\"gust\":6.3},\"visibility\":10000,\"pop\":0,\"sys\":{\"pod\":\"d\"},\"dt_txt\":\"2021-06-01 12:00:00\"},{\"dt\":1622559600,\"main\":{\"temp\":26.92,\"feels_like\":28.96,\"temp_min\":26.92,\"temp_max\":26.92,\"pressure\":1010,\"sea_level\":1010,\"grnd_level\":1010,\"humidity\":73,\"temp_kf\":0},\"weather\":[{\"id\":804,\"main\":\"Clouds\",\"description\":\"overcast clouds\",\"icon\":\"04d\"}],\"clouds\":{\"all\":100},\"wind\":{\"speed\":6.81,\"deg\":190,\"gust\":7.02},\"visibility\":10000,\"pop\":0,\"sys\":{\"pod\":\"d\"},\"dt_txt\":\"2021-06-01 15:00:00\"},{\"dt\":1622570400,\"main\":{\"temp\":26.88,\"feels_like\":28.97,\"temp_min\":26.88,\"temp_max\":26.88,\"pressure\":1010,\"sea_level\":1010,\"grnd_level\":1010,\"humidity\":74,\"temp_kf\":0},\"weather\":[{\"id\":804,\"main\":\"Clouds\",\"description\":\"overcast clouds\",\"icon\":\"04d\"}],\"clouds\":{\"all\":99},\"wind\":{\"speed\":6.92,\"deg\":176,\"gust\":6.9},\"visibility\":10000,\"pop\":0,\"sys\":{\"pod\":\"d\"},\"dt_txt\":\"2021-06-01 18:00:00\"},{\"dt\":1622581200,\"main\":{\"temp\":26.87,\"feels_like\":28.95,\"temp_min\":26.87,\"temp_max\":26.87,\"pressure\":1012,\"sea_level\":1012,\"grnd_level\":1012,\"humidity\":74,\"temp_kf\":0},\"weather\":[{\"id\":802,\"main\":\"Clouds\",\"description\":\"scattered clouds\",\"icon\":\"03n\"}],\"clouds\":{\"all\":31},\"wind\":{\"speed\":6.38,\"deg\":166,\"gust\":6.12},\"visibility\":10000,\"pop\":0,\"sys\":{\"pod\":\"n\"},\"dt_txt\":\"2021-06-01 21:00:00\"},{\"dt\":1622592000,\"main\":{\"temp\":26.61,\"feels_like\":26.61,\"temp_min\":26.61,\"temp_max\":26.61,\"pressure\":1011,\"sea_level\":1011,\"grnd_level\":1011,\"humidity\":77,\"temp_kf\":0},\"weather\":[{\"id\":802,\"main\":\"Clouds\",\"description\":\"scattered clouds\",\"icon\":\"03n\"}],\"clouds\":{\"all\":49},\"wind\":{\"speed\":7.62,\"deg\":161,\"gust\":7.6},\"visibility\":10000,\"pop\":0,\"sys\":{\"pod\":\"n\"},\"dt_txt\":\"2021-06-02 00:00:00\"},{\"dt\":1622602800,\"main\":{\"temp\":26.43,\"feels_like\":26.43,\"temp_min\":26.43,\"temp_max\":26.43,\"pressure\":1011,\"sea_level\":1011,\"grnd_level\":1011,\"humidity\":76,\"temp_kf\":0},\"weather\":[{\"id\":500,\"main\":\"Rain\",\"description\":\"light rain\",\"icon\":\"10n\"}],\"clouds\":{\"all\":45},\"wind\":{\"speed\":5.5,\"deg\":165,\"gust\":5.52},\"visibility\":10000,\"pop\":0.2,\"rain\":{\"3h\":0.13},\"sys\":{\"pod\":\"n\"},\"dt_txt\":\"2021-06-02 03:00:00\"},{\"dt\":1622613600,\"main\":{\"temp\":26.51,\"feels_like\":26.51,\"temp_min\":26.51,\"temp_max\":26.51,\"pressure\":1012,\"sea_level\":1012,\"grnd_level\":1012,\"humidity\":77,\"temp_kf\":0},\"weather\":[{\"id\":500,\"main\":\"Rain\",\"description\":\"light rain\",\"icon\":\"10d\"}],\"clouds\":{\"all\":72},\"wind\":{\"speed\":5.96,\"deg\":158,\"gust\":6.02},\"visibility\":10000,\"pop\":0.2,\"rain\":{\"3h\":0.19},\"sys\":{\"pod\":\"d\"},\"dt_txt\":\"2021-06-02 06:00:00\"},{\"dt\":1622624400,\"main\":{\"temp\":26.83,\"feels_like\":29.04,\"temp_min\":26.83,\"temp_max\":26.83,\"pressure\":1013,\"sea_level\":1013,\"grnd_level\":1013,\"humidity\":76,\"temp_kf\":0},\"weather\":[{\"id\":500,\"main\":\"Rain\",\"description\":\"light rain\",\"icon\":\"10d\"}],\"clouds\":{\"all\":100},\"wind\":{\"speed\":6.35,\"deg\":172,\"gust\":6.6},\"visibility\":10000,\"pop\":0.24,\"rain\":{\"3h\":0.13},\"sys\":{\"pod\":\"d\"},\"dt_txt\":\"2021-06-02 09:00:00\"},{\"dt\":1622635200,\"main\":{\"temp\":26.67,\"feels_like\":28.73,\"temp_min\":26.67,\"temp_max\":26.67,\"pressure\":1012,\"sea_level\":1012,\"grnd_level\":1012,\"humidity\":76,\"temp_kf\":0},\"weather\":[{\"id\":804,\"main\":\"Clouds\",\"description\":\"overcast clouds\",\"icon\":\"04d\"}],\"clouds\":{\"all\":100},\"wind\":{\"speed\":6.03,\"deg\":175,\"gust\":6.02},\"visibility\":10000,\"pop\":0,\"sys\":{\"pod\":\"d\"},\"dt_txt\":\"2021-06-02 12:00:00\"},{\"dt\":1622646000,\"main\":{\"temp\":26.61,\"feels_like\":26.61,\"temp_min\":26.61,\"temp_max\":26.61,\"pressure\":1011,\"sea_level\":1011,\"grnd_level\":1011,\"humidity\":76,\"temp_kf\":0},\"weather\":[{\"id\":804,\"main\":\"Clouds\",\"description\":\"overcast clouds\",\"icon\":\"04d\"}],\"clouds\":{\"all\":100},\"wind\":{\"speed\":6.1,\"deg\":169,\"gust\":6.02},\"visibility\":10000,\"pop\":0,\"sys\":{\"pod\":\"d\"},\"dt_txt\":\"2021-06-02 15:00:00\"},{\"dt\":1622656800,\"main\":{\"temp\":26.67,\"feels_like\":28.66,\"temp_min\":26.67,\"temp_max\":26.67,\"pressure\":1012,\"sea_level\":1012,\"grnd_level\":1012,\"humidity\":75,\"temp_kf\":0},\"weather\":[{\"id\":804,\"main\":\"Clouds\",\"description\":\"overcast clouds\",\"icon\":\"04d\"}],\"clouds\":{\"all\":97},\"wind\":{\"speed\":5.56,\"deg\":172,\"gust\":5.64},\"visibility\":10000,\"pop\":0,\"sys\":{\"pod\":\"d\"},\"dt_txt\":\"2021-06-02 18:00:00\"},{\"dt\":1622667600,\"main\":{\"temp\":26.59,\"feels_like\":26.59,\"temp_min\":26.59,\"temp_max\":26.59,\"pressure\":1013,\"sea_level\":1013,\"grnd_level\":1013,\"humidity\":76,\"temp_kf\":0},\"weather\":[{\"id\":802,\"main\":\"Clouds\",\"description\":\"scattered clouds\",\"icon\":\"03n\"}],\"clouds\":{\"all\":42},\"wind\":{\"speed\":6.76,\"deg\":169,\"gust\":7},\"visibility\":10000,\"pop\":0,\"sys\":{\"pod\":\"n\"},\"dt_txt\":\"2021-06-02 21:00:00\"},{\"dt\":1622678400,\"main\":{\"temp\":26.66,\"feels_like\":26.66,\"temp_min\":26.66,\"temp_max\":26.66,\"pressure\":1011,\"sea_level\":1011,\"grnd_level\":1011,\"humidity\":77,\"temp_kf\":0},\"weather\":[{\"id\":801,\"main\":\"Clouds\",\"description\":\"few clouds\",\"icon\":\"02n\"}],\"clouds\":{\"all\":24},\"wind\":{\"speed\":6.28,\"deg\":170,\"gust\":7.21},\"visibility\":10000,\"pop\":0,\"sys\":{\"pod\":\"n\"},\"dt_txt\":\"2021-06-03 00:00:00\"},{\"dt\":1622689200,\"main\":{\"temp\":26.47,\"feels_like\":26.47,\"temp_min\":26.47,\"temp_max\":26.47,\"pressure\":1011,\"sea_level\":1011,\"grnd_level\":1011,\"humidity\":78,\"temp_kf\":0},\"weather\":[{\"id\":500,\"main\":\"Rain\",\"description\":\"light rain\",\"icon\":\"10n\"}],\"clouds\":{\"all\":72},\"wind\":{\"speed\":5.77,\"deg\":168,\"gust\":5.92},\"visibility\":10000,\"pop\":0.2,\"rain\":{\"3h\":0.13},\"sys\":{\"pod\":\"n\"},\"dt_txt\":\"2021-06-03 03:00:00\"},{\"dt\":1622700000,\"main\":{\"temp\":26.41,\"feels_like\":26.41,\"temp_min\":26.41,\"temp_max\":26.41,\"pressure\":1012,\"sea_level\":1012,\"grnd_level\":1012,\"humidity\":77,\"temp_kf\":0},\"weather\":[{\"id\":500,\"main\":\"Rain\",\"description\":\"light rain\",\"icon\":\"10d\"}],\"clouds\":{\"all\":86},\"wind\":{\"speed\":5.16,\"deg\":170,\"gust\":5.4},\"visibility\":10000,\"pop\":0.2,\"rain\":{\"3h\":0.25},\"sys\":{\"pod\":\"d\"},\"dt_txt\":\"2021-06-03 06:00:00\"},{\"dt\":1622710800,\"main\":{\"temp\":26.48,\"feels_like\":26.48,\"temp_min\":26.48,\"temp_max\":26.48,\"pressure\":1014,\"sea_level\":1014,\"grnd_level\":1014,\"humidity\":77,\"temp_kf\":0},\"weather\":[{\"id\":500,\"main\":\"Rain\",\"description\":\"light rain\",\"icon\":\"10d\"}],\"clouds\":{\"all\":100},\"wind\":{\"speed\":4.9,\"deg\":163,\"gust\":5.01},\"visibility\":10000,\"pop\":0.2,\"rain\":{\"3h\":0.19},\"sys\":{\"pod\":\"d\"},\"dt_txt\":\"2021-06-03 09:00:00\"},{\"dt\":1622721600,\"main\":{\"temp\":26.89,\"feels_like\":28.99,\"temp_min\":26.89,\"temp_max\":26.89,\"pressure\":1013,\"sea_level\":1013,\"grnd_level\":1013,\"humidity\":74,\"temp_kf\":0},\"weather\":[{\"id\":804,\"main\":\"Clouds\",\"description\":\"overcast clouds\",\"icon\":\"04d\"}],\"clouds\":{\"all\":100},\"wind\":{\"speed\":5.05,\"deg\":154,\"gust\":5.12},\"visibility\":10000,\"pop\":0,\"sys\":{\"pod\":\"d\"},\"dt_txt\":\"2021-06-03 12:00:00\"},{\"dt\":1622732400,\"main\":{\"temp\":26.83,\"feels_like\":28.96,\"temp_min\":26.83,\"temp_max\":26.83,\"pressure\":1011,\"sea_level\":1011,\"grnd_level\":1011,\"humidity\":75,\"temp_kf\":0},\"weather\":[{\"id\":804,\"main\":\"Clouds\",\"description\":\"overcast clouds\",\"icon\":\"04d\"}],\"clouds\":{\"all\":100},\"wind\":{\"speed\":4.97,\"deg\":151,\"gust\":5.01},\"visibility\":10000,\"pop\":0,\"sys\":{\"pod\":\"d\"},\"dt_txt\":\"2021-06-03 15:00:00\"},{\"dt\":1622743200,\"main\":{\"temp\":26.79,\"feels_like\":28.96,\"temp_min\":26.79,\"temp_max\":26.79,\"pressure\":1012,\"sea_level\":1012,\"grnd_level\":1012,\"humidity\":76,\"temp_kf\":0},\"weather\":[{\"id\":804,\"main\":\"Clouds\",\"description\":\"overcast clouds\",\"icon\":\"04d\"}],\"clouds\":{\"all\":100},\"wind\":{\"speed\":5.5,\"deg\":157,\"gust\":5.52},\"visibility\":10000,\"pop\":0,\"sys\":{\"pod\":\"d\"},\"dt_txt\":\"2021-06-03 18:00:00\"},{\"dt\":1622754000,\"main\":{\"temp\":26.72,\"feels_like\":28.83,\"temp_min\":26.72,\"temp_max\":26.72,\"pressure\":1014,\"sea_level\":1014,\"grnd_level\":1014,\"humidity\":76,\"temp_kf\":0},\"weather\":[{\"id\":804,\"main\":\"Clouds\",\"description\":\"overcast clouds\",\"icon\":\"04n\"}],\"clouds\":{\"all\":100},\"wind\":{\"speed\":5.19,\"deg\":156,\"gust\":5.31},\"visibility\":10000,\"pop\":0,\"sys\":{\"pod\":\"n\"},\"dt_txt\":\"2021-06-03 21:00:00\"},{\"dt\":1622764800,\"main\":{\"temp\":26.64,\"feels_like\":26.64,\"temp_min\":26.64,\"temp_max\":26.64,\"pressure\":1013,\"sea_level\":1013,\"grnd_level\":1013,\"humidity\":75,\"temp_kf\":0},\"weather\":[{\"id\":804,\"main\":\"Clouds\",\"description\":\"overcast clouds\",\"icon\":\"04n\"}],\"clouds\":{\"all\":99},\"wind\":{\"speed\":4.86,\"deg\":159,\"gust\":5.12},\"visibility\":10000,\"pop\":0,\"sys\":{\"pod\":\"n\"},\"dt_txt\":\"2021-06-04 00:00:00\"},{\"dt\":1622775600,\"main\":{\"temp\":26.55,\"feels_like\":26.55,\"temp_min\":26.55,\"temp_max\":26.55,\"pressure\":1011,\"sea_level\":1011,\"grnd_level\":1011,\"humidity\":75,\"temp_kf\":0},\"weather\":[{\"id\":804,\"main\":\"Clouds\",\"description\":\"overcast clouds\",\"icon\":\"04n\"}],\"clouds\":{\"all\":100},\"wind\":{\"speed\":6.1,\"deg\":174,\"gust\":6.31},\"visibility\":10000,\"pop\":0,\"sys\":{\"pod\":\"n\"},\"dt_txt\":\"2021-06-04 03:00:00\"},{\"dt\":1622786400,\"main\":{\"temp\":26.52,\"feels_like\":26.52,\"temp_min\":26.52,\"temp_max\":26.52,\"pressure\":1012,\"sea_level\":1012,\"grnd_level\":1012,\"humidity\":77,\"temp_kf\":0},\"weather\":[{\"id\":804,\"main\":\"Clouds\",\"description\":\"overcast clouds\",\"icon\":\"04d\"}],\"clouds\":{\"all\":99},\"wind\":{\"speed\":5.95,\"deg\":169,\"gust\":5.81},\"visibility\":10000,\"pop\":0,\"sys\":{\"pod\":\"d\"},\"dt_txt\":\"2021-06-04 06:00:00\"},{\"dt\":1622797200,\"main\":{\"temp\":26.53,\"feels_like\":26.53,\"temp_min\":26.53,\"temp_max\":26.53,\"pressure\":1014,\"sea_level\":1014,\"grnd_level\":1014,\"humidity\":76,\"temp_kf\":0},\"weather\":[{\"id\":804,\"main\":\"Clouds\",\"description\":\"overcast clouds\",\"icon\":\"04d\"}],\"clouds\":{\"all\":87},\"wind\":{\"speed\":5.62,\"deg\":172,\"gust\":5.42},\"visibility\":10000,\"pop\":0,\"sys\":{\"pod\":\"d\"},\"dt_txt\":\"2021-06-04 09:00:00\"},{\"dt\":1622808000,\"main\":{\"temp\":26.51,\"feels_like\":26.51,\"temp_min\":26.51,\"temp_max\":26.51,\"pressure\":1014,\"sea_level\":1014,\"grnd_level\":1014,\"humidity\":77,\"temp_kf\":0},\"weather\":[{\"id\":803,\"main\":\"Clouds\",\"description\":\"broken clouds\",\"icon\":\"04d\"}],\"clouds\":{\"all\":67},\"wind\":{\"speed\":5.27,\"deg\":157,\"gust\":5.02},\"visibility\":10000,\"pop\":0,\"sys\":{\"pod\":\"d\"},\"dt_txt\":\"2021-06-04 12:00:00\"},{\"dt\":1622818800,\"main\":{\"temp\":26.46,\"feels_like\":26.46,\"temp_min\":26.46,\"temp_max\":26.46,\"pressure\":1012,\"sea_level\":1012,\"grnd_level\":1012,\"humidity\":77,\"temp_kf\":0},\"weather\":[{\"id\":803,\"main\":\"Clouds\",\"description\":\"broken clouds\",\"icon\":\"04d\"}],\"clouds\":{\"all\":61},\"wind\":{\"speed\":4.94,\"deg\":159,\"gust\":4.8},\"visibility\":10000,\"pop\":0,\"sys\":{\"pod\":\"d\"},\"dt_txt\":\"2021-06-04 15:00:00\"},{\"dt\":1622829600,\"main\":{\"temp\":26.44,\"feels_like\":26.44,\"temp_min\":26.44,\"temp_max\":26.44,\"pressure\":1012,\"sea_level\":1012,\"grnd_level\":1012,\"humidity\":78,\"temp_kf\":0},\"weather\":[{\"id\":802,\"main\":\"Clouds\",\"description\":\"scattered clouds\",\"icon\":\"03d\"}],\"clouds\":{\"all\":42},\"wind\":{\"speed\":4.94,\"deg\":167,\"gust\":5.2},\"visibility\":10000,\"pop\":0,\"sys\":{\"pod\":\"d\"},\"dt_txt\":\"2021-06-04 18:00:00\"}],\"city\":{\"id\":6295630,\"name\":\"Globe\",\"coord\":{},\"country\":\"\",\"population\":2147483647,\"timezone\":0,\"sunrise\":1622354049,\"sunset\":1622397678}}"));
      });

      final result = await mockWeatherApiProvider.fetchWeatherForecast(0, 0);
      assert(result.city != null, true);
      assert(result.list?.isNotEmpty == true, true);
    });

    test("Fetch weather forecast returns connection error", () async {
      dioAdapter.onGet(
          "https://api.openweathermap.org/data/2.5/forecast?lat=0.0&lon=0.0&apiKey=${ApplicationConfig.apiKey}&units=metric",
          (request) {
        request.reply(400, "Error");
      });
      final result = await mockWeatherApiProvider.fetchWeather(0, 0);
      assert(result.errorCode == ApplicationError.connectionError, true);
    });

    test("Fetch weather forecast returns api error", () async {
      dioAdapter.onGet(
          "https://api.openweathermap.org/data/2.5/forecast?lat=0.0&lon=0.0&apiKey=${ApplicationConfig.apiKey}&units=metric",
          (request) {
        request.reply(201, "Error");
      });
      final result = await mockWeatherApiProvider.fetchWeather(0, 0);
      assert(result.errorCode == ApplicationError.connectionError, true);
    });
  });

  group("Real fetch weather", () {
    WeatherResponse? response;

    setUpAll(() async {
      response = await weatherApiProvider.fetchWeather(0, 0);
    });

    test("Weather object not null", () {
      expect(response != null, true);
    });

    test("Weather system object not null and not empty", () {
      final System system = response!.system!;
      expect(system.sunset != null, true);
      expect(system.sunrise != null, true);
      expect(system.sunrise! > 0, true);
      expect(system.sunset! > 0, true);
    });

    test("Weather main data object not null and not empty", () {
      final MainWeatherData mainWeatherData = response!.mainWeatherData!;
      expect(mainWeatherData.pressure > 0, true);
      expect(mainWeatherData.temp > 0, true);
      expect(mainWeatherData.humidity > 0, true);
      expect(mainWeatherData.tempMax > 0, true);
      expect(mainWeatherData.tempMin > 0, true);
    });

    test("Overall weather data object not null and not empty", () {
      final List<OverallWeatherData> overallWeatherDataList =
          response!.overallWeatherData!;
      expect(overallWeatherDataList.isNotEmpty, true);
      for (final OverallWeatherData overallWeatherData
          in overallWeatherDataList) {
        expect(overallWeatherData.id != null, true);
        expect(overallWeatherData.description != null, true);
        expect(overallWeatherData.icon != null, true);
        expect(overallWeatherData.main != null, true);
      }
    });

    test("Wind weather data object not null and not empty", () {
      final Wind wind = response!.wind!;
      expect(wind.deg >= 0 && wind.deg <= 360, true);
      expect(wind.speed >= 0, true);
    });

    test("Clouds weather data object not null and not empty", () {
      final Clouds clouds = response!.clouds!;
      expect(clouds.all != null, true);
    });

    test("Coordinates weather data object not null and not empty", () {
      final Coordinates coord = response!.cord!;
      expect(coord.longitude >= -180 && coord.longitude <= 180, true);
      expect(coord.latitude >= -180 && coord.latitude <= 180, true);
    });

    test("General weather data not null and not empty", () {
      expect(response!.id != null, true);
      expect(response!.name != null, true);
      expect(response!.cod != null, true);
    });
  });

  group("Real fetch weather forecast", () {
    WeatherForecastListResponse? response;
    late WeatherForecastResponse forecastResponse;

    setUpAll(() async {
      response = await weatherApiProvider.fetchWeatherForecast(0, 0);
      forecastResponse = response!.list![0];
    });

    test("Weather forecast object not null and not empty", () {
      expect(response != null, true);
      expect(response!.list != null, true);
      expect(response!.list!.isNotEmpty, true);
    });

    test("Weather forecast city object not null and not empty", () {
      expect(response!.city != null, true);
      expect(response!.city!.name != null, true);
      expect(response!.city!.id != null, true);
    });

    test("Weather forecast element object not null and not empty", () {
      expect(forecastResponse.overallWeatherData != null, true);
      expect(forecastResponse.clouds != null, true);
      expect(forecastResponse.wind != null, true);
      expect(forecastResponse.mainWeatherData != null, true);
      expect(forecastResponse.snow != null, true);
      expect(forecastResponse.rain != null, true);
    });

    test(
        "Weather forecast element object overall weather data not null and not empty",
        () {
      final List<OverallWeatherData> overallWeatherDataList =
          forecastResponse.overallWeatherData!;
      expect(overallWeatherDataList.isNotEmpty, true);
      for (final OverallWeatherData overallWeatherData
          in overallWeatherDataList) {
        expect(overallWeatherData.id != null, true);
        expect(overallWeatherData.description != null, true);
        expect(overallWeatherData.icon != null, true);
        expect(overallWeatherData.main != null, true);
      }
    });

    test(
        "Weather forecast element object main data object not null and not empty",
        () {
      final MainWeatherData mainWeatherData = forecastResponse.mainWeatherData!;
      expect(mainWeatherData.pressure > 0, true);
      expect(mainWeatherData.temp > 0, true);
      expect(mainWeatherData.humidity > 0, true);
      expect(mainWeatherData.tempMax > 0, true);
      expect(mainWeatherData.tempMin > 0, true);
    });

    test("Weather forecast element object wind not null and not empty", () {
      final Wind wind = forecastResponse.wind!;
      expect(wind.deg >= 0 && wind.deg <= 360, true);
      expect(wind.speed >= 0, true);
    });

    test("Weather forecast element object clouds not null and not empty", () {
      final Clouds clouds = forecastResponse.clouds!;
      expect(clouds.all != null, true);
    });
  });
}
