import 'dart:typed_data';

class RecordModel{
  // 사용자의 배변 기록을 저장하는 테이블의 속성들을 정의하는 클래스
  // 필요한 속성 - 배변 이미지 : Uint8List type, 만족도(rating) : double type,
  // 배변에 대한 기록 : String(text) type, 배변 시간: Timestamp(now) type

  // property
  final int? id;                    // 기록의 순서 인덱스. 자동생성, auto increment primarykey
  final double rating;              // 배변 만족도
  final String shape;               // 배변 모양
  final String color;               // 배변 색상
  final String smell;               // 배변 냄새 단계
  final String review;              // 배변 상태 기록
  final String takenTime;           // 배변에 걸린 시간
  final String? currentTime;         // 현재 시간

  RecordModel(
    {
      this.id,
      required this.rating,
      required this.shape,
      required this.color,
      required this.smell,
      required this.review,
      required this.takenTime,
      this.currentTime
    }
  );

  // 데이터베이스에서 받아온 데이터를 Record 생성자에게 넘겨주는 생성자 정의
  RecordModel.fromMap(Map<String, dynamic> res)   
    :
      id= res['id'],
      rating= res['rating'], 
      shape= res['shape'],
      color= res['color'],
      smell= res['smell'],
      review= res['review'], 
      takenTime= res['takenTime'],
      currentTime= res['currentTime'];

}