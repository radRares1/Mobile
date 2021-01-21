import 'package:myfluttertemplate/db/DbRepo.dart';
import 'package:myfluttertemplate/entities/BookObject.dart';

class ConfigManager {
  static getDbFromJsonConfig() {
    Map config = {
      "className": "TestObj1",
      "fields": [
        {"name": "id", "type": "int"},
        {"name": "title", "type": "String"},
        {"name": "date", "type": "String"}
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