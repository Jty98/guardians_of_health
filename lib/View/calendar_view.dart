import 'package:flutter/material.dart';
import 'package:guardians_of_health_project/Components/calendar_widget.dart';

class CalendarView extends StatelessWidget {
  const CalendarView({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: CalendarWidget(),
        ),
    );
  }
}