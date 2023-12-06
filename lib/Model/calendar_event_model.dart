/*
  기능: table_calendar의 event들을 해당하는 날짜와 그에따른 정보들로 저장하기위한 모델
  ex). 2023.11.11 : {takenTime=6분, rating=4.5, review=굿, color=빨강}
*/

/// 캘린더의 이벤트를 보여주기위한 모델
class CalendarEventModel {
  final int id;               // 저장된 이벤트의 id
  final DateTime currentTime; // 저장할때의 시간
  final String takenTime;     // 배변 중 걸린시간
  final double rating;        // 배변 만족도
  final String review;        // 배변시 특이사항
  final String shape;         // 배변 모양
  final String smell;         // 배변 모양
  final String color;         // 배변 색상

  CalendarEventModel(
      {required this.id,
      required this.currentTime,
      required this.takenTime,
      required this.rating,
      required this.review,
      required this.shape,
      required this.smell,
      required this.color});

  CalendarEventModel.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        // currentTime = res['currentTime'] != null
        //     ? DateTime.parse(res['currentTime'])
        //     : DateTime.now(),
        currentTime = DateTime.parse(res['currentTime']),
        takenTime = res['takenTime'],
        rating = res['rating'],
        review = res['review'],
        shape = res['shape'],
        smell = res['smell'],
        color = res['color'];
}
