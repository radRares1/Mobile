import 'package:myfluttertemplate/db/DbRepo.dart';
import 'package:myfluttertemplate/entities/BookObject.dart';

class ConfigManager {
  static getDbFromJsonConfig() {
    Map config = {
      "className": "employe",
      "fields": [
        {"name": "id", "type": "int"},
        {"name": "name", "type": "String"},
        {"name": "level", "type": "String"},
        {"name": "status", "type": "String"},
        {"name": "from", "type": "String"},
        {"name": "to", "type": "String"}
      ]
    };
    var columns = new Map<String, String>();
    var fields = config['fields'];
    fields.forEach((e) => {
      e['name'] == 'id' ? columns[e['name']] = 'int' : columns[e['name']] = 'text'
    });
    return DbRepo(config['className'], columns, BookObject.emptyConstructor());
  }
}