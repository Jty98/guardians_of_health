class CalendarEventModel {
  final DateTime actionDate;
  final String takenTime;
  final double rating;
  final String review;

  CalendarEventModel({required this.actionDate, required this.takenTime, required this.rating, required this.review});

  static fromMap(Map<String, Object?> e) {}

  // static fromMap(Map<String, Object?> row) {}
}
