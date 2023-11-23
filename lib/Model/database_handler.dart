import 'package:guardians_of_health_project/Model/record.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHandler{
  // record 테이블 생성
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


  // record insert
  insertAction(RecordModel record) async {
    final Database db = await initializeDB();
    await db.rawInsert(
      "INSERT INTO record(image, rating, review, takenTime, currentTime) values(?,?,?,?,datetime('now', 'localtime'))",
      [
        record.image,
        record.rating,
        record.review,
        record.takenTime,
      ]
    );
  }

  
}