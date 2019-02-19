import 'package:feather/src/models/internal/unit.dart';
import 'package:feather/src/resources/repository/local/storage_manager.dart';

class ApplicationLocalRepository{
  final StorageManager _storageManager = StorageManager();

  Future<Unit> getSavedUnit() async{
   return _storageManager.getUnit();
  }

  void saveUnit(Unit unit){
    _storageManager.saveUnit(unit);
  }
}