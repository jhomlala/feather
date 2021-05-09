class Clouds {
  final int? all;

  Clouds(this.all);

  Clouds.fromJson(Map<String, dynamic> json) : all = json["all"] as int?;

  Map<String, dynamic> toJson() => <String, dynamic>{
        "all": all,
      };
}
