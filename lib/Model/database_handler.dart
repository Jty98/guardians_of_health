/*
  기능: SQLite의 CRUD를 해주는 Handler
*/

import 'package:guardians_of_health_project/Model/rating_count_model.dart';
import 'package:guardians_of_health_project/Model/rating_count_model_per_day.dart';
import 'package:guardians_of_health_project/Model/record_count_model.dart';
import 'package:guardians_of_health_project/Model/record_model.dart';
import 'package:guardians_of_health_project/Model/taken_time_model.dart';
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
  
  // 일/주/월 별 기록 횟수 count해서 return
  Future<List<RecordCountModel>> queryRecordCountPerDateType(int perDate) async {
    final Database db = await initializeDB();
    late List<Map<String, Object?>> queryCountResult = [];
    // SQLite 쿼리 실행 (currentTime 내림차순으로 정렬)
    if (perDate == 0) {     // per day
      queryCountResult =
        await db.rawQuery('''
          SELECT 
            substr(currentTime, 1, 10) AS inserted_per_date, 
            COUNT(*) AS total_count 
          FROM record 
          GROUP BY substr(currentTime, 1, 10)
        ''');
        // 날짜('yyyy-mm-dd')별 데이터 개수 합 return
    } else if (perDate == 1) {    // per month
      queryCountResult =
        await db.rawQuery('''
          SELECT 
            STRFTIME('%Y-%m-%d', currentTime, '-6 days', 'weekday 0') AS inserted_per_date,
            COUNT(*) AS total_count
          FROM record
          GROUP BY STRFTIME('%Y-%W', currentTime)
        ''');
    } else {      // per month
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

// 일(최근 7일)별 만족도 범주별 데이터 count
  Future<List<RatingCountModelPerDay>> queryRatingCountPerDayType() async {
    final Database db = await initializeDB();
    late List<Map<String, Object?>> queryCountResult = [];
    // SQLite 쿼리 실행 (currentTime 내림차순으로 정렬)
    queryCountResult =
      await db.rawQuery('''
        SELECT 
          STRFTIME('%Y-%m-%d', currentTime) AS inserted_per_date,
          rating, 
          COUNT(rating) AS count_per_category
        FROM record
        WHERE currentTime >= DATE('now', '-6 days')
        GROUP BY STRFTIME('%Y-%m-%d', currentTime) , rating
        HAVING COUNT(*) > 0;
      ''');
      // 날짜('yyyy-mm-dd')별 데이터 개수 합 return
    
    // 쿼리 결과를 RatingCountModelPerDay 변환
    return queryCountResult.map((e) => RatingCountModelPerDay.fromMap(e)).toList();
  }
// 주 (최근 2주), 월(최근 3개월)별 만족도 범주별 데이터 count
  Future<List<RatingCountModel>> queryRatingCountPerWMType(int perDate) async {
    final Database db = await initializeDB();
    late List<Map<String, Object?>> queryCountResult = [];
    if (perDate == 1) {          // 주별 만족도 count (최근 2주 기준)
      queryCountResult =
        await db.rawQuery('''
          SELECT 
              rating,
              SUM(count_per_category) AS total_count_per_category
          FROM (
              SELECT 
                  rating,
                  COUNT(*) AS count_per_category
              FROM record
              WHERE currentTime >= DATE('now', '-13 days')
              GROUP BY currentTime, rating
          ) subquery
          GROUP BY rating;
        ''');
    } else {              // 월별 만족도 카테고리 별 count (최근 3개월 기준)
      queryCountResult =
        await db.rawQuery('''
          SELECT 
              rating,
              SUM(count_per_category) AS total_count_per_category
          FROM (
              SELECT 
                  rating,
                  COUNT(*) AS count_per_category
              FROM record
              WHERE currentTime >= DATE('now', '-3 months')
              GROUP BY currentTime, rating
          ) subquery
          GROUP BY rating;
        ''');
    }
    // 쿼리 결과를 RecordModel로 변환
    return queryCountResult.map((e) => RatingCountModel.fromMap(e)).toList();
  }


  // 일/주/월 별 소요시간 return
  Future<List<TakenTimeModel>> queryTakenTimeDataPerDateType(int perDate) async {
    final Database db = await initializeDB();
    late List<Map<String, Object?>> queryCountResult = [];
    // SQLite 쿼리 실행 (currentTime 내림차순으로 정렬)
    if (perDate == 0) {     // per day : 기록 그대로 가져가기
      queryCountResult =
        await db.rawQuery('''
          SELECT 
            STRFTIME('%Y-%m-%d', currentTime) AS inserted_per_date,
            ROUND(AVG((CAST(STRFTIME('%H', takenTime) AS INTEGER) * 60 +
                  CAST(STRFTIME('%M', takenTime) AS INTEGER) +
                  CAST(STRFTIME('%S', takenTime) AS REAL) / 60)) , 2) AS takenTime
          FROM record
          GROUP BY STRFTIME('%Y-%m-%d', currentTime)
        ''');
        // 날짜('yyyy-mm-dd')별 데이터 개수 합 return
    } else if (perDate == 1) {    // per week : 해당 기간동안 소요시간의 평균
      queryCountResult =
        await db.rawQuery('''
          SELECT 
            STRFTIME('%Y-%m-%d', currentTime, '-6 days', 'weekday 0') AS inserted_per_date,
            ROUND(AVG((CAST(STRFTIME('%H', takenTime) AS INTEGER) * 60 +
                  CAST(STRFTIME('%M', takenTime) AS INTEGER) +
                  CAST(STRFTIME('%S', takenTime) AS REAL) / 60)) , 2) AS takenTime
          FROM record
          GROUP BY STRFTIME('%Y-%W', currentTime)
        ''');
    } else {      // per month : 해당 기간동안 소요시간의 평균
      queryCountResult =
        await db.rawQuery('''
          SELECT 
            STRFTIME('%Y-%m', currentTime) AS inserted_per_date, 
            ROUND(AVG((CAST(STRFTIME('%H', takenTime) AS INTEGER) * 60 +
                  CAST(STRFTIME('%M', takenTime) AS INTEGER) +
                  CAST(STRFTIME('%S', takenTime) AS REAL) / 60)) , 2) AS takenTime
          FROM record
          GROUP BY STRFTIME('%Y-%m', currentTime)
        ''');
    }
    // 쿼리 결과를 RecordModel로 변환
    return queryCountResult.map((e) => TakenTimeModel.fromMap(e)).toList();
  }







} // class END
