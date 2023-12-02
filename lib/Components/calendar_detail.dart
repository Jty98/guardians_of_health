/*
  기능: table_calendar의 맨 아래의 디테일한 이벤트를 띄워주는 위젯
*/

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:guardians_of_health_project/Model/calendar_event_model.dart';
import 'package:guardians_of_health_project/Model/database_handler.dart';
import 'package:intl/intl.dart';

/// 캘린더 아래에 디테일 정보 위젯
/// @Params : `int` listLength : 클릭된 날짜의 이벤트 갯수
/// @Params : `DateTime` selectedDate : 클릭된 날짜
/// @Params : `Map<String, List<CalendarEventModel>>` events : 정보가 담겨있는 모델
class CalendarDetail extends StatelessWidget {
  final int listLength;
  final DateTime selectedDate;
  final Map<String, List<CalendarEventModel>> events;

  CalendarDetail({
    Key? key,
    required this.listLength,
    required this.selectedDate,
    required this.events,
  }) : super(key: key);

  final DatabaseHandler handler = DatabaseHandler();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: listLength,
      itemBuilder: (context, index) {
        String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
        List<CalendarEventModel> eventsForSelectedDate =
            events[formattedDate] ?? [];

        int id = eventsForSelectedDate[index].id;
        String ddongTime = DateFormat('HH시 mm분')
            .format(eventsForSelectedDate[index].currentTime);
        String takenTime = eventsForSelectedDate[index].takenTime;
        String review = eventsForSelectedDate[index].review;
        double rating = eventsForSelectedDate[index].rating;

        TextEditingController reviewController =
            TextEditingController(text: review);

        return Slidable(
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                icon: Icons.delete,
                foregroundColor: Colors.white,
                backgroundColor: Colors.red,
                label: "기록삭제",
                onPressed: (context) {
                  _showDeleteActionSheet(context, handler, id);
                },
              ),
            ],
          ),
          child: Card(
            color: Theme.of(context).colorScheme.secondary,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        ddongTime,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                      ),
                      Text(
                        "소요시간: ${formattedTakenTime(index, takenTime)}",
                        style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  "만족도",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: starRatingbar(rating),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        "특이사항 내용",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(6, 0, 6, 10),
                  child: TextField(
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                    controller: reviewController,
                    readOnly: true,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: "내용이 없습니다.",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 삭제할 것인가 묻는 액션시트
  void _showDeleteActionSheet(BuildContext context, handler, id) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return _deleteActionSheet(context, handler, id);
      },
    );
  }

  /// 액션시트 구조
  CupertinoActionSheet _deleteActionSheet(context, handler, id) {
    return CupertinoActionSheet(
      title: const Text(
        "기록을 삭제하시겠습니까?",
        style: TextStyle(fontSize: 16, color: Colors.black),
      ),
      actions: [
        CupertinoActionSheetAction(
          onPressed: () async {
            // 삭제시 화면 새로고침 안되는거 생각해보기
            handler.deleteRecord(id);
            await handler.queryRecord();
            Get.back();
            // Get.to(() => const CalendarView());
            // Get.back();
          },
          child: const Text(
            "삭제",
            style: TextStyle(fontSize: 16, color: Colors.blue),
          ),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        onPressed: () {
          //
          Get.back();
        },
        child: const Text(
          "취소",
          style: TextStyle(fontSize: 16, color: Colors.red),
        ),
      ),
    );
  }

  /// Duration으로 바꿔서 시간, 분, 초로 return 해주는 함수
  durationFromString(String timeString) {
    List<String> parts = timeString.split(':');
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    int seconds = int.parse(parts[2]);

    return Duration(hours: hours, minutes: minutes, seconds: seconds);
  }

  /// 시, 분, 초를 붙인 포맷으로 바꿔주는 함수
  String formattedTakenTime(int index, String takenTime) {
    // formattedTime을 Duration으로 변환
    Duration formattedDuration = durationFromString(takenTime);

    // Duration을 초단위로 계산해서 int로 저장
    int intDuration = formattedDuration.inSeconds.abs();

    int hours = intDuration ~/ 3600;
    int minutes = (intDuration % 3600) ~/ 60;
    int seconds = intDuration % 60;

    // 차이를 문자열로 표시

    return '${hours > 0 ? '$hours시간 ' : ''}${minutes > 0 ? '$minutes분 ' : ''}${seconds >= 0 ? '$seconds초' : ''}';
  }

  /// 별점 위젯 (만족도 double값에 따라 표정 아이콘 하나만 보여주는 것도 고려)
  Widget starRatingbar(
    double resultRating,
  ) {
    return RatingBarIndicator(
      unratedColor: Colors.grey[300],
      rating: resultRating,
      direction: Axis.horizontal,
      itemCount: 5, // itemCount를 설정하세요.
      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, index) {
        switch (index) {
          case 0:
            return Icon(
              Icons.sentiment_very_dissatisfied,
              color: returnIconColors(resultRating),
            );
          case 1:
            return Icon(
              Icons.sentiment_dissatisfied,
              color: returnIconColors(resultRating),
            );
          case 2:
            return Icon(
              Icons.sentiment_neutral,
              color: returnIconColors(resultRating),
            );
          case 3:
            return Icon(
              Icons.sentiment_satisfied,
              color: returnIconColors(resultRating),
            );
          case 4:
            return Icon(
              Icons.sentiment_very_satisfied,
              color: returnIconColors(resultRating),
            );
          default:
            return Container();
        }
      },
    );
  }

  /// 별점에 따라 달라지는 컬러값 함수
  Color returnIconColors(double rating) {
    return rating > 4
        ? Colors.green
        : rating > 3
            ? Colors.lightGreen
            : rating > 2
                ? Colors.amber
                : rating > 1
                    ? Colors.redAccent
                    : Colors.red;
  }
}
