import 'dart:io';

import 'package:database_pratiecs/loginModel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DataBaseHelper {
 static final DataBaseHelper helper=DataBaseHelper._();
  DataBaseHelper._();
  Database? database;
  final String dbPath = "database.db";
  String loginTable = "loginTable";

  Future<Database?> checkDb() async {
    if (database != null) {
      return database;
    } else {
      return await initDb();
    }
  }

  Future<Database> initDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path, dbPath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
            'CREATE TABLE $loginTable(id INTEGER PRIMARY KEY AutoIncrement ,name Text)');
      },
    );
  }

   Future<void> insertDb({LoginModel? model}) async {
    database = await checkDb();
    await database!.insert('$loginTable', {'name': model!.name});
  }

  Future<List> readDb() async {
    database = await checkDb();
    String quary = "SELECT * FROM $loginTable";

    List<Map> l1 = await database!.rawQuery(quary);

    return l1;
  }

 Future<int> deleteDb(int id) async {
   database = await checkDb();
   return await database!.delete("$loginTable", where: 'id=?', whereArgs: [id]);
 }

}
