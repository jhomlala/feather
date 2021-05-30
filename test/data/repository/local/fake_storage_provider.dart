import 'dart:collection';

import 'package:feather/src/data/repository/local/storage_provider.dart';

class FakeStorageProvider extends StorageProvider {
  final intMap = HashMap<String, int>();
  final stringMap = HashMap<String, String>();

  @override
  Future<int?> getInt(String key) async {
    return intMap[key];
  }

  @override
  Future<bool> setInt(String key, int value) async {
    intMap[key] = value;
    return true;
  }

  @override
  Future<String?> getString(String key) async {
    return stringMap[key];
  }

  @override
  Future<bool> setString(String key, String value) async {
    stringMap[key] = value;
    return true;
  }
}
