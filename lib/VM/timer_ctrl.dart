import 'dart:async';

import 'package:get/get.dart';

class TimerController extends GetxController {
  int buttonStatus = 0; // 버튼 상태 (flase는 누르지 않음 / true는 누름)
  RxBool animationStatus = true.obs; // 버튼 애니메이션 상태
  RxInt secondsUpdate = 0.obs; // 타이머를 실시간으로 저장하고 보여줄 변수
  late Timer timer;

  // 버튼에 애니메이션 효과 부여
  startAnimation() async {
    while (buttonStatus == 0) {
      print("buttonStatus: $buttonStatus");
      await Future.delayed(const Duration(seconds: 2));
      animationStatus.toggle();
    }
  }

  // 타이머 시작을 누르면 1초 간격으로 증가되게끔 하는 함수
  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), _updateTimer);
  }

  // 타이머가 status에 따라서 돌아가고 멈추게하는 함수
  void _updateTimer(Timer timer) {
    if (buttonStatus == 1) {
      secondsUpdate++;
    }else if(buttonStatus > 2){
      timer.cancel();
    }
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





} // End

