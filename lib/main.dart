import 'package:feather/src/blocs/application_bloc.dart';
import 'package:feather/src/resources/config/application_config.dart';
import 'package:feather/src/resources/application_localization_delegate.dart';
import 'package:feather/src/ui/screen/weather_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:logging/logging.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  MyApp(){
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setEnabledSystemUIOverlays([]);
    _configureLogger();
    applicationBloc.loadSavedUnit();
    applicationBloc.loadSavedRefreshTime();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WeatherMainScreen(),
      debugShowCheckedModeBanner: false,
      theme: _configureThemeData(),
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

  _configureLogger() {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((LogRecord rec) {
      if (ApplicationConfig.isDebug) {
        print(
            '[${rec.level.name}][${rec.time}][${rec.loggerName}]: ${rec.message}');
      }
    });
  }

  ThemeData _configureThemeData() {
    return ThemeData(
        textTheme: TextTheme(
            headline: TextStyle(fontSize: 60.0, color: Colors.white),
            title: TextStyle(fontSize: 35, color: Colors.white),
            subtitle: TextStyle(fontSize: 20, color: Colors.white),
            body1: TextStyle(fontSize: 15, color: Colors.white),
            body2: TextStyle(fontSize: 12, color: Colors.white)));
  }
}
