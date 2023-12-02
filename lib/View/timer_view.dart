/*
  기능: 타이머가 돌아가고있는 뷰
*/

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guardians_of_health_project/Components/Appbar/myappbar.dart';
import 'package:guardians_of_health_project/Components/Drawer/mydrawer.dart';
import 'package:guardians_of_health_project/VM/timer_ctrl.dart';
import 'package:guardians_of_health_project/View/timer_result_view.dart';

class TimerView extends StatelessWidget {
  const TimerView({super.key});

  @override
  Widget build(BuildContext context) {
    TimerController timerController = Get.find();

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: (){
        return Future(() => false);
      },
      child: Scaffold(
        appBar: const MyAppBar(),
        drawer: const MyDrawer(),
        body: GestureDetector(
          onTap: () {
            timerController.showTimer(false);
            Get.to(() => const TimerResultView(),
            transition: Transition.noTransition,
            );
          },
          child: Center(
            child: Container(
              width: 350.0,
              height: 350.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(200.0),
                color: Colors.green,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(() {
                      return Text(
                        timerController.formattedTime(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      "볼일이 끝나면 여기를 눌러주세요!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
} // End


