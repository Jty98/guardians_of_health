/*
  기능: 비밀번호 및 생체인증 기능들의 상태관리를하는 GetX Controller
*/

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:guardians_of_health_project/Components/snacbar_widget.dart';
import 'package:guardians_of_health_project/VM/database_handler.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecurityController extends GetxController {
  DatabaseHandler handler = DatabaseHandler();
  final LocalAuthentication auth = LocalAuthentication(); // 잠금 기능

  RxBool isFirstValue = false.obs; // 앱을 처음 킬때 value값

  late RxBool passwordValue = false.obs; // 비밀번호 스위치 상태
  late RxBool biometricsValue = false.obs; // 생체인식 스위치 상태
  RxList<RxBool> buttonClickStatus = RxList<RxBool>.generate(
      12, (index) => false.obs); // numberpad 버튼의 클릭 상태 관리
  late SharedPreferences prefs;

  @override
  void onInit() async {
    super.onInit();
    prefs = await SharedPreferences.getInstance();
  }

  // password 저장 변수
  RxString padNum = "".obs; // keypad에 입력될때 저장되는 변수
  String tempPadNum = ""; // 첫번째 다이얼로그가 닫히고 padNum가 초기화되기 때문에 temp로 넣어놓을 변수
  RxString verifyPadNum = "".obs; // 비밀번호 확인 다이얼로그 keypad에 입력될때 저장되는 변수
  bool saveStatus = false; // db에 저장 유무에 따른 bool값
  String? savedPassword =
      ""; // password로 로그인할 때 필요해서 앱 시작시에 password가 있으면 저장시키는 값
  RxBool isAuthenticating =
      false.obs; // faceid 진행 여부의 bool 값으로 화면 바뀔때 써서 RxBool

  /// keypad 변수 초기화
  resetNumber() {
    padNum = "".obs;
    verifyPadNum = "".obs;
    saveStatus = false;
  }

  /// 일반적인 인증을 수행
  /// authenticate 메서드를 사용하여 사용자 인증을 시도하기, biometricsValue는 switch value임
  /// @prams: 'int state' : (처음 들어올 때 띄우는 건 0, 저장할 때 띄우는건 1)
  authenticate(BuildContext context, int state) async {
    try {
      isAuthenticating.value = true; // faceid가 진행중이라 true
      biometricsValue.value = await auth.authenticate(
        localizedReason: '핸드폰 비밀번호를 입력해 주세요.',
        options: const AuthenticationOptions(
          stickyAuth: true,
        ),
      );

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (state == 0) {
          // faceid인증 성공한 경우에만 다이얼로그 닫고 스낵바 띄우기
          Get.back();
          showSnackbar(
              result: "환영합니다!",
              resultText: "오늘도 쾌변하세요!",
              resultbackColor: Theme.of(context).colorScheme.tertiary,
              resultTextColor: Theme.of(context).colorScheme.onTertiary,
              securityController: this,
              snackPosition: SnackPosition.BOTTOM,
              );
        } else {
          // 저장 성공한 경우에 스낵바 띄우기
          showSnackbar(
              result: "잠금 성공",
              resultText: "잠금이 성공적으로 설정되었습니다!",
              resultbackColor: Theme.of(context).colorScheme.tertiary,
              resultTextColor: Theme.of(context).colorScheme.onTertiary,
              securityController: this,
              snackPosition: SnackPosition.BOTTOM,
              );
        }
      });

      return biometricsValue.value;
    } on PlatformException catch (e) {
      if (e.code == 'NotAvailable') {
        // 생체 인식을 사용할 수 없는 경우에 대한 처리
        cancelAuthentication();
        state == 0
            ? biometricsValue.value = true
            : biometricsValue.value = false; // 실패한경우 스위치 끄기
      } else if (e.code == 'AuthenticationCanceled') {
        // 사용자가 생체인증을 취소하거나 실패한경우
        deleteBioSharePreferencese(); // sharedpreference에서 biostatus 지우기
        state == 0
            ? biometricsValue.value = true
            : biometricsValue.value = false; // 실패한경우 스위치 끄기
      } else {
        // 기타 오류에 대한 처리
      }
    } finally {
      // faceid인증이 끝나고 false
      isAuthenticating.value = false; // faceid가 끝나서 false
    }
  }

  /// 인증을 취소
  cancelAuthentication() async {
    await auth.stopAuthentication();
    isAuthenticating.value = false;
  }

  /// pw set
  savePwSharePreferencese() async {
    prefs.setBool('isPassword', passwordValue.value);
    prefs.setString('password', savedPassword!);

    // print("저장된 passwordValue: $passwordValue");
    // print("저장된 password: $savedPassword");
  }

  /// bio set
  saveBioSharePreferencese() async {
    prefs.setBool('isBio', biometricsValue.value);

    // print("저장된 biometricsValue: $biometricsValue");
  }

  /// delete Pw
  deletePwSharePreferencese() async {
    // isPassword 키에 대한 데이터 삭제
    prefs.remove('isPassword');

    // password 키에 대한 데이터 삭제
    prefs.remove('password');

    savedPassword = "";
  }

  /// delete Bio
  deleteBioSharePreferencese() async {
    // isPassword 키에 대한 데이터 삭제
    prefs.remove('isBio');
  }
}
