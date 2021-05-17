import 'package:feather/src/utils/types_helper.dart';
import 'package:test/test.dart';

void main() {
  test("Get double should return valid double", () {
    expect(TypesHelper.toDouble(0.0), 0.0);
    expect(TypesHelper.toDouble(0), 0.0);
    expect(TypesHelper.toDouble(-10), -10.0);
    expect(TypesHelper.toDouble(-10.0), -10.0);
  });
}
