

import 'package:myfluttertemplate/db/DbInterface.dart';
import 'package:myfluttertemplate/entities/BookObject.dart';
import 'package:myfluttertemplate/entities/ObjectInterface.dart';
import 'package:myfluttertemplate/server/ServerInterface.dart';

class ServerRepo extends ServerInterface<BookObject>{
  ServerRepo(DbInterface<ObjectInterface> local, BookObject data, String url) :
        super(local, data, url);

}