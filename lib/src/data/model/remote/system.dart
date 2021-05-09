class System {
  final String? country;
  final int? sunrise;
  final int? sunset;

  System(this.country, this.sunrise, this.sunset);

  System.fromJson(Map<String, dynamic> json)
      : country = json["country"] as String?,
        sunrise = json["sunrise"] as int?,
        sunset = json["sunset"] as int?;

  Map<String, dynamic> toJson() => <String, dynamic>{
        "country": country,
        "sunrise": sunrise,
        "sunset": sunset
      };
}
