import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guardians_of_health_project/Model/calendar_event_model.dart';
import 'package:guardians_of_health_project/VM/calendar_ctrl.dart';

class CalendarCard extends StatelessWidget {
  final List<String> timeList;
  final List<double> ratingList;
  final List<String> reviewList;
  final CalendarController calendarController;
  final events;

  const CalendarCard({
    Key? key,
    required this.timeList,
    required this.ratingList,
    required this.reviewList,
    required this.events,
    required this.calendarController,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GetBuilder<CalendarController>(
        builder: (controller) {
          DateTime? selectedDay = controller.selectedDay.value;
          List<CalendarEventModel> eventsForSelectedDay =
              _getEventsForDay(selectedDay);

          return ListView.builder(
            itemCount: eventsForSelectedDay.length,
            itemBuilder: (context, index) {
              DateTime actionDate = eventsForSelectedDay[index].actionDate;
              String takenTime = timeList[index];
              double rating = ratingList[index];
              String review = reviewList[index];

              return Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 4.0,
                ),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: ListTile(
                  onTap: () => print('${eventsForSelectedDay[index]}'),
                  title: Text('${eventsForSelectedDay[index]}'),
                  subtitle: Text(review),
                ),
              );
            },
          );
        },
      ),
    );
  }

  List<CalendarEventModel> _getEventsForDay(DateTime? selectedDay) {
    return selectedDay != null ? events[0][selectedDay] ?? [] : [];
  }
}
