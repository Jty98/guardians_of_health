class UserInfo{
  // 사용자의 신체 정보
  // 나이, 질병기록, 성별, 키, 몸무게
  // 필요한 속성 - 나이 : int type, 성별 : boolean type,
  // 키 : int type, 몸무게 : int type, 질병 기록 : String (text) type

  // property
  final int? id;                    // 기록의 순서 인덱스. 자동생성, auto increment primarykey
  final int age;                    // 나이
  final bool sex;                   // 성별
  final int height;                 // 키
  final int weight;                 // 몸무게
  final String diseaseRecords;      // 질병 기록

  UserInfo(
    {
      this.id,
      required this.age,
      required this.sex,
      required this.height,
      required this.weight,
      required this.diseaseRecords
    }
  );

  // 데이터베이스에서 받아온 데이터를 Record 생성자에게 넘겨주는 생성자 정의
  UserInfo.fromMap(Map<String, dynamic> res)   
    :
      id= res['id'],
      age= res['age'], 
      sex= res['sex'], 
      height= res['height'], 
      weight= res['weight'], 
      diseaseRecords= res['diseaseRecords'];

}