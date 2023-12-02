class CalendarEventModel {
  final DateTime currentTime;
  final String takenTime;
  final double rating;
  final String review;
  final String color;

  CalendarEventModel(
      {required this.currentTime,
      required this.takenTime,
      required this.rating,
      required this.review,
      required this.color
      });

  // fromMap 메서드 추가
CalendarEventModel.fromMap(Map<String, dynamic> res)
      : currentTime = res['currentTime'] != null ? DateTime.parse(res['currentTime']) : DateTime.now(),
        takenTime = res['takenTime'],
        rating = res['rating'],
        review = res['review'],
        color = res['color']
        ;

//   static CalendarEventModel fromMap(Map<String, Object?> map) {
//     return CalendarEventModel(
//       actionDate: map['currentTime'] as DateTime, // currentTime을 actionDate에 매핑
//       takenTime: map['takenTime'] as String,
//       rating: (map['rating'] as num).toDouble(), // rating을 double로 변환
//       review: map['review'] as String,
//     );
// }
}
