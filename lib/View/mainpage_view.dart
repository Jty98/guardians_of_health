import 'package:flutter/material.dart';
import 'package:guardians_of_health_project/Components/timer_widget.dart';

class MainPageView extends StatelessWidget {
  const MainPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TimerWidget(),
          ],
        ),
      ),
    );
  }
}