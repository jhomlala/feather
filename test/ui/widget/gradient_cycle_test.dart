import 'package:feather/src/resources/config/application_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  LinearGradient buildGradient(Color startColor, Color endColor) {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: const [0.2, 0.99],
      colors: [
        startColor,
        endColor,
      ],
    );
  }

  LinearGradient getNightGradient(double percentage) {
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

  LinearGradient getDayGradient(double percentage) {
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

  LinearGradient testGradientCycle(int testHour, int testMinutes) {
    final DateTime testDate = DateTime.now();
    final int testMs = DateTime(
            testDate.year, testDate.month, testDate.day, testHour, testMinutes)
        .millisecondsSinceEpoch;
    // Test sunrise is at 08:00
    final int sunriseMs =
        DateTime(testDate.year, testDate.month, testDate.day, 8)
            .millisecondsSinceEpoch;
    // Test sunset is at 18:00
    final int sunsetMs =
        DateTime(testDate.year, testDate.month, testDate.day, 18)
            .millisecondsSinceEpoch;

    if (testMs < sunriseMs) {
      final int lastMidnight =
          DateTime(testDate.year, testDate.month, testDate.day)
              .millisecondsSinceEpoch;
      return getNightGradient(
          (sunriseMs - testMs) / (sunriseMs - lastMidnight));
    } else if (testMs > sunsetMs) {
      final int nextMidnight =
          DateTime(testDate.year, testDate.month, testDate.day + 1)
              .millisecondsSinceEpoch;
      return getNightGradient((testMs - sunsetMs) / (nextMidnight - sunsetMs));
    } else {
      return getDayGradient((testMs - sunriseMs) / (sunsetMs - sunriseMs));
    }
  }

  test('testing midnight before sunrise gradient', () {
    // Test > 0.6 for midnight
    expect(
        testGradientCycle(0, 0),
        buildGradient(ApplicationColors.midnightStartColor,
            ApplicationColors.midnightEndColor));
  });

  test('testing night before sunrise gradient', () {
    // Test < 0.6 for night
    expect(
        testGradientCycle(4, 0),
        buildGradient(ApplicationColors.nightStartColor,
            ApplicationColors.nightEndColor));
  });

  test('testing twilight before sunrise gradient', () {
    // Test < 0.2 for twilight
    expect(
        testGradientCycle(7, 0),
        buildGradient(ApplicationColors.twilightStartColor,
            ApplicationColors.twilightEndColor));
  });

  test('testing dawn before sunrise gradient', () {
    // Test < 0.1 for dawn before sunrise
    expect(
        testGradientCycle(7, 30),
        buildGradient(ApplicationColors.dawnDuskStartColor,
            ApplicationColors.dawnDuskEndColor));
  });

  test('testing dawn after sunrise gradient', () {
    // Test < 0.1 for for dawn after sunrise
    expect(
        testGradientCycle(8, 30),
        buildGradient(ApplicationColors.dawnDuskStartColor,
            ApplicationColors.dawnDuskEndColor));
  });

  test('testing morning after sunrise gradient', () {
    // Test < 0.2 for morning
    expect(
        testGradientCycle(10, 0),
        buildGradient(ApplicationColors.morningEveStartColor,
            ApplicationColors.morningEveEndColor));
  });

  test('testing day before midday gradient', () {
    // Test < 0.4 for day
    expect(
        testGradientCycle(11, 0),
        buildGradient(
            ApplicationColors.dayStartColor, ApplicationColors.dayEndColor));
  });

  test('testing midday gradient', () {
    // Test > 0.4 and < 0.6 for midday
    expect(
        testGradientCycle(13, 0),
        buildGradient(ApplicationColors.middayStartColor,
            ApplicationColors.middayEndColor));
  });

  test('testing day after midday gradient', () {
    // Test > 0.6 for day
    expect(
        testGradientCycle(14, 0),
        buildGradient(
            ApplicationColors.dayStartColor, ApplicationColors.dayEndColor));
  });

  test('testing evening before sunset gradient', () {
    // Test > 0.8 for evening
    expect(
        testGradientCycle(16, 30),
        buildGradient(ApplicationColors.morningEveStartColor,
            ApplicationColors.morningEveEndColor));
  });

  test('testing dusk before sunset gradient', () {
    // Test > 0.9 for dusk before sunset
    expect(
        testGradientCycle(17, 30),
        buildGradient(ApplicationColors.dawnDuskStartColor,
            ApplicationColors.dawnDuskEndColor));
  });

  test('testing dusk after sunset gradient', () {
    // Test < 0.1 for for dawn after sunset
    expect(
        testGradientCycle(18, 30),
        buildGradient(ApplicationColors.dawnDuskStartColor,
            ApplicationColors.dawnDuskEndColor));
  });

  test('testing twilight after sunset gradient', () {
    // Test < 0.2 for twilight
    expect(
        testGradientCycle(19, 0),
        buildGradient(ApplicationColors.twilightStartColor,
            ApplicationColors.twilightEndColor));
  });

  test('testing night after sunset gradient', () {
    // Test < 0.6 for night
    expect(
        testGradientCycle(20, 0),
        buildGradient(ApplicationColors.nightStartColor,
            ApplicationColors.nightEndColor));
  });

  test('testing midnight after sunset gradient', () {
    // Test > 0.6 for midnight
    expect(
        testGradientCycle(23, 0),
        buildGradient(ApplicationColors.midnightStartColor,
            ApplicationColors.midnightEndColor));
  });
}
