class RatingCountModelPerDay{
  final String perDateType;
  final double rating;
  final int countPerCategory;
  final double percentageOfTotal;

  RatingCountModelPerDay(
    {
      required this.perDateType,
      required this.rating,
      required this.countPerCategory,
      required this.percentageOfTotal
    }
  );

    // 데이터베이스에서 받아온 데이터를 Record 생성자에게 넘겨주는 생성자 정의
  RatingCountModelPerDay.fromMap(Map<String, dynamic> res)   
    :
      perDateType= res['inserted_per_date'],
      rating= res['rating'],
      countPerCategory= res['count_per_category'],
      percentageOfTotal= res['percentage_of_total'];


}