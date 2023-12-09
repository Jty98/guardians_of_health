import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth_android/local_auth_android.dart';// for AndroidAuthMessages
import 'package:local_auth_ios/local_auth_ios.dart';// for IOSAuthMessages


enum _SupportState { unknown, supported, unsupported }


class LocalAuth {
  static final _auth = LocalAuthentication();

  ///
  static Future<bool> hasBiometrics() async {
    try {
      //하드웨어 지원이 가능한지 여부만 표시되며 장치에 생체 인식이 등록되어 있는지 여부는 표시되지 않음
      return await _auth.canCheckBiometrics ?? false;
    } on PlatformException catch (e) {
      print(e);
    }
    return false;
  }

  ///
  static Future<List<BiometricType>> getBiometrics() async {
    try {
      //등록된 생체인식 목록을 얻기
      return await _auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }
    return <BiometricType>[];
  }

  ///
  static Future<bool> authenticate() async {
    final isAvailable = await hasBiometrics();
    if (!isAvailable) return false;

    try {
      // 가능한 경우 생체 인식 인증을 사용하지만 핀, 패턴 또는 비밀번호로 대체할 수도 있음
      return await _auth.authenticate(
        localizedReason: '생체정보를 인식해주세요.',
        options: const AuthenticationOptions(
          biometricOnly: true,
          useErrorDialogs: true, //기본 대화 상자를 사용하기
          stickyAuth: true,//false : 앱 재실행 되었을때 플러그인 인증을 재시도
        ),
        authMessages: [
            const IOSAuthMessages(
              lockOut: '생체인식 활성화',
              goToSettingsButton: '설정',
              goToSettingsDescription: '기기 설정으로 이동하여 생체 인식을 등록하세요.',
              cancelButton: '취소',
              localizedFallbackTitle: '다른 방법으로 인증',
            ),
            const AndroidAuthMessages(
              biometricHint: '생체 정보를 스캔하세요.',
              biometricNotRecognized: '생체정보가 일치하지 않습니다.',
              biometricRequiredTitle: '생체',
              biometricSuccess: '로그인',
              cancelButton: '취소',
              deviceCredentialsRequiredTitle: '생체인식이 필요합니다.',
              deviceCredentialsSetupDescription: '기기 설정으로 이동하여 생체 인식을 등록하세요.',
              goToSettingsButton: '설정',
              goToSettingsDescription: '기기 설정으로 이동하여 생체 인식을 등록하세요.',
              signInTitle: '계속하려면 생체 인식을 스캔',
            )
          ]
      );
    } on PlatformException catch (e) {
      print(e);
    }
    return false;
  }
}