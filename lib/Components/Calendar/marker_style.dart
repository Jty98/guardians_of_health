/*
  기능: table_calendar의 marker를 커스텀해주는 기능
*/

import 'package:flutter/material.dart';

class MarkerStyle{

  /// Marker의 스타일을 정의한 함수
AnimatedContainer buildCalendarDayMarker({
  required String text,
  required Color backColor,
}) {
  return AnimatedContainer(
    duration: const Duration(milliseconds: 300),
    decoration: BoxDecoration(
      shape: BoxShape.rectangle,
      color: backColor,
    ),
    width: 50,
    height: 13,
    child: Center(
      child: Text(
        text,
        style: const TextStyle().copyWith(
          color: Colors.white,
          fontSize: 11.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}

/// Marker의 세부 내용을 정의한 함수 
Widget buildEventsMarkerNum(List events) {
  return buildCalendarDayMarker(
      text: '${events.length}',
      backColor: events.length <= 1 ?Colors.green : events.length <= 2 ? Colors.blue : Colors.orange,
      );
}

}