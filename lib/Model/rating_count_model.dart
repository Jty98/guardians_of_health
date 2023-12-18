class RatingCountModel {
  final double rating;
  final int countPerCategory;

  RatingCountModel(
    {
      required this.rating,
      required this.countPerCategory
    }
  );

    // 데이터베이스에서 받아온 데이터를 Record 생성자에게 넘겨주는 생성자 정의
  RatingCountModel.fromMap(Map<String, dynamic> res)   
    :
      rating= res['rating'],
      countPerCategory= res['total_count_per_category'];

}