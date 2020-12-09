import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:recepie_flutter/domain/Recepie.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DBRepo {
  static final _dbName = "RecepiesDB.db";
  static final _dbVersion = 1;
  static final table = "recepies";

  //singleton pattern
  DBRepo._();

  static final DBRepo dbInstance = DBRepo._();

  static Database _database;

  //we get the database reference everytime we need it
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDB();
    await this.addInitData();
    return _database;
  }

  //open the db an create it if it doesn't exist
  _initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _dbName);

    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  //creates the db table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
            CREATE TABLE $table (
            _recepieId INTEGER ,
            title TEXT NOT NULL,
            type TEXT NOT NULL,
            ingredients TEXT NOT NULL,
            description TEXT NOT NULL
            )
        ''');

  }

  //returns all recepies
  Future<List<Recepie>> getRecepies() async {
    Database db = await dbInstance.database;
    var rows =  await db.query(table);
    var list = new List<Recepie>();
    for(var row in rows){

      list.add(new Recepie(row["_recepieId"],row["title"],row["type"],row["ingredients"].split(","),row["description"]));
    }

    return await Future.value(list);
  }

  // inserts in the db a map(row) with key as colname and value as value
  //returns the id of the row
  Future<int> addRecepie(Recepie r) async {
    Database db = await dbInstance.database;
    Map<String, dynamic> row = {
      '_recepieId': r.id,
      'title': r.title,
      'type': r.type,
      'ingredients': r.ingredientsToString(),
      'description': r.description
    };

    return await db.insert(table, row,conflictAlgorithm: ConflictAlgorithm.replace);
  }

  //update recepie
  Future<int> editRecepie(Recepie r) async {
    Database db = await dbInstance.database;
    int id = r.id;
    Map<String, dynamic> row = {
      '_recepieId': r.id,
      'title': r.title,
      'type': r.type,
      'ingredients': r.ingredientsToString(),
      'description': r.description
    };

    return await db
        .update(table, row, where: '_recepieId = ?', whereArgs: [id]);
  }

  //delete recepie based on id
  Future<int> deleteRecepie(int id) async {
    Database db = await dbInstance.database;
    return await db.delete(table, where: '_recepieId = ?', whereArgs: [id]);
  }

  void addInitData() async {
    var recepies = [
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

    for(var recepie in recepies ) {
      await this.addRecepie(recepie);
    }

  }
}
