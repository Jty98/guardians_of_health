/*
  기능: table_calendar의 중간 날짜와 카운트를 보여주는 배너 위젯
*/
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TodayBanner extends StatelessWidget {
  final DateTime selectedDate;
  final int count;
  const TodayBanner({super.key, required this.selectedDate, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.primary,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${selectedDate.year}년 ${selectedDate.month}월 ${selectedDate.day}일',
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
            Text('$count회',
                style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontSize: 16.sp, fontWeight: FontWeight.bold),            
                ),
          ],
        ),
      ),
    );
  }
}