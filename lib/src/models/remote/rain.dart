import 'package:feather/src/utils/types_helper.dart';

class Rain{
  double _amount;

  Rain(Map<String,dynamic> map){
    _amount = TypesHelper.getDouble(map["3h"]);
  }

  double get amount => _amount;


}