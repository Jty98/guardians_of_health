/*
  기능: 첫 페이지로 타이머를 시작할 수 있는 뷰
*/

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guardians_of_health_project/Components/first_numberpad_view.dart';
import 'package:guardians_of_health_project/VM/setting_ctrl.dart';
import 'package:guardians_of_health_project/VM/timer_ctrl.dart';
import 'package:guardians_of_health_project/View/timer_view.dart';

class MainPageView extends StatefulWidget {
  const MainPageView({super.key});

  @override
  State<MainPageView> createState() => _MainPageViewState();
}

class _MainPageViewState extends State<MainPageView> {
  TimerController timerController = Get.put(TimerController());
  final settingController = Get.find<SettingController>();

  late bool animationStatus; // 애니메이션 status로 false와 true가 2초마다 반복되면서 애니메이션 작동
  Timer? animationTimer; // 애니메이션이 2초마다 동작하기위한 타이머

  @override
  void initState() {
    super.initState();
    animationStatus = false;
    startAnimation();
  }

  @override
  void dispose() {
    animationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () {
            // true값을 넣어줘서 timer 작동시키고 타이머 보이는 화면으로 이동
            timerController.showTimer(true);
            Get.to(
              () => const TimerView(),
              transition: Transition.noTransition,
            );
          },
          child: AnimatedContainer(
            duration: const Duration(seconds: 2),
            curve: Curves.easeInOut,
            width: animationStatus ? 320.0 : 370.0,
            height: animationStatus ? 320.0 : 370.0,
            decoration: BoxDecoration(
              color:
                  animationStatus ? Colors.green[500] : Colors.amber[500],
              borderRadius: BorderRadius.circular(200.0),
            ),
            child: const Center(
              child: Text(
                "볼일을 시작하면 여기를 눌러주세요!",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  // --- Functions ---

  // 버튼에 애니메이션 효과 부여
  void startAnimation() {
    animationTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      // mounted는 트리내에 위젯이 속해있나 없나의 bool값
      if (mounted) {
        animationStatus = !animationStatus;
        setState(() {});
      } else {
        timer.cancel(); // 위젯이 dispose된 경우 타이머 취소
      }
    });
  }
} // End
