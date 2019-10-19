import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

// database table and column names
final String tableWords = 'data_survey';
final String columnId = 'id';
final String columnDateTime = 'date_time';
final String columnDirection = 'direction';
final String columnPlat = 'plat';


// data model class
class Word {

  int id;
  String date_time;
  String direction;
  String plat;

  Word();

  // convenience constructor to create a Word object
  Word.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    date_time = map[columnDateTime];
    direction = map[columnDirection];
    plat = map[columnPlat];
  }

  // convenience method to create a Map from this Word object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnDateTime: date_time,
      columnDirection: direction,
      columnPlat: plat
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }
}

// singleton class to manage the database
class DatabaseHelper {

  // This is the actual database filename that is saved in the docs directory.
  static final _databaseName = "MyDatabase.db";
  // Increment this version when you need to change the schema.
  static final _databaseVersion = 1;

  // Make this a singleton class.
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only allow a single open connection to the database.
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // open the database
  _initDatabase() async {
    Directory documentsDirectory = await getExternalStorageDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    print(path);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // SQL string to create the database
  Future _onCreate(Database db, int version) async {
    await db.execute('CREATE TABLE $tableWords ($columnId INTEGER PRIMARY KEY, $columnDateTime TEXT NOT NULL, $columnDirection TEXT NOT NULL, $columnPlat TEXT NOT NULL)');
//        '''
//              CREATE TABLE $tableWords (
//                $columnId INTEGER PRIMARY KEY,
//                $columnDateTime TEXT NOT NULL,
//                $columnDirection TEXT NOT NULL,
//                $columnPlat TEXT NOT NULL,
//              )
//              ''');
  }

  // Database helper methods:

  Future<int> insert(Word word) async {
    Database db = await database;
    int id = await db.insert(tableWords, word.toMap());
    return id;
  }

  Future<Word> queryWord(int id) async {
    Database db = await database;
    List<Map> maps = await db.query(tableWords,
        columns: [columnId, columnDateTime, columnDirection, columnPlat],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Word.fromMap(maps.first);
    }
    return null;
  }



// TODO: queryAllWords()
// TODO: delete(int id)
// TODO: update(Word word)
}