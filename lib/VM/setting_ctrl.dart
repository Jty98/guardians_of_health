import 'package:get/get.dart';

class SettingController extends GetxController {
  RxBool passwordValue = false.obs; // 비밀번호 스위치 상태
  RxBool biometricsValue = false.obs; // 생체인식 스위치 상태
  RxList<RxBool> buttonClickStatus =
      RxList<RxBool>.generate(12, (index) => false.obs); // 각 버튼의 클릭 상태 관리

  // RxList<int>? passwordList =
  //     [-1, -1, -1, -1].obs; // password를 입력할때 번호가 들어가는 리스트
  // RxList<int>? verifyPasswordList =
  //     <int>[-1, -1, -1, -1].obs; // password 확인할때의 리스트
  // RxList<int>? tempList = <int>[-1, -1, -1, -1].obs;

  //
  RxString padNum = "".obs;
  RxString tempPadNum = "".obs;
  RxString verifyPadNum = "".obs;

  /// keypad 리스트 초기화
  resetNumber() {
    padNum = "".obs;
    verifyPadNum = "".obs;
  }
}
