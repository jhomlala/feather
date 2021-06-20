class City {
  final int? id;
  final String? name;

  City(this.id, this.name);

  City.fromJson(Map<String, dynamic> json)
      : id = json["id"] as int?,
        name = json["name"] as String?;

  Map<String, dynamic> toJson() => <String, dynamic>{
        "id": id,
        "name": name,
      };
}
