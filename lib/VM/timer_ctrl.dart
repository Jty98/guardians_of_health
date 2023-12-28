/*
  기능: 타이머 기능과 배변기록 저장할 때의 상태관리를 위한 GetXController
*/

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:guardians_of_health_project/VM/database_handler.dart';
import 'package:guardians_of_health_project/Model/record_model.dart';
import 'package:guardians_of_health_project/VM/stopwatch.dart';
import 'package:guardians_of_health_project/VM/timer_difference_handler.dart';

class TimerController extends GetxController
    with GetSingleTickerProviderStateMixin {
  DatabaseHandler handler = DatabaseHandler();

  late AnimationController animationController;
  late Animation<double> animation;
  bool isTimerRunning = false; // 타이머가 실행 중인지 여부 초기값: false
  final timerHandler =
      TimerDifferenceHandler.instance; // TimerDifferenceHandler 인스턴스 생성
  late StopWatch stopWatch; // StopWatch 클래스 선언

  RxBool animationStatus = true.obs; // 버튼 애니메이션 상태
  RxInt secondsUpdate = 0.obs; // 타이머를 실시간으로 저장하고 보여줄 변수

  // bottom sheet 변수들
  TextEditingController resultTextController = TextEditingController();

  // 투명도 변수들
  RxDouble opacityUpdate1 = 0.0.obs;
  RxDouble opacityUpdate2 = 0.0.obs;
  RxDouble opacityUpdate3 = 0.0.obs;
  RxDouble opacityUpdate4 = 0.0.obs;

  String resultShape = "바나나 모양";
  String resultColor = "황금색";
  String resultSmell = "심각";
  double rating = 3.0;

  RxList<bool> selectedShape = [true, false, false].obs;
  RxList<bool> selectedColors = [true, false, false, false, false].obs;
  RxList<bool> selectedSmells = [true, false, false].obs;

  @override
  void onInit() {
    super.onInit();

    // AnimationController 설정
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    // Tween 설정 (시작과 끝 값)
    animation = Tween<double>(begin: -20, end: 20).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOut,
      ),
    );

    // 애니메이션 반복
    animationController.repeat(reverse: true);
  }

  /// 초기 타이머로 백그라운드에 들어갈 때 backgroundTimerOperation()로 timerHandler.remainingSeconds를 타이머에 넣어줌
  void initTimerOperation() {
    //timer callbacks
    stopWatch = StopWatch(
      onTick: (seconds) {
        isTimerRunning = true;
        secondsUpdate.value = seconds;
      },
    );

    //native app life cycle
    SystemChannels.lifecycle.setMessageHandler((msg) {
      // On AppLifecycleState: paused
      if (msg == AppLifecycleState.paused.toString()) {
        if (isTimerRunning) {
          debugPrint(secondsUpdate.value.toString());
          stopWatch.pause(); // 더 이상 초를 전달하지 않음
        }
      }

      // On AppLifecycleState: resumed
      if (msg == AppLifecycleState.resumed.toString()) {
        if (isTimerRunning) {
          debugPrint(secondsUpdate.value.toString());
          backgroundTimerOperation();
          stopWatch.resume(); // 더 이상 초를 전달하지 않음
        }
      }
      return Future(() => null);
    });

    isTimerRunning = true;
    stopWatch.start();
  }

  /// 백그라운드 타이머로 초기에 onTick에서 seconds를 쓴것과 다르게 timerHandler.remainingSeconds를 사용
  void backgroundTimerOperation() {
    //timer callbacks
    stopWatch = StopWatch(
      onTick: (seconds) {
        isTimerRunning = true;
        secondsUpdate.value = timerHandler.remainingSeconds;
      },
    );

    isTimerRunning = true;
    stopWatch.start();
  }

  /// 타이머 정지
  void stopTimer() {
    isTimerRunning = false;
    timerHandler.resetInitialElapsedSeconds();
    stopWatch.stop();
  }

  /// 타이머 초기화
  void resetTimer() {
    isTimerRunning = false;
    stopTimer();
    stopWatch.cancel();
  }

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

  /// 타이머 돌아간 시간을 보기 좋게 변환하는 함수
  String formattedTime() {
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

  @override
  void onClose() {
    stopWatch.stop();
    stopWatch.cancel();
    super.onClose();
  }

  @override
  void dispose() {
    // 컨트롤러 제거 시 타이머 중지
    stopWatch.stop();
    stopWatch.cancel();
    super.dispose();
  }
} // End
