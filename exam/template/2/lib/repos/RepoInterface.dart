


import 'package:myfluttertemplate/db/DbInterface.dart';
import 'package:myfluttertemplate/entities/ObjectInterface.dart';


abstract class RepoInterface<T extends ObjectInterface>{
  DbInterface _db;

  RepoInterface(DbInterface dbHelper){
    this._db = dbHelper;
  }

  Future<T> add(T t){
    return _db.insert(t);
  }

  Future<List<T>> getObjects(){
    return _db.getItems();
  }

  Future<T> getObject(int id){
    return _db.getItem(id);
  }

  Future<int> deleteObject(int id){
    return _db.delete(id);
  }

  Future<int> editObject(int id, T newObject){
    return _db.update(id, newObject);
  }

  Future<int> size(){
    return _db.getCount();
  }
}