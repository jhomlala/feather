import 'package:feather/src/resources/location_manager.dart';
import 'package:test/test.dart';

void main(){

  LocationManager locationManager = new LocationManager();

  test("Position should be optional with absent",() async {
    var position = await locationManager.getLocation();
    expect(position != null, true);
    expect(position.isPresent, false);
  });
}