import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guardians_of_health_project/VM/calendar_ctrl.dart';

class TodayBanner extends StatelessWidget {
  final DateTime selectedDate;
  final int count;
  const TodayBanner({super.key, required this.selectedDate, required this.count});

  @override
  Widget build(BuildContext context) {

    return Container(
      color: Theme.of(context).colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${selectedDate.year}년 ${selectedDate.month}월 ${selectedDate.day}일',
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text('$count회',
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontSize: 16, fontWeight: FontWeight.bold),            
            )
          ],
        ),
      ),
    );
  }
}