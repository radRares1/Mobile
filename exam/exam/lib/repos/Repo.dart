

import 'package:myfluttertemplate/db/DbInterface.dart';
import 'package:myfluttertemplate/entities/BookObject.dart';
import 'package:myfluttertemplate/repos/RepoInterface.dart';

class Repo extends RepoInterface<BookObject>{

  Repo(DbInterface<BookObject> db) : super(db);

}