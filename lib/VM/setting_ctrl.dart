import 'package:get/get.dart';

class SettingController extends GetxController {
  RxBool passwordValue = false.obs;   // 비밀번호 상태
  RxBool biometricsValue = false.obs; // 생체인식 상태
  
}