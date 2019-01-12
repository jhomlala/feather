class OverallWeatherData{
  int _id;
  String _main;
  String _description;
  String _icon;

  OverallWeatherData(Map<String,dynamic> data){
    _id = data["id"];
    _main = data["main"];
    _description = data["description"];
    _icon = data["icon"];
  }

  String get icon => _icon;
  String get description => _description;
  String get main => _main;
  int get id => _id;

}