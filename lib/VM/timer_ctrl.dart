/*
  기능: 타이머 기능과 배변기록 저장할 때의 상태관리를 위한 GetXController
*/

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guardians_of_health_project/Model/database_handler.dart';
import 'package:guardians_of_health_project/Model/record_model.dart';

class TimerController extends GetxController {
  DatabaseHandler handler = DatabaseHandler();

  RxInt buttonStatus = 0.obs; // 버튼 상태 (flase는 누르지 않음 / true는 누름)
  RxBool animationStatus = true.obs; // 버튼 애니메이션 상태
  RxInt secondsUpdate = 0.obs; // 타이머를 실시간으로 저장하고 보여줄 변수
  bool animationStarted = false; // 타이머를 시작시키면 바뀌는 변수
  RxBool isLoading = true.obs; // 웹뷰의 로딩을 관리할 변수

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
  double rating = 3.0;

  RxList<bool> selectedShape = [true, false, false].obs;
  RxList<bool> selectedColors = [true, false, false, false, false].obs;
  RxList<bool> selectedSmells = [true, false, false].obs;



  /// 모양 선택 버튼 index
  selectedShapeFunc(int index) {
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
  }

  /// 색상 선택 버튼 index
  selectedColorsFunc(int index) {
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
  }

  /// 냄새 선택 버튼 index
  selectedSmellsFunc(int index) {
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
  }

  /// 기록 저장 바텀시트 초기화
  resetBottomSheetValues() {
    rating = 3.0;
    resultTextController.text = "";
    selectedShapeFunc(0);
    selectedColorsFunc(0);
    selectedSmellsFunc(0);
  }

  /// 투명도 초기화
  resetOpacityValues() {
    opacityUpdate1.value = 0.0;
    opacityUpdate2.value = 0.0;
    opacityUpdate3.value = 0.0;
    opacityUpdate4.value = 0.0;
  }

  /// 타이머 시작을 누르면 1초 간격으로 증가되게끔 하는 함수
  showTimer(bool status) {
    if (!status) {
      timer.cancel();
    } else {
      secondsUpdate.value = 0;
      timer = Timer.periodic(const Duration(seconds: 1), updateTimer);
    }
  }

  /// 타이머가 status에 따라서 돌아가고 멈추게하는 함수
  void updateTimer(Timer timer) {
    secondsUpdate.value++;
  }


  @override
  void dispose() {
    timer.cancel(); // 예시: 사용 중인 타이머를 취소
    resultTextController.dispose();
    super.dispose();
  }

  @override
  void onClose() {
    timer.cancel();
    super.onClose();
  }


  /// 타이머 돌아간 시간을 보기 좋게 변환하는 함수
  String formattedTime() {
    //String result = "";
    int hours = secondsUpdate.value ~/ 3600;
    int minutes = (secondsUpdate.value % 3600) ~/ 60;
    int seconds = secondsUpdate.value % 60;

    String hoursStr = hours.toString().padLeft(2, '0');
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');

    return '$hoursStr:$minutesStr:$secondsStr';
  }

  /// 결과 시간을 변환해주는 함수
  String resultFormattedTime() {
    int hours = secondsUpdate.value ~/ 3600;
    int minutes = (secondsUpdate.value % 3600) ~/ 60;
    int seconds = secondsUpdate.value % 60;

    // 차이를 문자열로 표시
    return '${hours > 0 ? '$hours시간 ' : ''}${minutes > 0 ? '$minutes분 ' : ''}${seconds >= 0 ? '$seconds초' : ''}';
  }

  /// 투명도 관련 애니메이션
  ///
  /// @Params : `RxDouble` opacityUpdate1 : 왼쪽 위 빵빠래 투명도
  /// @Params : `RxDouble` opacityUpdate2 : 오른쪽 아래 빵빠래 투명도
  /// @Params : `RxDouble` opacityUpdate3 : 가운데 빵빠래 투명도
  /// @Params : `RxDouble` opacityUpdate4 : 글씨 투명도 투명도
  ///
  double opacityUpdateFunction(int milliseconds, RxDouble update) {
    Future.delayed(Duration(milliseconds: milliseconds), () {
      if (update == opacityUpdate3) {
        update.value = 0.5;
      } else {
        update.value = 1.0;
      }
    });
    return update.value;
  }


  /// 기록 insert
  Future<bool> insertAction() async {
    bool result = false;
    DatabaseHandler handler = DatabaseHandler();

    var recordInsert = RecordModel(
      rating: rating,
      shape: resultShape,
      color: resultColor,
      smell: resultSmell,
      review: resultTextController.text,
      takenTime: formattedTime(),
      currentTime: DateTime.now().toString(),
    );
    int insertResult = await handler.insertAction(recordInsert);

    // result가 0보다 크면 true
    insertResult > 0 ? result = true : result = false;

    return result;
  }


} // End

