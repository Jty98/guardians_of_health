import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TimerController extends GetxController {
  int buttonStatus = 0; // 버튼 상태 (flase는 누르지 않음 / true는 누름)
  RxBool animationStatus = true.obs; // 버튼 애니메이션 상태
  RxInt secondsUpdate = 0.obs; // 타이머를 실시간으로 저장하고 보여줄 변수
  late Timer timer;
  RxDouble opacityUpdate1 = 0.0.obs;
  RxDouble opacityUpdate2 = 0.0.obs;
  RxDouble opacityUpdate3 = 0.0.obs;
  RxDouble opacityUpdate4 = 0.0.obs;
  late TextEditingController resultTextController;
  
  

  // 버튼에 애니메이션 효과 부여
  startAnimation() async {
    resultTextController = TextEditingController();
    while (buttonStatus == 0) {
      print("buttonStatus: $buttonStatus");
      await Future.delayed(const Duration(seconds: 2));
      animationStatus.toggle();
    }
  }

  // 타이머 시작을 누르면 1초 간격으로 증가되게끔 하는 함수
  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), updateTimer);
  }

  // 타이머가 status에 따라서 돌아가고 멈추게하는 함수
  void updateTimer(Timer timer) {
    if (buttonStatus == 1) {
      secondsUpdate++;
    } else if (buttonStatus > 2) {
      timer.cancel();
    }
  }

  @override
  void dispose() {
    super.dispose();
    resultTextController.dispose();
  }

  // 화면이 소멸될 때 Timer 해제
  @override
  void onClose() {
    timer.cancel();
    super.onClose();
  }

  // 타이머 돌아간 시간을 보기 좋게 변환
  String formattedTime() {
    int hours = secondsUpdate.value ~/ 3600;
    int minutes = (secondsUpdate.value % 3600) ~/ 60;
    int seconds = secondsUpdate.value % 60;

    String hoursStr = hours.toString().padLeft(2, '0');
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');

    // print('$hoursStr:$minutesStr:$secondsStr');
    return '$hoursStr:$minutesStr:$secondsStr';
  }

double opacityUpdateFunction1() {
  if (buttonStatus == 2) {
    Future.delayed(const Duration(milliseconds: 600), () {
      opacityUpdate1.value = 1.0;
    });
  }
  return opacityUpdate1.value;
}
double opacityUpdateFunction2() {
  if (buttonStatus == 2) {
    Future.delayed(const Duration(milliseconds: 1200), () {
      opacityUpdate2.value = 1.0;
    });
  }
  return opacityUpdate2.value;
}
double opacityUpdateFunction3() {
  if (buttonStatus == 2) {
    Future.delayed(const Duration(milliseconds: 1800), () {
      opacityUpdate3.value = 0.7;
    });
  }
  return opacityUpdate3.value;
}
double opacityUpdateFunction4() {
  if (buttonStatus == 2) {
    Future.delayed(const Duration(milliseconds: 2400), () {
      opacityUpdate4.value = 1.0;
    });
  }
  return opacityUpdate4.value;
}
} // End

