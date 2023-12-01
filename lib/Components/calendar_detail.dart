import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:guardians_of_health_project/Model/calendar_event_model.dart';
import 'package:intl/intl.dart';

/// 캘린더 아래에 디테일 정보 위젯
/// @Params : `int` listLength : 클릭된 날짜의 이벤트 갯수
/// @Params : `DateTime` selectedDate : 클릭된 날짜
/// @Params : `Map<String, List<CalendarEventModel>>` events : 정보가 담겨있는 모델
Widget calendarDetail({
  required int listLength,
  required DateTime selectedDate,
  required Map<String, List<CalendarEventModel>> events,
}) {
  // event의 유무에 따라 다른 것 리턴
  return listLength == 0
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
              ),
            ],
          ),
        )
      : ListView.builder(
          itemCount: listLength,
          itemBuilder: (context, index) {
            // selectedDate를 달력에 있는 yyyy-MM-dd 형식의 문자열로 변환해서 데이터 가져오기
            String formattedDate =
                DateFormat('yyyy-MM-dd').format(selectedDate);
            List<CalendarEventModel> eventsForSelectedDate =
                events[formattedDate] ?? [];

            // 배변한 일자 중 시간만 뽑아내기
            String ddongTime = DateFormat('HH시 mm분')
                .format(eventsForSelectedDate[index].currentTime);
            // 걸린 시간
            String takenTime = eventsForSelectedDate[index].takenTime;
            // 특이사항
            String review = eventsForSelectedDate[index].review;
            // 만족도
            double rating = eventsForSelectedDate[index].rating;
            // 특이사항 띄워줄 텍스트필드
            TextEditingController reviewController =
                TextEditingController(text: review);

            return Slidable(
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
                            borderSide: BorderSide(color: Theme.of(context).colorScheme.onSecondary,),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20))),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
} // End

// --- Functions ---
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
