import 'dart:async';

import 'package:get/get.dart';
import 'package:guardians_of_health_project/VM/timer_ctrl.dart';
import 'package:guardians_of_health_project/VM/timer_difference_handler.dart';

class StopWatch {
  TimerController timerController = Get.put(TimerController());
  int _initialElapsedSeconds = 0;
  late Timer _timer;
  final Function(int)? _onTick;
  final timerHandler = TimerDifferenceHandler.instance;
  bool onPausedCalled = false;

  StopWatch({
    Function(int)? onTick,
    Function()? onFinished,
  }) : _onTick = onTick;

  /// 타이머 시작
  void start() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      timerController.secondsUpdate.value++;
      if (_onTick != null) {
        _onTick!(timerController.secondsUpdate.value);

        // 백그라운드에 있을 때 timerHandler.remainingSeconds에서 가져온걸 secondsUpdate에 저장하게됨
        if (onPausedCalled) {
          int backgroundElapsedSeconds =
              timerHandler.remainingSeconds - _initialElapsedSeconds;
          timerController.secondsUpdate.value += backgroundElapsedSeconds;
          onPausedCalled = false;
        }
      }
    });
  }

  /// 타이머 캔슬
  void cancel() {
    _timer.cancel();
    _initialElapsedSeconds = 0;
  }

  /// 백그라운드로 나가진 순간
  void pause() {
    onPausedCalled = true;
    stop();
    _initialElapsedSeconds += timerHandler.remainingSeconds;
  }

  /// 백그라운드에서 다시 돌아온 순간
  void resume() {
    if (!onPausedCalled) {
      return;
    }

    timerController.secondsUpdate.value = _initialElapsedSeconds;
    start();
    onPausedCalled = false;
  }

  /// 타이머 스탑
  void stop() {
    _timer.cancel();
    _initialElapsedSeconds = 0;
  }
}