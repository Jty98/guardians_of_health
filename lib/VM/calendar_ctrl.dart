import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guardians_of_health_project/Model/calendar_event_model.dart';
import 'package:guardians_of_health_project/Model/database_handler.dart';
import 'package:guardians_of_health_project/Model/record_model.dart';
import 'package:intl/intl.dart';

class CalendarController extends GetxController {
  TextEditingController eventController = TextEditingController();
  Rx<DateTime?> selectedDay = DateTime.now().obs;
  RxList<CalendarEventModel> events = <CalendarEventModel>[].obs;
  DatabaseHandler handler = DatabaseHandler();
  RxInt dateCount= 0.obs;
  List data = [];

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();
    eventController.dispose();
  }

  void changeSelectedDay(DateTime newDay) {
    selectedDay.value = newDay;
  }

// List<CalendarEventModel> getEventsForDay(List<DateTime> days) {
//   List<CalendarEventModel> events = [];

//   for (int i = 0; i < days.length; i++) {
//     DateTime day = days[i];
//     Map<DateTime, List<CalendarEventModel>> events1 = {
//       day: [
//         CalendarEventModel(
//           actionDate: DateTime.now(),
//           rating: 1.0,
//           review: "ss",
//           takenTime: "ss",
//         ),
//       ],
//     };

//     events.addAll(events1[day] ?? []);
//   }

//   return events;
// }

 // 이벤트를 가져오는 함수 업데이트
  List<dynamic> getEventsForDay(DateTime day, List<dynamic>? recordList) {
    // 날짜를 'yyyy-MM-dd' 형식의 문자열로 변환
    String formattedDate = DateFormat('yyyy-MM-dd').format(day.toLocal());

    // 해당 날짜에 해당하는 이벤트 리스트 필터링
    List<dynamic> eventsForDay = recordList
        ?.where((record) =>
            DateFormat('yyyy-MM-dd').format(DateTime.parse(record.currentTime)) == formattedDate)
        .toList() ?? [];

    // 해당 날짜의 이벤트 갯수 출력
  // print('날짜 $formattedDate의 이벤트 갯수: ${eventsForDay.length}');
  handler.getDataForDate(day.toString());

    return eventsForDay;
  }


}
