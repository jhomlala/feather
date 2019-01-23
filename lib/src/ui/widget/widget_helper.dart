import 'dart:async';

import 'package:feather/src/models/internal/application_error.dart';
import 'package:feather/src/models/internal/pair.dart';
import 'package:feather/src/resources/config/app_const.dart';
import 'package:feather/src/resources/config/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

class WidgetHelper {
  static Padding buildPadding(
      {double left = 0, double top = 0, double right = 0, double bottom = 0}) {
    return Padding(
        padding: buildEdgeInsets(
            left: left, top: top, right: right, bottom: bottom));
  }

  static EdgeInsets buildEdgeInsets(
      {double left = 0, double top = 0, double right = 0, double bottom = 0}) {
    return EdgeInsets.fromLTRB(left, top, right, bottom);
  }

  static LinearGradient buildGradient(Color startColor, Color endColor) {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: [0.2, 0.99],
      colors: [
        // Colors are easy thanks to Flutter's Colors class.
        startColor,
        endColor,
      ],
    );
  }

  static Widget buildProgressIndicator() {
    return Center(
        key: Key("progress_indicator"),
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
        ));
  }

  static Widget buildErrorWidget(BuildContext context,
      ApplicationError applicationError, VoidCallback voidCallback) {
    String errorText = "";
    if (applicationError == ApplicationError.locationNotSelectedError) {
      errorText = Strings.errorLocationNotSelected;
    } else if (applicationError == ApplicationError.connectionError) {
      errorText = Strings.errorServerConnection;
    } else if (applicationError == ApplicationError.apiError) {
      errorText = Strings.errorServer;
    } else {
      errorText = Strings.unknownError;
    }
    return Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
            key: Key("error_widget"),
            child: SizedBox(
                width: 250,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      errorText,
                      textDirection: TextDirection.ltr,
                      textAlign: TextAlign.center,
                    ),
                    FlatButton(
                      child: Text("Retry",
                          style: Theme.of(context).textTheme.subtitle),
                      onPressed: voidCallback,
                    )
                  ],
                ))));
  }

  static LinearGradient buildGradientBasedOnDayCycle(int sunrise, int sunset) {
    int currentTime = DateTime.now().millisecondsSinceEpoch;
    int sunriseMs = sunrise * 1000;
    int sunsetMs = sunset * 1000;
    if (currentTime > sunriseMs && currentTime < sunsetMs) {
      return buildGradient(
          AppConst.dayStartGradientColor, AppConst.dayEndGradientColor);
    } else {
      return buildGradient(
          AppConst.nightStartGradientColor, AppConst.nightEndGradient);
    }
  }

  static LinearGradient getGradient({sunriseTime = 0, sunsetTime = 0}) {
    if (sunriseTime == 0 && sunsetTime == 0) {
      return WidgetHelper.buildGradient(
          AppConst.nightStartGradientColor, AppConst.nightEndGradient);
    } else {
      return buildGradientBasedOnDayCycle(sunriseTime, sunsetTime);
    }
  }

  static AnimationController getAnimationController(
      SingleTickerProviderStateMixin object, int duration) {
    return AnimationController(
        duration: Duration(milliseconds: duration), vsync: object);
  }

  static Animation _getCurvedAnimation(
      AnimationController controller, Curve curve) {
    return CurvedAnimation(parent: controller, curve: curve);
  }

  static Animation<double> _getTween(
      double start, double end, Animation animation, VoidCallback callback) {
    print("tween start: " + start.toString() + " tween end: " + end.toString());
    return Tween(begin: 0.0, end: 10.0).animate(animation)
      ..addListener(callback);
  }

  static AnimationController animate(
      {@required SingleTickerProviderStateMixin tickerProvider,
      double start,
      double end,
      int duration,
      Curve curve,
      VoidCallback callback}) {
    AnimationController controller =
        getAnimationController(tickerProvider, duration);
    Animation animation = _getCurvedAnimation(controller, curve);
    _getTween(start, end, animation, callback);
    controller.forward();
    return controller;
  }


  static Observable<double> animate2(
      {@required SingleTickerProviderStateMixin tickerProvider,
        double start,
        double end,
        int duration,
        Curve curve,
        VoidCallback callback}) {
    AnimationController controller =
    getAnimationController(tickerProvider, duration);
    Animation animation = _getCurvedAnimation(controller, curve);
    var streamController = StreamController<double>();

    Observable<double> observable = Observable<double>(streamController.stream);

    var callback2 = () =>
      print("Value!: " + animation.value)
      //treamController.sink.add(animation.value);
    ;
    _getTween(start, end, animation, callback2);
    print("Started");
    controller.forward();
    return observable;
  }



}
