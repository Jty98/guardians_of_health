import 'package:guardians_of_health_project/Model/record_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHandler {
  // record 테이블 생성
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(join(path, 'record.db'), onCreate: (db, version) async {
      await db.execute(
          "create table record(id integer primary key autoincrement, rating real, shape text, color text, smell text, review text, takenTime text, currentTime text)");
    }, version: 1);
  }

  // record insert
  Future<int> insertAction(RecordModel record) async {
    int result = 0;
    final Database db = await initializeDB();
    result = await db.rawInsert(
        // "INSERT INTO record(rating, shape, color, smell, review, takenTime, currentTime) values(?,?,?,?,?,?,datetime('now', 'localtime'))",
        "INSERT INTO record(rating, shape, color, smell, review, takenTime, currentTime) values(?,?,?,?,?,?,?)",
        [
          record.rating,
          record.shape,
          record.color,
          record.smell,
          record.review,
          record.takenTime,
          record.currentTime,
        ]);
    return result;
  }

  // record query
  Future<List<RecordModel>> queryRecord() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult =
        await db.rawQuery("SELECT * FROM record");
    return queryResult.map((e) => RecordModel.fromMap(e)).toList();
  }
}
