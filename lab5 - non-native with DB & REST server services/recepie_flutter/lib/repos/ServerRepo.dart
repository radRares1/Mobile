import 'dart:convert';
import 'package:recepie_flutter/domain/Recepie.dart';
import 'package:recepie_flutter/repos/DBRepo.dart';
import 'package:http/http.dart' as http;
class ServerRepo {

  static ServerRepo _serverRepo;
  String url = "http://192.168.1.3:5000/api/recepies";

  ServerRepo._createInstance();

  DBRepo localDB = DBRepo.dbInstance;

  factory ServerRepo(){
    if (_serverRepo == null) {
      _serverRepo = ServerRepo._createInstance();
    }
    return _serverRepo;
  }

  Future<bool> isActive() async {
    var response;

    try {
      response = await http.get(url).timeout(const Duration(seconds: 3));
    } catch (e) {
      return false;
    }

    return response != null && response.statusCode == 201;
  }

  Future<http.Response> insert(Recepie r) async {
    Map<String, dynamic> body = {
      'id': r.id,
      'title': r.title,
      'type': r.type,
      'ingredients': r.ingredientsToString(),
      'description': r.description
    };
    var response;
    try {
      response = await http.post(url, body: json.encode(body)).timeout(
          const Duration(seconds: 3));
    }
    catch (e) {
      return http.Response("add error", 500);
    }
  }

  Future<http.Response> update(Recepie r) async {
    var body =
    {
      'id': r.id,
      'title': r.title,
      'type': r.type,
      'ingredients': r.ingredientsToString(),
      'description': r.description
    };

    var response;
    try {
      response = await http.put(url, body: json.encode(body)).timeout(
          const Duration(seconds: 3));
    }
    catch (e) {
      return http.Response("update error", 500);
    }
  }

  Future<int> delete(int id) async {
    var response;
    try {
      response = http.delete(url + "/" + id.toString()).timeout(
          const Duration(seconds: 3));
    }
    catch (e) {
      return 500;
    }
    return response.statusCode;
  }

  Future<List<Recepie>> getAll() async {
    var response = await http.get(url);

    var recepies = await json.decode(response.body);
    print(recepies.toString());

    return List.generate(recepies.length, (i) {
      return Recepie(recepies[i]["id"],
        recepies[i]["title"],
        recepies[i]["type"],
        recepies[i]["ingredients"],
        recepies[i]["description"]
      );
    });

  }

  void sync() async {
    print("server active");

    List<Recepie> local = await localDB.getRecepies();
    for(Recepie recepie in local){
      await this.insert(recepie);
      await localDB.deleteRecepie(recepie.id);
    }

    List<Recepie> remote = await this.getAll();

    for(Recepie recepie in remote){
      await localDB.addRecepie(recepie);
    }
    
  }

}
