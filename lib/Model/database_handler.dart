/*
  기능: SQLite의 CRUD를 해주는 Handler
*/

import 'package:guardians_of_health_project/Model/record_count_model.dart';
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
          "create table record (id integer primary key autoincrement, rating real, shape text, color text, smell text, review text, takenTime text, currentTime text)");
    }, version: 1);
  }

  /// record insert
  Future<int> insertAction(RecordModel record) async {
    int result = 0;
    final Database db = await initializeDB();
    result = await db.rawInsert(
        "INSERT INTO record(rating, shape, color, smell, review, takenTime, currentTime) VALUES(?,?,?,?,?,?,?)",
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

  /// record query (얘가 다 가져옴)
  Future<List<RecordModel>> queryRecord() async {
    final Database db = await initializeDB();

    // SQLite 쿼리 실행 (currentTime 내림차순으로 정렬)
    final List<Map<String, Object?>> queryResult =
        await db.rawQuery("SELECT * FROM record ORDER BY currentTime DESC");

    // 쿼리 결과를 RecordModel로 변환
    return queryResult.map((e) => RecordModel.fromMap(e)).toList();
  }


  /// calendar query (캘린더 이벤트 모델에 넣기위해 사용하는 쿼리)
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

  /// record 삭제
  Future deleteRecord(int id) async {
    final Database db = await initializeDB();
    await db.rawDelete(
      "DELETE FROM record WHERE id = ?",
      [
        id
      ]
    );
  }
  
  // 일/주/월 별 데이터 개수 count해서 return
  Future<List<RecordCountModel>> queryRecordCountPerDateType(String perDate) async {
    final Database db = await initializeDB();
    late List<Map<String, Object?>> queryCountResult = [];
    // SQLite 쿼리 실행 (currentTime 내림차순으로 정렬)
    if (perDate == "per day") {
      queryCountResult =
        await db.rawQuery('''
          SELECT 
            substr(currentTime, 1, 10) AS inserted_per_date, 
            COUNT(*) AS total_count 
          FROM record 
          GROUP BY substr(currentTime, 1, 10)
        ''');
        // 날짜('yyyy-mm-dd')별 데이터 개수 합 return
    } else if (perDate == "per week") {
      queryCountResult =
        await db.rawQuery('''
          SELECT 
            STRFTIME('%Y-%m-%d', currentTime, '-6 days', 'weekday 0') AS inserted_per_date,
            COUNT(*) AS total_count
          FROM record
          GROUP BY STRFTIME('%Y-%W', currentTime)
        ''');
    } else {
      queryCountResult =
        await db.rawQuery('''
          SELECT 
            STRFTIME('%Y-%m', currentTime) AS inserted_per_date, 
            COUNT(*) AS total_count
          FROM record
          GROUP BY STRFTIME('%Y-%m', currentTime)
        ''');
    }
    // 쿼리 결과를 RecordModel로 변환
    return queryCountResult.map((e) => RecordCountModel.fromMap(e)).toList();
  }

  // 일/주/월별 String data unique한 값 count 해서 return
  // Future<List<RecordCountModel>>re

} // class END
