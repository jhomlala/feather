class Clouds {
  final int all;

  Clouds(this.all);

  Clouds.fromJson(Map<String, dynamic> json) : all = json["all"];

  Map<String, dynamic> toJson() => {
        "all": all,
      };
}
