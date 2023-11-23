import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseHandler{
  Future <Database> initializeDB() async{
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'record.db'),
      onCreate: (db, version) async{
        await db.execute(
          "create table record(id integer primary key autoincrement, image blob, rating double, review text, takenTime text, currentTime text)"
        );
      },
      version: 1
    );
    
  }
}