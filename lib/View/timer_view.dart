/*
  기능: 타이머 돌아가는걸 볼 수 있으며 위로 슬라이드하면 웹뷰로 건강정보를 보여줌
*/

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:guardians_of_health_project/Components/health_info_widget.dart';
import 'package:guardians_of_health_project/VM/timer_ctrl.dart';
import 'package:guardians_of_health_project/VM/timer_difference_handler.dart';
import 'package:guardians_of_health_project/View/timer_result_view.dart';
import 'package:guardians_of_health_project/home.dart';

class TimerView extends StatelessWidget implements PreferredSizeWidget {
  final Function(ThemeMode) onChangeTheme;
  final Function(Color) onChangeThemeColor;

  const TimerView(
      {Key? key, required this.onChangeTheme, required this.onChangeThemeColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timerController = Get.find<TimerController>();
    final timerHandler = TimerDifferenceHandler.instance;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "골든타임",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: IconButton(
          onPressed: () {
            timerController.resetBottomSheetValues(); // 바텀시트 선택들 초기화
            timerHandler.resetInitialElapsedSeconds();
            timerController.secondsUpdate.value = 0;
            timerController.resetTimer();
            Get.offAll(
                () => Home(
                    onChangeTheme: onChangeTheme,
                    onChangeThemeColor: onChangeThemeColor),
                transition: Transition.noTransition);
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: 30.h,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
      body: PageView(
        scrollDirection: Axis.vertical,
        children: [
          buildTimerPage(timerController, context),
          healthInfoWidget(context: context),
        ],
      ),
    );
  }

  @override
  // preferredSize 지정
  Size get preferredSize => Size.fromHeight(56.h);

  Widget buildTimerPage(TimerController timerController, BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              Get.to(
                () => TimerResultView(
                    onChangeTheme: onChangeTheme,
                    onChangeThemeColor: onChangeThemeColor),
                transition: Transition.noTransition,
              );
              timerController.resetTimer();
            },
            child: Container(
              width: 350.0.w,
              height: 350.0.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(200.0.r),
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(() {
                      return Text(
                        timerController.formattedTime(),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
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
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 30.h,
          ),
          SizedBox(
            height: 30.h,
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
    );
  }
}
