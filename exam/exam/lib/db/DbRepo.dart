import 'package:myfluttertemplate/db/DbInterface.dart';
import 'package:myfluttertemplate/entities/BookObject.dart';

class DbRepo extends DbInterface<BookObject> {
  DbRepo(String table, Map<String, String> cols, Object data)
      : super(table, cols, data);
}