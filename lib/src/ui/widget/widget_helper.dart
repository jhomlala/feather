import 'package:feather/src/data/model/internal/application_error.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:feather/src/resources/config/application_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WidgetHelper {
  static LinearGradient buildGradient(Color startColor, Color endColor) {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: const [0.2, 0.99],
      colors: [
        // Colors are easy thanks to Flutter's Colors class.
        startColor,
        endColor,
      ],
    );
  }

  static Widget buildErrorWidget(
      {required BuildContext context,
      ApplicationError? applicationError,
      VoidCallback? voidCallback,
      required bool withRetryButton}) {
    String? errorText = "";
    final localization = AppLocalizations.of(context)!;
    if (applicationError == ApplicationError.locationNotSelectedError) {
      errorText = localization.error_location_not_selected;
    } else if (applicationError == ApplicationError.connectionError) {
      errorText = localization.error_server_connection;
    } else if (applicationError == ApplicationError.apiError) {
      errorText = localization.error_api;
    } else {
      errorText = localization.error_unknown;
    }
    final List<Widget> widgets = [];
    widgets.add(Text(
      errorText,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    ));
    if (withRetryButton) {
      widgets.add(
        TextButton(
          onPressed: voidCallback,
          child: Text(localization.retry,
              style: Theme.of(context).textTheme.subtitle2),
        ),
      );
    }

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Center(
        key: const Key("error_widget"),
        child: SizedBox(
          width: 250,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center, children: widgets),
        ),
      ),
    );
  }

  static LinearGradient buildGradientBasedOnDayCycle(int sunrise, int sunset) {
    final DateTime now = DateTime.now();
    final int nowMs = now.millisecondsSinceEpoch;
    final int sunriseMs = sunrise * 1000;
    final int sunsetMs = sunset * 1000;

    if (nowMs < sunriseMs) {
      final int lastMidnight =
          DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;
      return getNightGradient((sunriseMs - nowMs) / (sunriseMs - lastMidnight));
    } else if (nowMs > sunsetMs) {
      final int nextMidnight =
          DateTime(now.year, now.month, now.day + 1).millisecondsSinceEpoch;
      return getNightGradient((nowMs - sunsetMs) / (nextMidnight - sunsetMs));
    } else {
      return getDayGradient((nowMs - sunriseMs) / (sunsetMs - sunriseMs));
    }
  }

  static LinearGradient getNightGradient(double percentage) {
    if (percentage <= 0.1) {
      return buildGradient(ApplicationColors.dawnDuskStartColor,
          ApplicationColors.dawnDuskEndColor);
    } else if (percentage <= 0.2) {
      return buildGradient(ApplicationColors.twilightStartColor,
          ApplicationColors.twilightEndColor);
    } else if (percentage <= 0.6) {
      return buildGradient(
          ApplicationColors.nightStartColor, ApplicationColors.nightEndColor);
    } else {
      return buildGradient(ApplicationColors.midnightStartColor,
          ApplicationColors.midnightEndColor);
    }
  }

  static LinearGradient getDayGradient(double percentage) {
    if (percentage <= 0.1 || percentage >= 0.9) {
      return buildGradient(ApplicationColors.dawnDuskStartColor,
          ApplicationColors.dawnDuskEndColor);
    } else if (percentage <= 0.2 || percentage >= 0.8) {
      return buildGradient(ApplicationColors.morningEveStartColor,
          ApplicationColors.morningEveEndColor);
    } else if (percentage <= 0.4 || percentage >= 0.6) {
      return buildGradient(
          ApplicationColors.dayStartColor, ApplicationColors.dayEndColor);
    } else {
      return buildGradient(
          ApplicationColors.middayStartColor, ApplicationColors.middayEndColor);
    }
  }

  static LinearGradient getGradient(
      {int? sunriseTime = 0, int? sunsetTime = 0}) {
    if (sunriseTime == 0 && sunsetTime == 0) {
      return buildGradient(ApplicationColors.midnightStartColor,
          ApplicationColors.midnightEndColor);
    } else {
      return buildGradientBasedOnDayCycle(sunriseTime!, sunsetTime!);
    }
  }
}
