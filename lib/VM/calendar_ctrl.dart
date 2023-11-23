import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CalendarController extends GetxController {
  TextEditingController eventController = TextEditingController();
  Rx<DateTime?> selectedDay = DateTime.now().obs;

  @override
  void dispose() {
    super.dispose();
    eventController.dispose();
  }

  void changeSelectedDay(DateTime newDay) {
    selectedDay.value = newDay;
  }
}
