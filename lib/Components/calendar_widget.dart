import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guardians_of_health_project/Model/calendar_event_model.dart';
import 'package:guardians_of_health_project/VM/calendar_ctrl.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarWidget extends StatelessWidget {
  CalendarWidget({super.key});

  final CalendarController calendarController = Get.put(CalendarController());
  DateTime focusedDay = DateTime.now();
  Map<DateTime, List<CalendarEventModel>> events = {}; // 날짜별로 이벤트값을 저장함

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Center(
      child: Obx(
        () {
          return TableCalendar(
            rowHeight: 60,
            focusedDay: calendarController.selectedDay.value!,
            firstDay: DateTime.utc(2000, 1, 1),
            lastDay: DateTime.utc(2050, 12, 31),
            locale: "ko_KR",
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            onDaySelected: _daySelected,
            selectedDayPredicate: (day) =>
                isSameDay(day, calendarController.selectedDay.value!),
          );
        },
      ),
    );
  }



  // --- Functions ---
  void _daySelected(DateTime selectedDay, DateTime _) {
    calendarController.changeSelectedDay(selectedDay);
  }




} // End
