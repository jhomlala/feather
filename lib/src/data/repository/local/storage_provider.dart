import 'package:shared_preferences/shared_preferences.dart';

class StorageProvider {
  Future<int?> getInt(String key) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getInt(key);
  }

  Future<bool> setInt(String key, int value) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.setInt(key, value);
  }

  Future<String?> getString(String key) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(key);
  }

  Future<bool> setString(String key, String value) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.setString(key, value);
  }
}
