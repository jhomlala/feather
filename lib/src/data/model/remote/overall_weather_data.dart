class OverallWeatherData {
  final int? id;
  final String? main;
  final String? description;
  final String? icon;

  OverallWeatherData(this.id, this.main, this.description, this.icon);

  OverallWeatherData.fromJson(Map<String, dynamic> json)
      : id = json["id"] as int?,
        main = json["main"] as String?,
        description = json["description"] as String?,
        icon = json["icon"] as String?;

  Map<String, dynamic> toJson() => <String, dynamic>{
        "id": id,
        "main": main,
        "description": description,
        "icon": icon,
      };

  @override
  String toString() {
    return toJson().toString();
  }
}
