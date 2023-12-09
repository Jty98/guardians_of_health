/*
  기능: password 조회를 위해서 있는 모델
*/

class PasswordModel {
  final int? id;
  final String? pw;
  final int pwStatus;

  PasswordModel({
    this.id,
    this.pw,
    required this.pwStatus,
  });

  PasswordModel.fromMap(Map<String, dynamic> res)
    : id = res['id'],
      pw = res['pw'],
      pwStatus = res['pwStatus'];

}