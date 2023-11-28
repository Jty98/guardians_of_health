import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TimerController extends GetxController {
  int buttonStatus = 0; // 버튼 상태 (flase는 누르지 않음 / true는 누름)
  RxBool animationStatus = true.obs; // 버튼 애니메이션 상태
  RxInt secondsUpdate = 0.obs; // 타이머를 실시간으로 저장하고 보여줄 변수
  late Timer timer;
  // 투명도 변수들
  RxDouble opacityUpdate1 = 0.0.obs;
  RxDouble opacityUpdate2 = 0.0.obs;
  RxDouble opacityUpdate3 = 0.0.obs;
  RxDouble opacityUpdate4 = 0.0.obs;

  // bottom sheet 변수들
  // String resultRating = "";
  String resultShape = "";
  String resultColor = "";
  String resultSmell = "";
  // String resultReview = "";

  RxList<Widget> shape = <Widget>[
    SizedBox(
        width: 40, height: 40, child: Image.asset("assets/images/banana.png")),
    SizedBox(
        width: 40, height: 40, child: Image.asset("assets/images/grape.png")),
    SizedBox(
        width: 40, height: 40, child: Image.asset("assets/images/water.png")),
  ].obs;

  RxList<Widget> colors = <Widget>[
    Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.amber[700],
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    Container(
      width: 35,
      height: 35,
      decoration: BoxDecoration(
        color: Colors.brown[700],
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    Container(
      width: 35,
      height: 35,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    Container(
      width: 35,
      height: 35,
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    Container(
      width: 35,
      height: 35,
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  ].obs;

  RxList<Widget> smells = <Widget>[
    const SizedBox(
        width: 40,
        height: 40,
        child: Text(
          "상",
          style: TextStyle(fontSize: 25),
          textAlign: TextAlign.center,
        )),
    const SizedBox(
        width: 40,
        height: 40,
        child: Text(
          "중",
          style: TextStyle(fontSize: 25),
          textAlign: TextAlign.center,
        )),
    const SizedBox(
        width: 40,
        height: 40,
        child: Text(
          "하",
          style: TextStyle(fontSize: 25),
          textAlign: TextAlign.center,
        )),
  ].obs;

  RxList<bool> selectedShape = [true, false, false].obs;
  RxList<bool> selectedColors = [true, false, false, false, false].obs;
  RxList<bool> selectedSmells = [true, false, false].obs;

  late TextEditingController resultTextController;

  shapeFunc(int index) {
    for (int i = 0; i < selectedShape.length; i++) {
      selectedShape[i] = i == index;
    }
    switch (index) {
      case 0:
        resultShape = "바나나 모양";
      case 1:
        resultShape = "포도알 모양";
      case 2:
        resultShape = "설사";
      default:
        break;
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
      case 1:
        resultColor = "진갈색";
      case 2:
        resultColor = "검정색";
      case 3:
        resultColor = "빨간색";
      case 4:
        resultColor = "녹색";
      default:
        break;
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
      case 1:
        resultSmell = "보통";
      case 2:
        resultSmell = "안남";
      default:
        break;
    }
    print(index);
  }

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

