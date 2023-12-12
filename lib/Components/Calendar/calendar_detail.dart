// ignore_for_file: must_be_immutable

/*
  기능: table_calendar의 맨 아래의 디테일한 이벤트를 띄워주는 위젯
*/

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:guardians_of_health_project/Components/Calendar/calendar_widget.dart';
import 'package:guardians_of_health_project/Model/calendar_event_model.dart';
import 'package:guardians_of_health_project/Model/database_handler.dart';
import 'package:guardians_of_health_project/VM/calendar_ctrl.dart';
import 'package:intl/intl.dart';

/// 캘린더 아래에 디테일 정보 위젯
/// @Params : `int` listLength : 클릭된 날짜의 이벤트 갯수
/// @Params : `DateTime` selectedDate : 클릭된 날짜
/// @Params : `Map<String, List<CalendarEventModel>>` events : 정보가 담겨있는 모델
class CalendarDetail extends StatelessWidget {
  final int listLength;
  final DateTime selectedDate;
  final Map<String, List<CalendarEventModel>> events;
  final List<dynamic>? recordList;

  CalendarDetail({
    Key? key,
    required this.listLength,
    required this.selectedDate,
    required this.events,
    required this.recordList,
  }) : super(key: key);

  final DatabaseHandler handler = DatabaseHandler();
  final calendarController = Get.find<CalendarController>();
  String deleteTime = "";
  String formattedDate = "";

  @override
  Widget build(BuildContext context) {
    CalendarWidgetState? parent =
        context.findAncestorStateOfType<CalendarWidgetState>();

    return Obx(() {
      return calendarController
              .getEventsForDay(
                  calendarController.selectedDay.value!, recordList)
              .isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "🥲",
                    style: TextStyle(fontSize: 60),
                  ),
                  Text(
                    "아직 소식이 없다니 유감입니다..",
                    style: TextStyle(fontSize: 30),
                  )
                ],
              ),
            )
          : ListView.builder(
              itemCount: calendarController
                  .getEventsForDay(
                      calendarController.selectedDay.value!, recordList)
                  .length,
              itemBuilder: (context, index) {
                formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
                List<CalendarEventModel> eventsForSelectedDate =
                    events[formattedDate] ?? [];

                if (index < eventsForSelectedDate.length) {
                  CalendarEventModel? event;
                  event = eventsForSelectedDate[index];

                  int id = eventsForSelectedDate[index].id;
                  String ddongTime =
                      DateFormat('HH시 mm분').format(event.currentTime);
                  String takenTime = eventsForSelectedDate[index].takenTime;
                  String review = eventsForSelectedDate[index].review;
                  double rating = eventsForSelectedDate[index].rating;
                  String shape = eventsForSelectedDate[index].shape;
                  String smell = eventsForSelectedDate[index].smell;
                  String color = eventsForSelectedDate[index].color;

                  deleteTime = ddongTime;

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
                            calendarController.deleteRecord(id);
                            parent?.setState(() {});
                            deleteSnackbar(context);
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
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondary,
                                  ),
                                ),
                                Text(
                                  "소요시간: ${formattedTakenTime(index, takenTime)}",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondary,
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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "모양",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondary,
                                  ),
                                ),
                                Text(
                                  // shape,
                                  event.shape,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: returnShapeTextColor(shape),
                                  ),
                                ),
                                Text(
                                  "변색상",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondary,
                                  ),
                                ),
                                Container(
                                  width: 20,
                                  height: 20,
                                  color: returnDdongColor(color),
                                ),
                                Text(
                                  "냄새단계",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondary,
                                  ),
                                ),
                                Text(
                                  // smell,
                                  event.smell,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: returnSmellTextColor(smell),
                                  ),
                                ),
                              ],
                            ),
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
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(6, 0, 6, 10),
                            child: TextField(
                              style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                              ),
                              controller: reviewController,
                              readOnly: true,
                              maxLines: 3,
                              decoration: InputDecoration(
                                hintText: "내용이 없습니다.",
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondary,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return null;
              });
    });
  }

  /// 삭제시 나오는 스낵바
  deleteSnackbar(context) {
    Get.snackbar(
      "삭제완료",
      "$formattedDate 일자  $deleteTime 기록이 삭제되었습니다.",
      duration: const Duration(seconds: 3),
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      colorText: Theme.of(context).colorScheme.onTertiary,
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
      itemCount: 5,
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

/// 냄새에 따라서 달라지는 글자색 return 함수
Color? returnSmellTextColor(String smell) {
  switch (smell) {
    case "심각":
      // return Colors.red[300];
      return Colors.orange;
    case "보통":
      return Colors.blue;
    case "안남":
      return Colors.green;
    default:
      return Colors.green;
  }
}

/// 모양에 따라서 달라지는 글자색 return 함수
Color? returnShapeTextColor(String shape) {
  switch (shape) {
    case "바나나 모양":
      return Colors.amber;
    case "포도알 모양":
      return Colors.purple[200];
    case "설사":
      return Colors.orange;
    default:
      return Colors.green;
  }
}

/// 변 색상에 따라서 달라지는 글자색 return 함수
Color? returnDdongColor(String color) {
  switch (color) {
    case "황금색":
      return Colors.amber[700]!;
    case "진갈색":
      return Colors.brown[700]!;
    case "검정색":
      return Colors.black;
    case "빨간색":
      return Colors.red;
    case "녹색":
      return Colors.green;
    default:
      return Colors.amber[700]!;
  }
}
