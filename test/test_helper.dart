import 'package:feather/src/resources/application_localization_delegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class TestHelper{
  static wrapWidgetWithLocalizationApp(Widget widget){
    return MaterialApp(
      home: Container(child:widget),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        const ApplicationLocalizationDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale("en"),
        const Locale("pl"),
      ],
    );
  }
}