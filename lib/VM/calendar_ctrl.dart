/*
  기능: table_calendar의 상태관리를 하기위한 GetXController
*/

import 'package:get/get.dart';
import 'package:guardians_of_health_project/VM/database_handler.dart';
import 'package:intl/intl.dart';

class CalendarController extends GetxController {
  DatabaseHandler handler = DatabaseHandler();

  // 달력에서 클릭된 날짜의 상태를 관찰하는 변수
  Rx<DateTime?> selectedDay = DateTime.now().obs;

  @override
  void onInit() {
    changeSelectedDay(selectedDay.value!);
    super.onInit();
  }

  /// 달력에서 날짜 클릭시 그 날짜라고 알려주는 함수
  void changeSelectedDay(DateTime newDay) {
    selectedDay.value = newDay;
  }

  /// 이벤트를 가져오는 함수
  /// @Params: 'DateTime day' : 이벤트가 있는day
  /// @Params: 'List<dynamic>? recordList' : 쿼리문 결과가 저장된 recordList
  List<DateTime> getEventsForDay(DateTime day, List<dynamic>? recordList) {
    // 날짜를 'yyyy-MM-dd' 형식의 문자열로 변환
    String formattedDate = DateFormat('yyyy-MM-dd').format(day.toLocal());

    // 해당 날짜에 해당하는 이벤트 리스트 필터링
    List<DateTime> eventsForDay = recordList
            ?.where((record) =>
                DateFormat('yyyy-MM-dd')
                    .format(DateTime.parse(record.currentTime)) ==
                formattedDate)
            .map((record) => DateTime.parse(record.currentTime))
            .toList() ??
        [];

    // 데이터베이스에서 해당 날짜의 데이터 가져오기
    handler.getDataForDate(eventsForDay);
    update();
    return eventsForDay;
  }

  /// record 지우기
  deleteRecord(int id) {
    handler.deleteRecord(id);
  }
}
