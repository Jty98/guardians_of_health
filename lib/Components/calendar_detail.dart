import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guardians_of_health_project/Model/calendar_event_model.dart';
import 'package:guardians_of_health_project/VM/calendar_ctrl.dart';
import 'package:intl/intl.dart';

Widget calendarDetail({required List<dynamic> actionDate}) {
  final calendarController = Get.find<CalendarController>();

  return Expanded(
    child: ListView.builder(
      itemCount: actionDate.length,
      itemBuilder: (context, index) {
        // CalendarEventModel event = calendarController.events[index];
        // String formattedDate =
        //     DateFormat('yyyy-MM-dd').format(event.actionDate);
        // String formattedDate =
        //     DateFormat('yyyy-MM-dd').format(actionDate);
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            onTap: () => print(""),
            title: Text("${actionDate[index]}"),
          ),
        );
      },
    ),
  );
}
