/*
  기능: SQLite의 CRUD를 해주는 Handler
*/

import 'package:guardians_of_health_project/Model/record_model.dart';
import 'package:intl/intl.dart';
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

  // record query (얘가 다 가져옴)
  Future<List<RecordModel>> queryRecord() async {
    final Database db = await initializeDB();

    // SQLite 쿼리 실행 (currentTime 내림차순으로 정렬)
    final List<Map<String, Object?>> queryResult =
        await db.rawQuery("SELECT * FROM record ORDER BY currentTime DESC");

    // 쿼리 결과를 RecordModel로 변환
    return queryResult.map((e) => RecordModel.fromMap(e)).toList();
  }

// calendar query
  Future<List> getDataForDate(List<dynamic> dates) async {
    final Database db = await initializeDB();

    // SQLite 쿼리 실행
    final List<Map<String, Object?>> queryResult = await db.rawQuery(
      'SELECT * FROM record WHERE strftime(\'%Y-%m-%d\', currentTime) IN (${List.filled(dates.length, '?').join(', ')})',
      dates
          .map((date) =>
              DateFormat('yyyy-MM-dd').format(DateTime.parse(date.toString())))
          .toList(),
    );

    // 쿼리 결과를 RecordModel로 변환
    return queryResult.map((e) => RecordModel.fromMap(e)).toList();
  }
}
