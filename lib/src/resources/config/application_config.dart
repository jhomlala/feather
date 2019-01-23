class ApplicationConfig{
  static final String apiUrl = "https://api.openweathermap.org/data/2.5";
  static final String apiWeatherEndpoint = "/weather";
  static final String apiWeatherForecastEndpoint = "/forecast";
  static final String apiKey = "2b557cc4c291a6293e22bc44e49231d8";
  static final bool isDebug = bool.fromEnvironment("dart.vm.product") == false;
}