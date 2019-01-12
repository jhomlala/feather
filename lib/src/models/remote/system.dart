class System{
  String _country;
  DateTime _sunrise;
  DateTime _sunset;

  System(Map<String,dynamic> data){
    _country = data["country"];
    _sunrise = DateTime.fromMillisecondsSinceEpoch(data["sunrise"]);
    _sunset = DateTime.fromMicrosecondsSinceEpoch(data["sunset"]);
  }

  DateTime get sunset => _sunset;
  DateTime get sunrise => _sunrise;
  String get country => _country;
}