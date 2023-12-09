/*
  비밀번호 및 생체인증 기능들의 상태관리를하는 GetX Controller
*/

import 'package:get/get.dart';
import 'package:guardians_of_health_project/Model/database_handler.dart';
import 'package:guardians_of_health_project/Model/password_model.dart';

class SettingController extends GetxController {
  DatabaseHandler handler = DatabaseHandler();

  RxBool passwordValue = false.obs; // 비밀번호 스위치 상태
  RxBool biometricsValue = false.obs; // 생체인식 스위치 상태
  RxList<RxBool> buttonClickStatus = 
      RxList<RxBool>.generate(12, (index) => false.obs); // 각 버튼의 클릭 상태 관리

  // password 저장 변수
  RxString padNum = "".obs;        // keypad에 입력될때 저장되는 변수
  String tempPadNum = "";    // 첫번째 다이얼로그가 닫히고 padNum가 초기화되기 때문에 temp로 넣어놓을 변수
  RxString verifyPadNum = "".obs;  // 비밀번호 확인 다이얼로그 keypad에 입력될때 저장되는 변수
  bool saveStatus = false;   // db에 저장 유무에 따른 bool값
  String? savedPassword = "";      // password로 로그인할때 필요해서 앱 시작시에 password가 있으면 저장시키는 값
  int? savedPwId = 0;              // password를 삭제시킬때 필요해서 앱 시작시에 저장시키는 id 값

  /// keypad 변수 초기화
  resetNumber() {
    padNum = "".obs;
    verifyPadNum = "".obs;
    saveStatus = false;
  }

  /// password 테이블 불러오기
  initPasswordValue() async {
    List<PasswordModel> passwordList = await handler.queryPassword();
    // 비밀번호와 pwStatus
    for (PasswordModel password in passwordList) {
      print('로그인된 id: ${password.id}');
      print('로그인된 Password: ${password.pw}');
      // pwStatus에 따라 초기값 지정
      password.pwStatus == 0
          ? passwordValue.value = false
          : passwordValue.value = true;
      savedPassword = password.pw; // pw 뽑아서 저장
      savedPwId = password.id; // id 뽑아서 저장
    }
  }

  /// password 저장
  savePassword(String pw, int pwStatus) async {
    var insertModel = PasswordModel(pw: pw, pwStatus: pwStatus);

    await handler.insertPassword(insertModel);
  }

  /// password 삭제
  Future deletePassword(int id) async {
    await handler.deletePassword(id);
    savedPwId = 0;
    print("$id id delete 성공");
  }
}
