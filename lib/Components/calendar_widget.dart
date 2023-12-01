import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guardians_of_health_project/Components/calendar_detail.dart';
import 'package:guardians_of_health_project/Components/calendar_todaybanner.dart';
import 'package:guardians_of_health_project/Model/calendar_event_model.dart';
import 'package:guardians_of_health_project/Model/database_handler.dart';
import 'package:guardians_of_health_project/Model/record_model.dart';
import 'package:guardians_of_health_project/VM/calendar_ctrl.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarWidget extends StatelessWidget {
  CalendarWidget({Key? key});

  final calendarController = Get.find<CalendarController>();

  DatabaseHandler handler = DatabaseHandler();

  // CalendarEventModel모델을 쓴 events 맵리스트
  Map<String, List<CalendarEventModel>> events = {};
  // 날짜를 yyyy-MM-dd 형식으로 변환해서 저장할 변수
  String formattedDate = "";

  List<dynamic>? recordList =
      []; // calendarController.getEventsForDay() 함수에 넣어줄 인자 리스트
  int dateCount = 0; // 그날 이벤트의 갯수

  @override
  Widget build(BuildContext context) {
    // 날짜 포멧
    formattedDate = DateFormat('yyyy-MM-dd')
        .format(calendarController.selectedDay.value!.toLocal());

    return FutureBuilder<List<RecordModel>>(
      future: handler.queryRecord(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            recordList = snapshot.data ?? [];

            for (int i = 0; i < snapshot.data!.length; i++) {
              // CalendarEventModel에다가 불러온거 넣어주기
              // DateTime 키 생성
              String dateTimeKey = DateFormat('yyyy-MM-dd').format(
                  DateTime.parse(recordList![i].currentTime.toString()));

              // 키가 이미 맵에 있는지 확인
              if (events.containsKey(dateTimeKey)) {
                // 이미 존재한다면 기존 리스트에 CalendarEventModel 추가
                events[dateTimeKey]!.add(CalendarEventModel.fromMap({
                  'currentTime': recordList![i].currentTime,
                  'takenTime': recordList![i].takenTime,
                  'rating': recordList![i].rating,
                  'review': recordList![i].review,
                }));
              } else {
                // 존재하지 않는다면 새로운 리스트를 생성하고 CalendarEventModel 추가
                events[dateTimeKey] = [
                  CalendarEventModel.fromMap({
                    'currentTime': recordList![i].currentTime,
                    'takenTime': recordList![i].takenTime,
                    'rating': recordList![i].rating,
                    'review': recordList![i].review,
                  })
                ];
              }
            }
            return Center(
              child: Obx(
                () {
                  return Column(
                    children: [
                      TableCalendar(
                          rowHeight: 45,
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
                          eventLoader: (day) {
                            return calendarController.getEventsForDay(
                                day, recordList);
                          }),
                      const SizedBox(
                        height: 10,
                      ),
                      TodayBanner(
                        selectedDate: calendarController.selectedDay.value!,
                        count: calendarController
                            .getEventsForDay(
                                calendarController.selectedDay.value!,
                                recordList)
                            .length,
                      ),
                      SizedBox(
                        height: 320,
                        child: calendarDetail(
                            listLength: calendarController
                                .getEventsForDay(
                                    calendarController.selectedDay.value!,
                                    recordList)
                                .length,
                            selectedDate: calendarController.selectedDay.value!,
                            events: events),
                      ),
                    ],
                  );
                },
              ),
            );
          }
          return const SizedBox(
            height: 300,
          );
        } else {
          return const SizedBox(
            height: 300,
          );
        }
      },
    );
  }
  // --- Functions ---

  void _daySelected(DateTime selectedDay, DateTime focusedDay) {
    calendarController.changeSelectedDay(selectedDay);
  }
} // End
