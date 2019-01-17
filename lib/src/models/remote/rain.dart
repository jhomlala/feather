import 'package:feather/src/utils/types_helper.dart';

class Rain{
  final double amount;

  Rain(this.amount);

  Rain.fromJson(Map<String,dynamic> json): amount = TypesHelper.getDouble(json["3h"]);

  Map<String,dynamic> toJson() => {
    "3h": amount
  };


}