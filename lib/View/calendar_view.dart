import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guardians_of_health_project/Components/calendar_widget.dart';
import 'package:guardians_of_health_project/VM/calendar_ctrl.dart';

class CalendarView extends StatelessWidget {
  const CalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    CalendarController calendarController = Get.put(CalendarController());

    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          children: [
            CalendarWidget(),
            
            
            // calendarDetail(actionDate: [])
          ],
        ),
      ),
    );
  }
}
