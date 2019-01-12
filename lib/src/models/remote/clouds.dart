class Clouds{
  int _all;
  Clouds(Map<String,dynamic> data){
    _all = data["all"];
  }

  int get all => _all;
}