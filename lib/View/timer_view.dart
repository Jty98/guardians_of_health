/*
  기능: 타이머 돌아가는걸 볼 수 있으며 위로 슬라이드하면 웹뷰로 건강정보를 보여줌
*/

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:guardians_of_health_project/VM/timer_ctrl.dart';
import 'package:guardians_of_health_project/View/health_info.dart';
import 'package:guardians_of_health_project/View/timer_result_view.dart';
import 'package:guardians_of_health_project/home.dart';

class TimerView extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const TimerView({Key? key});

  @override
  Widget build(BuildContext context) {
    TimerController timerController = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: const Text("골든타임"),
        leading: IconButton(
          onPressed: () {
            timerController.showTimer(false);
            timerController.secondsUpdate.value = 0;
            Get.offAll(
              () => const Home(),
              transition: Transition.noTransition,
            );
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: PageView(
        scrollDirection: Axis.vertical,
        children: [
          buildTimerPage(timerController),
          const HealthInfoPage(),
        ],
      ),
    );
  }

  Widget buildTimerPage(TimerController timerController) {
    return Center(
      child: GestureDetector(
        onTap: () {
          timerController.showTimer(false);
          Get.to(
            () => const TimerResultView(),
            transition: Transition.noTransition,
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 300.0.w,
              height: 350.0.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(200.0.r),
                color: Colors.green,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(() {
                      return Text(
                        timerController.formattedTime(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }),
                    SizedBox(
                      height: 30.h,
                    ),
                    Text(
                      "볼일이 끝나면 여기를 눌러주세요!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 40.h,
            ),
            Padding(
              padding: EdgeInsets.all(15.0.w),
              child: Text(
                "화면을 위로 올리면 장 건강정보가 나와요!",
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
              ),
            ),
            GetBuilder<TimerController>(
              builder: (controller) {
                return AnimatedBuilder(
                  animation: controller.animation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, controller.animation.value),
                      child: Icon(
                        Icons.keyboard_double_arrow_up_outlined,
                        size: 50,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
