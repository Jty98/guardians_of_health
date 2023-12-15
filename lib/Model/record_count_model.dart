class RecordCountModel{
  final String perDateType;
  final int totalCount;

  RecordCountModel(
    {
      required this.perDateType,
      required this.totalCount
    }
  );

    // 데이터베이스에서 받아온 데이터를 Record 생성자에게 넘겨주는 생성자 정의
  RecordCountModel.fromMap(Map<String, dynamic> res)   
    :
      perDateType= res['inserted_per_date'],
      totalCount= res['total_count'];

}