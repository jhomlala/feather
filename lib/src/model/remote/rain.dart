import 'package:feather/src/utils/types_helper.dart';

class Rain {
  final double amount;

  Rain(this.amount);

  Rain.fromJson(Map<String, dynamic> json)
      : amount = TypesHelper.toDouble(json["3h"] as num?);

  Map<String, dynamic> toJson() => <String, dynamic>{
        "3h": amount,
      };
}
