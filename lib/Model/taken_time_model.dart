class TakenTimeModel{
  final String perDateType;
  final double takenTime;

  TakenTimeModel(
    {
      required this.perDateType,
      required this.takenTime
    }
  );

    // 데이터베이스에서 받아온 데이터를 Record 생성자에게 넘겨주는 생성자 정의
  TakenTimeModel.fromMap(Map<String, dynamic> res)   
    :
      perDateType= res['inserted_per_date'],
      takenTime= res['takenTime'];  
}