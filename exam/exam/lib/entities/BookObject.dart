import 'package:myfluttertemplate/entities/ObjectInterface.dart';

class BookObject implements  ObjectInterface{
  @override
  int id;
  String title;
  String date;

  BookObject.emptyConstructor();

  BookObject(int id, String title, String date) {
    this.id = id;
    this.title = title;
    this.date = date;
  }

  BookObject.withoutId(String title, String date) {
    this.title = title;
    this.date = date;
  }

  @override
  fromJson(obj) {
    this.id = obj['id'];
    this.title = obj['title'];
    this.date = obj['date'];
  }

  @override
  ObjectInterface objectFromDBRes(Map<String, dynamic> result) {
    BookObject newObj = BookObject(result['id'], result['title'], result['date']);
    this.id = result['id'];
    this.title = result['title'];
    this.date = result['date'];
    return newObj;
  }

  @override
  Map<String, dynamic> toJson() {
    var map = new Map<String, dynamic>();
    map['title'] = title;
    map['date'] = date;
    if (id != null) {
      map['id'] = id.toString();
    }
    return map;
  }

  @override
  Map<String, dynamic> toJsonDB() {
    var map = new Map<String, dynamic>();
    map['title'] = title;
    map['date'] = date;
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  @override
  String toString() {
    String idStr = id.toString();
    return '{id: $idStr\n, title: $title\n, date: $date\n}';
  }
}
