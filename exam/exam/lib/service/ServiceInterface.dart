
import 'package:myfluttertemplate/entities/ObjectInterface.dart';
import 'package:myfluttertemplate/repos/RepoInterface.dart';

abstract class ServiceInterface<T extends ObjectInterface> {
  RepoInterface<T> _repository;

  ServiceInterface(RepoInterface repo) {
    this._repository = repo;
  }

  Future<ObjectInterface> addObject(T t) {
    return _repository.add(t);
  }

  Future<int> deleteObject(int id) {
    return _repository.deleteObject(id);
  }

  Future<int> editObject(int id, T t) {
    return _repository.editObject(id, t);
  }

  Future<ObjectInterface> getObject(int id) {
    return _repository.getObject(id);
  }

  Future<List<ObjectInterface>> getObjects() {
    return _repository.getObjects();
  }

  Future<int> size() {
    return _repository.size();
  }
}