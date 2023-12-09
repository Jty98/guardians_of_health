/*
  기능: SQLite의 CRUD를 해주는 Handler
*/

import 'package:guardians_of_health_project/Model/password_model.dart';
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
      await db.execute(
          "create table password (id integer primary key autoincrement, pw text, pwStatus integer)");
    }, version: 1);
  }

  /// password 테이블 query로 비밀번호, 비밀번호 status확인하는 쿼리
  Future<List<PasswordModel>> queryPassword() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult =
    await db.rawQuery(
      'SELECT * FROM password');
    // 쿼리 결과를 PasswordModel 변환
    return queryResult.map((e) => PasswordModel.fromMap(e)).toList();
  }

  /// password 저장
Future<bool> insertPassword(PasswordModel password) async {
  final Database db = await initializeDB();

  try {
    int id = await db.rawInsert(
      "INSERT INTO password(pw, pwStatus) VALUES(?,?)",
      [
        password.pw,
        password.pwStatus,
      ],
    );

    // 삽입 성공 시 id는 0보다 큼
    bool isInsertSuccessful = id > 0;
    return isInsertSuccessful;
  } catch (e) {
    print("insert 에러: $e");
    return false;
  }
}

  /// password 삭제
    Future deletePassword(int id) async {
    final Database db = await initializeDB();
    await db.rawDelete(
      "DELETE FROM password WHERE id = ?",
      [
        id
      ]
    );
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
}
