class City{
  int _id;
  String _name;

  City(Map<String,dynamic> data){
    _id = data["id"];
    _name = data["name"];
  }

  String get name => _name;

  int get id => _id;


}