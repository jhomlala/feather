import 'package:feather/src/utils/types_helper.dart';
import 'package:test/test.dart';

main() {
  test("Get double should return valid double", () {
    expect(TypesHelper.getDouble(0.0), 0.0);
    expect(TypesHelper.getDouble(0), 0.0);
    expect(TypesHelper.getDouble(-10), -10.0);
    expect(TypesHelper.getDouble(-10.0), -10.0);
  });

  test("Format temperature should return valid formatted string", () {
    expect(TypesHelper.formatTemperature(temperature: 0.0), "0°C");
    expect(TypesHelper.formatTemperature(temperature: 5.531), "5°C");
    expect(
        TypesHelper.formatTemperature(
            temperature: -5.531, positions: 1, round: false),
        "-5.5°C");
    expect(TypesHelper.formatTemperature(temperature: -5.531, positions: 1),
        "-6.0°C");
    expect(
        TypesHelper.formatTemperature(
            temperature: 5.555, positions: 2, round: false),
        "5.55°C");
  });
}
