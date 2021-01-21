
import 'package:myfluttertemplate/entities/BookObject.dart';
import 'package:myfluttertemplate/entities/ObjectInterface.dart';
import 'package:myfluttertemplate/repos/RepoInterface.dart';
import 'package:myfluttertemplate/service/ServiceInterface.dart';

class Service extends ServiceInterface<BookObject>{
  Service(RepoInterface<ObjectInterface> repo) : super(repo);
}