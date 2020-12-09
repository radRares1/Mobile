import 'package:recepie_flutter/domain/Recepie.dart';

class InMemRepository {

  List<Recepie> _recepies = new List<Recepie>();
  int currentId = 10;

  static final _repository = InMemRepository._internal();

  List<Recepie> getRecepies() {
    return _recepies;
  }

  InMemRepository._internal(){
    _recepies = [
      Recepie(0, "t1", "ty1", ["12", "23"], "d1"),
      Recepie(1, "t2", "ty2", ["12", "23"], "d2"),
      Recepie(2, "t3", "ty3", ["12", "23"], "d3"),
      Recepie(3, "t4", "ty4", ["12", "23"], "d4"),
      Recepie(4, "t5", "ty5", ["12", "23"], "d5"),
      Recepie(5, "t6", "ty6", ["12", "23"], "d6"),
      Recepie(6, "t7", "ty7", ["12", "23"], "d7"),
      Recepie(7, "t8", "ty8", ["12", "23"], "d8"),
      Recepie(8, "t9", "ty9", ["12", "23"], "d9"),
      Recepie(9, "t10", "ty10", ["12", "23"], "d10"),
      Recepie(10, "t11", "ty11", ["12", "23"], "d11")
    ];
  }

  factory InMemRepository(){
    return _repository;
  }

  void addRecepie(Recepie r){
    r.id = currentId++;;
    _recepies.add(r);
  }

  void editRecepie(Recepie r){
    for(Recepie rec in _recepies){
      if(rec.id == r.id){
        rec.title = r.title;
        rec.type = r.type;
        rec.ingredients = r.ingredients;
        rec.description = r.description;
      }
    }
  }
}
