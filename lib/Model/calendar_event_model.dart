class CalendarEventModel {
  final DateTime actionDate;
  final String takenTime;
  final double rating;
  final String review;

  CalendarEventModel(
      {required this.actionDate,
      required this.takenTime,
      required this.rating,
      required this.review});

  // fromMap 메서드 추가
CalendarEventModel.fromMap(Map<String, dynamic> res)
      : actionDate = res['actionDate'] != null ? DateTime.parse(res['actionDate']) : DateTime.now(),
        takenTime = res['takenTime'],
        rating = res['rating'],
        review = res['review'];

//   static CalendarEventModel fromMap(Map<String, Object?> map) {
//     return CalendarEventModel(
//       actionDate: map['currentTime'] as DateTime, // currentTime을 actionDate에 매핑
//       takenTime: map['takenTime'] as String,
//       rating: (map['rating'] as num).toDouble(), // rating을 double로 변환
//       review: map['review'] as String,
//     );
// }
}
