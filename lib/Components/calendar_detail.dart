import 'package:flutter/material.dart';
import 'package:guardians_of_health_project/Model/calendar_event_model.dart';
import 'package:intl/intl.dart';

/// 캘린더 아래에 디테일 정보 위젯
/// @Params : `int` listLength : 클릭된 날짜의 이벤트 갯수
/// @Params : `DateTime` selectedDate : 클릭된 날짜
/// @Params : `Map<String, List<CalendarEventModel>>` events : 정보가 담겨있는 모델
Widget calendarDetail({
  required int listLength,
  required DateTime selectedDate,
  required Map<String, List<CalendarEventModel>> events,
}) {

  return ListView.builder(
    itemCount: listLength,
    itemBuilder: (context, index) {
      // selectedDate를 달력에 있는 yyyy-MM-dd 형식의 문자열로 변환해서 데이터 가져오기
      String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
      List<CalendarEventModel> eventsForSelectedDate = events[formattedDate] ?? [];
  
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          onTap: () => print(""),
          title: Text(eventsForSelectedDate[index].review),
        ),
      );
    },
  );
}
