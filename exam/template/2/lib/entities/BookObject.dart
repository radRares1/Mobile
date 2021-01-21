import 'package:myfluttertemplate/entities/ObjectInterface.dart';

class BookObject implements  ObjectInterface{
  @override
  int id;
  String name;
  String level;
  String status;
  String from;
  String to;

  BookObject.emptyConstructor();

  BookObject(int id, String name, String level,String status,String from, String to) {
    this.id = id;
    this.name = name;
    this.level = level;
    this.status = status;
    this.from = from;
    this.to = to;
  }

  BookObject.withoutId(String name, String level,String status,String from, String to) {
    this.name = name;
    this.level = level;
    this.status = status;
    this.from = from;
    this.to = to;
  }

  @override
  fromJson(obj) {
    this.id = obj['id'];
    this.name = obj['name'];
    this.level = obj['level'];
    this.status = obj['status'];
    this.from = obj['from'];
    this.to = obj['to'];
  }

  @override
  ObjectInterface objectFromDBRes(Map<String, dynamic> result) {
    BookObject newObj = BookObject(result['id'],
        result['name'], result['level'].toString(),result['status'],result['from'].toString(),result['to'].toString());
    this.id = result['id'];
    this.name = result['name'];
    this.level = result['level'].toString();
    this.status = result['status'];
    this.from = result['from'].toString();
    this.to = result['to'].toString();
    return newObj;
  }

  @override
  Map<String, dynamic> toJson() {
    var map = new Map<String, dynamic>();
    map['name'] = name;
    map['level'] = level;
    if (id != null) {
      map['id'] = id.toString();
    }
    map['status'] = status;
    map['from'] = from;
    map['to'] = to;
    return map;
  }

  @override
  Map<String, dynamic> toJsonDB() {

    var map = new Map<String, dynamic>();
    if (id != null) {
      map['id'] = id.toString();
    }
    map['name'] = name;
    map['level'] = level;

    map['status'] = status;
    map['from'] = from;
    map['to'] = to;
    return map;
  }

  @override
  String toString() {
    String idStr = id.toString();
    return '{id: $idStr\n, name: $name\n, level: $level\n, status: $status\n, from: $from\n, to: $to\n}';
  }
}
