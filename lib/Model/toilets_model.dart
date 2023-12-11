// 전국 화장실 데이터 json 파일 불러와서 변환
class ToiletsModel{
  final String name;              // 화장실명
  final String address;           // 주소
  final String openingHours;      // 개방시간
  final double x;                 // 위도
  final double y;                 // 경도

  ToiletsModel(
    {
      required this.name,
      required this.address,
      required this.openingHours,
      required this.x,
      required this.y
    }
  );

  ToiletsModel.fromMap(Map<String, dynamic> res)
    : 
    name = res['화장실명'],
    address = res['주소'],
    openingHours = res['개방시간'],
    x = double.parse(res['위도'].toString()),
    y = double.parse(res['경도'].toString());
}