import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guardians_of_health_project/Components/calendar_detail.dart';
import 'package:guardians_of_health_project/Components/calendar_todaybanner.dart';
import 'package:guardians_of_health_project/Model/calendar_event_model.dart';
import 'package:guardians_of_health_project/Model/database_handler.dart';
import 'package:guardians_of_health_project/Model/record_model.dart';
import 'package:guardians_of_health_project/Model/result_rating_model.dart';
import 'package:guardians_of_health_project/VM/calendar_ctrl.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarWidget extends StatelessWidget {
  CalendarWidget({Key? key});

  final calendarController = Get.find<CalendarController>();

  DatabaseHandler handler = DatabaseHandler();

  Map<DateTime, List<RecordModel>> events = {};
  // List<RecordModel> recordList = [];
  String formattedDate = "";
  List<String> timelist = [];

  List<dynamic>? recordList = [];
  int dateCount = 0; // 그날 이벤트의 갯수

  @override
  Widget build(BuildContext context) {
    formattedDate = DateFormat('yyyy-MM-dd')
        .format(calendarController.selectedDay.value!.toLocal());

    return FutureBuilder<List<RecordModel>>(
      future: handler.queryRecord(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            recordList = snapshot.data ?? [];

            for (int i = 0; i < snapshot.data!.length; i++) {
              timelist.add(DateFormat('yyyy-MM-dd').format(DateTime.parse(recordList![i].currentTime.toString())));
            }
            // print(timelist);

            return Center(
              child: Obx(
                () {
                  return Column(
                    children: [
                      TableCalendar(
                          rowHeight: 55,
                          focusedDay: calendarController.selectedDay.value!,
                          firstDay: DateTime.utc(2000, 1, 1),
                          lastDay: DateTime.utc(2050, 12, 31),
                          locale: "ko_KR",
                          headerStyle: const HeaderStyle(
                            formatButtonVisible: false,
                            titleCentered: true,
                          ),
                          onDaySelected: _daySelected,
                          selectedDayPredicate: (day) => isSameDay(
                              day, calendarController.selectedDay.value!),
                          // eventLoader: (day) => getEventsForDay(day, timelist),
                          eventLoader: (day) {
                            // DateCount.date = getEventsForDay(day, recordList).length;
                            return calendarController.getEventsForDay(day, recordList);
                          }),
                      TodayBanner(
                        selectedDate: calendarController.selectedDay.value!,
                        count: DateCount.date,
                        // count: dateCount,
                      ),
                    ],
                  );
                },
              ),
            );
          }
          return calendarDetail(
              actionDate: calendarController.getEventsForDay(calendarController.selectedDay.value!, recordList));
        } else {
          return const SizedBox();
        }
      },
    );
  }

  void _daySelected(DateTime selectedDay, DateTime focusedDay) {
    calendarController.changeSelectedDay(selectedDay);
  }

//  // 이벤트를 가져오는 함수 업데이트
//   List<dynamic> getEventsForDay(DateTime day, List<dynamic>? recordList) {
//     // 날짜를 'yyyy-MM-dd' 형식의 문자열로 변환
//     String formattedDate = DateFormat('yyyy-MM-dd').format(day.toLocal());

//     // 해당 날짜에 해당하는 이벤트 리스트 필터링
//     List<dynamic> eventsForDay = recordList
//         ?.where((record) =>
//             DateFormat('yyyy-MM-dd').format(DateTime.parse(record.currentTime)) == formattedDate)
//         .toList() ?? [];

//     // 해당 날짜의 이벤트 갯수 출력
//   // print('날짜 $formattedDate의 이벤트 갯수: ${eventsForDay.length}');
//   handler.getDataForDate(day.toString());

//     return eventsForDay;
//   }
}