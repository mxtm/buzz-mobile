import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:buzz/services/visitor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DBHandler {
  static Database _db;
  final databaseReference = Firestore.instance;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDB();
    return _db;
  }

  initDB() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String pathDB = join(directory.path, 'database.db');
    var dbInstance =
        await openDatabase(pathDB, version: 1, onCreate: _onCreate);
    return dbInstance;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE VISITOR(id INTEGER PRIMARY KEY AUTOINCREMENT, firstName TEXT, lastName TEXT, image TEXT)');
    print('DB Created');
  }

  void saveVisitors(Visitor visitor) async {
    String firstName;
    String lastName;
    String image;
    int id;

    firstName = visitor.firstName;
    lastName = visitor.lastName;
    image = visitor.image;

    var dbClient = await db;
    await dbClient.transaction((txn) async {
       id = await txn.rawInsert(
          'INSERT INTO VISITOR(firstName, lastName, image) values (?, ?, ?)',
          [firstName, lastName, image]);
    });
    await databaseReference.collection("visitors").document("$id")
    .setData({
      'firstName': firstName,
      'lastName': lastName,
      'image': image,
    });
  }

  editVisitor(Visitor v) async {
    var dbClient = await db;
    await dbClient.rawQuery('SELECT * FROM VISITOR WHERE id = ${v.id}');
    await dbClient.rawUpdate(
        'UPDATE VISITOR SET firstName = ?, lastName = ?, image = ? WHERE id = ?',
        [v.firstName, v.lastName, v.image, v.id]);
    try {
      await databaseReference.collection("visitors").document("${v.id}")
          .updateData({
        'firstName': v.firstName,
        'lastName': v.lastName,
        'image': v.image,
      });
    } catch (e) {
      print(e.toString());
    };
  }

  Future<List<Visitor>> getVisitors() async {
    var dbClient = await db;
    List<Map> visitorList = await dbClient.rawQuery('SELECT * FROM VISITOR');
    List<Visitor> visitors = new List();

    for (var i = 0; i < visitorList.length; i++) {
      visitors.add(new Visitor.withID(
          visitorList[i]['id'],
          visitorList[i]['firstName'],
          visitorList[i]['lastName'],
          visitorList[i]['image']));
    }

    print(visitors.length);
    return visitors;
  }

  void deleteVisitor(int id) async {
    var dbClient = await db;

    await dbClient.transaction((txn) async {
      return await txn.rawDelete('DELETE FROM VISITOR WHERE id = $id');
    });
    try {
      databaseReference.collection("visitors").document("$id").delete();
    } catch (e) {
      print(e.toString());
    }
  }
}
