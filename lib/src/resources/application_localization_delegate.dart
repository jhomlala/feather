import 'package:feather/src/resources/application_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class ApplicationLocalizationDelegate extends LocalizationsDelegate<ApplicationLocalization>{

  const ApplicationLocalizationDelegate();
  @override
  bool isSupported(Locale locale) {
    return ['en',"pl"].contains(locale.languageCode);
  }
  

  @override
  bool shouldReload(LocalizationsDelegate old) {
   return false;
  }

  @override
  Future<ApplicationLocalization> load(Locale locale) {
    return SynchronousFuture<ApplicationLocalization>(ApplicationLocalization(locale));
  }

}