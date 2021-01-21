
abstract class ObjectInterface{
  int id;

  Map<String, dynamic> toJson();
  Map<String, dynamic> toJsonDB();
  fromJson(dynamic obj);

  ObjectInterface objectFromDBRes(Map<String, dynamic> result);
}