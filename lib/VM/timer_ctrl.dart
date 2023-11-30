import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TimerController extends GetxController {
  RxInt buttonStatus = 0.obs; // 버튼 상태 (flase는 누르지 않음 / true는 누름)
  RxBool animationStatus = true.obs; // 버튼 애니메이션 상태
  RxInt secondsUpdate = 0.obs; // 타이머를 실시간으로 저장하고 보여줄 변수
  bool animationStarted = false; // 타이머를 시작시키면 바뀌는 변수

  late Timer timer;
  // 투명도 변수들
  RxDouble opacityUpdate1 = 0.0.obs;
  RxDouble opacityUpdate2 = 0.0.obs;
  RxDouble opacityUpdate3 = 0.0.obs;
  RxDouble opacityUpdate4 = 0.0.obs;

  // bottom sheet 변수들
  TextEditingController resultTextController = TextEditingController();

  String resultShape = "바나나 모양";
  String resultColor = "황금색";
  String resultSmell = "심각";
  double rating = 0.0;




  RxList<bool> selectedShape = [true, false, false].obs;
  RxList<bool> selectedColors = [true, false, false, false, false].obs;
  RxList<bool> selectedSmells = [true, false, false].obs;

  shapeFunc(int index) {
    for (int i = 0; i < selectedShape.length; i++) {
      selectedShape[i] = i == index;
    }
    switch (index) {
      case 0:
        resultShape = "바나나 모양";
        break;
      case 1:
        resultShape = "포도알 모양";
        break;
      case 2:
        resultShape = "설사";
        break;
      default:
        resultShape = "바나나 모양";
    }
    print(index);
  }

  colorsFunc(int index) {
    for (int i = 0; i < selectedColors.length; i++) {
      selectedColors[i] = i == index;
    }
    switch (index) {
      case 0:
        resultColor = "황금색";
        break;
      case 1:
        resultColor = "진갈색";
        break;
      case 2:
        resultColor = "검정색";
        break;
      case 3:
        resultColor = "빨간색";
        break;
      case 4:
        resultColor = "녹색";
        break;
      default:
        resultColor = "황금색";
    }

    print(index);
  }

  smellsFunc(int index) {
    for (int i = 0; i < selectedSmells.length; i++) {
      selectedSmells[i] = i == index;
    }
    switch (index) {
      case 0:
        resultSmell = "심각";
        break;
      case 1:
        resultSmell = "보통";
        break;
      case 2:
        resultSmell = "안남";
        break;
      default:
        resultSmell = "심각";
    }
    print(index);
  }

  // 바텀시트 초기화
  resetValues() {
    rating = 0.0;
    resultTextController.text = "";
    shapeFunc(0);
    colorsFunc(0);
    smellsFunc(0);
  }

// 버튼에 애니메이션 효과 부여
  startAnimation() async {
    if (!animationStarted) {
      animationStarted = true;
      resultTextController = TextEditingController();

      while (buttonStatus.value == 0) {
        print("buttonStatus: $buttonStatus");
        await Future.delayed(const Duration(seconds: 2));
        if (buttonStatus.value == 0) {
          animationStatus.toggle();
        }
      }
    }
  }

  // 타이머 시작을 누르면 1초 간격으로 증가되게끔 하는 함수
  showTimer(bool status) {
    print("status: $status");
    if (!status) {
      timer.cancel();
    } else {
      secondsUpdate.value = 0;
      timer = Timer.periodic(const Duration(seconds: 1), updateTimer);
    }
  }

  // 타이머가 status에 따라서 돌아가고 멈추게하는 함수
  void updateTimer(Timer timer) {
    secondsUpdate.value++;
  }

  @override
  void dispose() {
    timer.cancel(); // 예시: 사용 중인 타이머를 취소
    resultTextController.dispose();
    super.dispose();
  }

  // 타이머 돌아간 시간을 보기 좋게 변환
  String formattedTime() {
    //String result = "";
    int hours = secondsUpdate.value ~/ 3600;
    int minutes = (secondsUpdate.value % 3600) ~/ 60;
    int seconds = secondsUpdate.value % 60;

    String hoursStr = hours.toString().padLeft(2, '0');
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');

    // print('$hoursStr:$minutesStr:$secondsStr');
    return '$hoursStr:$minutesStr:$secondsStr';
    // return result;
  }

  // 결과 시간을 변환해주는 함수
  String resultFormattedTime() {
    int hours = secondsUpdate.value ~/ 3600;
    int minutes = (secondsUpdate.value % 3600) ~/ 60;
    int seconds = secondsUpdate.value % 60;

    // 차이를 문자열로 표시

    return '${hours > 0 ? '$hours시간 ' : ''}${minutes > 0 ? '$minutes분 ' : ''}${seconds > 0 ? '$seconds초' : ''}';
  }

  double opacityUpdateFunction1() {
    Future.delayed(const Duration(milliseconds: 600), () {
      opacityUpdate1.value = 1.0;
    });
    return opacityUpdate1.value;
  }

  double opacityUpdateFunction2() {
    Future.delayed(const Duration(milliseconds: 1200), () {
      opacityUpdate2.value = 1.0;
    });
    return opacityUpdate2.value;
  }

  double opacityUpdateFunction3() {
    Future.delayed(const Duration(milliseconds: 1800), () {
      opacityUpdate3.value = 0.5;
    });
    return opacityUpdate3.value;
  }

  double opacityUpdateFunction4() {
    Future.delayed(const Duration(milliseconds: 2400), () {
      opacityUpdate4.value = 1.0;
    });
    return opacityUpdate4.value;
  }
} // End

