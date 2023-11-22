import 'package:get/get.dart';

class CalendarController extends GetxController {
  Rx<DateTime?> selectedDay = DateTime.now().obs;

  void changeSelectedDay(DateTime newDay) {
    selectedDay.value = newDay;
  }
}
