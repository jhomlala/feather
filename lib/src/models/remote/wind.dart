class Wind{
  double _speed;
  double _deg;

  Wind(Map<String,dynamic> data){
    _speed = data["speed"];
    _deg = data["deg"];
  }

  double get deg => _deg;
  double get speed => _speed;

}