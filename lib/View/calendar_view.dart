/*
  기능: 캘린더 탭에서 보여줄 뷰
*/

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guardians_of_health_project/Components/Calendar/calendar_widget.dart';
import 'package:guardians_of_health_project/VM/calendar_ctrl.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({super.key});

  @override
  State<CalendarView> createState() => CalendarViewState();
}

class CalendarViewState extends State<CalendarView> {
  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    CalendarController calendarController = Get.put(CalendarController());

    return const Scaffold(
      body: Center(
        child: Column(
          children: [
            CalendarWidget(),
          ],
        ),
      ),
    );
  }
}
