import 'package:feather/src/utils/types_helper.dart';
import 'package:test/test.dart';

main() {
  test("Get double should return valid double", () {
    expect(TypesHelper.getDouble(0.0), 0.0);
    expect(TypesHelper.getDouble(0), 0.0);
    expect(TypesHelper.getDouble(-10), -10.0);
    expect(TypesHelper.getDouble(-10.0), -10.0);
  });

}
