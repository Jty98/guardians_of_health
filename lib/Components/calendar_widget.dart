/*
  기능: table_calendar 기능
*/

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guardians_of_health_project/Components/calendar_detail.dart';
import 'package:guardians_of_health_project/Components/calendar_todaybanner.dart';
import 'package:guardians_of_health_project/Components/marker_style.dart';
import 'package:guardians_of_health_project/Model/calendar_event_model.dart';
import 'package:guardians_of_health_project/Model/database_handler.dart';
import 'package:guardians_of_health_project/Model/record_model.dart';
import 'package:guardians_of_health_project/VM/calendar_ctrl.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

// ignore: must_be_immutable
class CalendarWidget extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
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
                  'id': recordList![i].id,
                  'currentTime': recordList![i].currentTime,
                  'takenTime': recordList![i].takenTime,
                  'rating': recordList![i].rating,
                  'review': recordList![i].review,
                  'color': recordList![i].color,
                }));
              } else {
                // 존재하지 않는다면 새로운 리스트를 생성하고 CalendarEventModel 추가
                events[dateTimeKey] = [
                  CalendarEventModel.fromMap({
                    'id': recordList![i].id,
                    'currentTime': recordList![i].currentTime,
                    'takenTime': recordList![i].takenTime,
                    'rating': recordList![i].rating,
                    'review': recordList![i].review,
                    'color': recordList![i].color,
                  })
                ];
              }
            }

            return Center(
              child: Obx(
                () {
                  return
                      //  calendarController.holidayDateList.isEmpty
                      //     ? const Center(child: CircularProgressIndicator())
                      //     :
                      Column(
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
                        },
                        calendarBuilders: CalendarBuilders(
                          markerBuilder: (context, date, events) {
                            MarkerStyle markerStyle = MarkerStyle();
                            return events.isNotEmpty
                                ? markerStyle.buildEventsMarkerNum(events)
                                : Container();
                          },
                        ),
                        holidayPredicate: (date) =>
                            calendarController.holidayPredicate(date),

                        // 토요일, 일요일 글씨색
                        calendarStyle: const CalendarStyle(
                          markerSize: 8.0,

                          weekendTextStyle: TextStyle(color: Colors.red),
                          holidayTextStyle: TextStyle(color: Colors.red),
                          // 마커 말고 텍스트로 숫자를 넣어주는 방법도 고려
                        ),
                        // 캘린더 페이지를 이동해서 년도, 월이 바뀔 때 호출하는 콜백함수
                        onPageChanged: (focusedDay) {
                          calendarController.selectedDay.value = focusedDay;
                          // API로 휴일정보 받아와서 RxList에 휴일 이름과 날짜 넣어주는 함수
                          calendarController.getHolidayData(focusedDay.year,
                              formmatedDateType(focusedDay.month.toString()));
                        },
                      ),
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
                        child: CalendarDetail(
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

  /// 선택된 날짜를 알게해주는 함수
  void _daySelected(DateTime selectedDay, DateTime focusedDay) {
    calendarController.changeSelectedDay(selectedDay);
  }

  /// 1 ~ 9월에 0 붙여서 api형식 맞추는 함수
  String formmatedDateType(String month) {
    String formattedMonth = month.padLeft(2, '0');
    return formattedMonth;
  }
} // End