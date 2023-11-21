import 'package:flutter/material.dart';
import 'package:guardians_of_health_project/Components/Appbar/myappbar.dart';
import 'package:guardians_of_health_project/Components/calendar_widget.dart';

class CalendarView extends StatelessWidget {
  const CalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      body: Center(
        child: CalendarWidget(),
        ),
    );
  }
}