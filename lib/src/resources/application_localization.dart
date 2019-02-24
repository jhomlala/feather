import 'dart:ui';

import 'package:flutter/widgets.dart';

class ApplicationLocalization {
  final Locale locale;

  ApplicationLocalization(this.locale);

  static ApplicationLocalization of(BuildContext context) {
    return Localizations.of<ApplicationLocalization>(
        context, ApplicationLocalization);
  }

  static Map<String, Map<String, String>> _localizedValues = {
    'pl': {
      "error_location_not_selected":
          "Nie udało się pobrać lokalizacji. Sprawdź czy nadałeś aplikacji odpowiednie pozwolenia.",
      "error_server_conntection":
          "Nie udało się połączyć z serwerem. Sprawdź połączenie internetowe.",
      "error_api": "Błąd serwera. Skontaktuj się z deweloperem",
      "error_unknown": "Nieznany błąd. Skontaktuj się z deweloperem.",
      "pressure": "Ciśnienie",
      "rain": "Opady",
      "temperature": "Temperatura",
      "wind": "Wiatr",
      "day": "Dzień",
      "sunset": "Zachód słońca",
      "sunrise": "Wschód słońca",
      "sunset_in": "Zachód słońca za",
      "sunrise_in": "Wschód słońca za",
      "night": "Noc",
      "chart_unavailable": "Wykres niedostępny",
      "retry": "Spróbuj ponownie",
      "your_location": "Twoja lokalizacja",
      "humidity": "Wilgotność",
      "units": "Jednostki",
      "metric": "Metryczne",
      "imperial": "Imperialne",
      "units_description": "Typ jednostek (metryczne/imperialne)",
      "refresh_time": "Czas odświeżania",
      "refresh_time_description":
          "Interwał pomiędzy kolejnymi zapytaniami do serwisu pogody",
      "minutes": "minut",
      "last_refresh_time": "Ostatnie odświeżenie",
      "settings": "Ustawienia",
      "about": "O aplikacji",
      "contributors":"Współtwórcy",
      "credits":"Podziękowania",
      "weather_data":"Dane pogodowe: OpenWeatherAPI",
      "icon_data":"Ikony: Icons8, Freepik/Flaticon"
    },
    'en': {
      "error_location_not_selected":
          "Couldn't select your location. Please make sure that you have given location permission.",
      "error_server_connection":
          "Couldn't connect to server. Please check your internet connection.",
      "error_api": "Server error. Please contact with developer.",
      "error_unknown": "Unknown error. Please contact with developer.",
      "pressure": "Pressure",
      "rain": "Rain",
      "temperature": "Temperature",
      "wind": "Wind",
      "day": "Day",
      "sunset": "Sunset",
      "sunrise": "Sunrise",
      "sunset_in": "Sunset in",
      "sunrise_in": "Sunrise in",
      "night": "Night",
      "chart_unavailable": "Chart unavailable",
      "retry": "Retry",
      "your_location": "Your location",
      "humidity": "Humidity",
      "units": "Units",
      "metric": "Metric",
      "imperial": "Imperial",
      "units_description": "Type of units (metric/imperial)",
      "refresh_time": "Refresh time",
      "refresh_time_description": "Interval between calls to weather service",
      "minutes": "minutes",
      "last_refresh_time": "Last refresh time",
      "settings": "Settings",
      "about": "About",
      "contributors":"Contributors",
      "credits":"Credits",
      "weather_data":"Weather data: OpenWeatherAPI",
      "icon_data":"Icons: Icons8, Freepik/Flaticon"
    },
  };

  String getText(String tag) {
    if (_localizedValues.containsKey(locale.languageCode) &&
        _localizedValues[locale.languageCode].containsKey(tag)) {
      return _localizedValues[locale.languageCode][tag];
    } else {
      return "???";
    }
  }
}
