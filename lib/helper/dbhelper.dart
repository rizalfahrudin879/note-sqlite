import 'dart:io';

import 'package:crud_sqlite/model/note.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DbHelper {
  static DbHelper _dbHelper;
  static Database _database;

  DbHelper._createObject();

  factory DbHelper() {
    if (_dbHelper == null) {
      _dbHelper = DbHelper._createObject();
    }
    return _dbHelper;
  }

  Future<Database> initDb() async {
    //! Untuk menentukan nama DB dan lokasinya
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'note.db';

    //! Create & Read DB
    var noteDatabase = openDatabase(path, version: 1, onCreate: _createDb);

    return noteDatabase;
  }

  void _createDb(Database db, int version) async {
    await db.execute('''
    CREATE TABLE note (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT,
      desc TEXT
    )
    ''');
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initDb();
    }
    return _database;
  }

  Future<List<Map<String, dynamic>>> select() async {
    Database db = await this.database;
    var mapList = await db.query('note', orderBy: 'title');
    return mapList;
  }

  //! Create-Insert DB
  Future<int> insert(Note object) async {
    Database db = await this.database;
    int count = await db.insert('note', object.toMap());
    return count;
  }

  //! Update DB
  Future<int> update(Note object) async {
    Database db = await this.database;
    int count = await db.update('note', object.toMap(), where: 'id=?', whereArgs: [object.id]);
    return count;
  }

  //! Detele DB
  Future<int> delete(int id) async {
    Database db = await this.database;
    int count = await db.delete('note', where: 'id=?', whereArgs: [id]);
    return count;
  }

  Future<List<Note>> getNoteList() async {
    var noteMapList = await select();
    int count = noteMapList.length;
    List<Note> noteList = List<Note>();
    for (int i=0; i<count; i++) {
      noteList.add(Note.fromMap(noteMapList[i]));
    }
    return noteList;
  }
}
