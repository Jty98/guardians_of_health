import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guardians_of_health_project/VM/timer_ctrl.dart';

class TimerWidget extends StatelessWidget {
  const TimerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TimerController timerController = Get.put(TimerController());

    return FutureBuilder<dynamic>(
      future: () {
        timerController.startAnimation();
      }(),
      builder: (context, snapshot) {
        return Center(
          child: GestureDetector(
            onTap: () {
              timerController.buttonStatus++;
              print(timerController.buttonStatus);
                  // status가 1이 되는 시점에 시작
              if (timerController.buttonStatus == 1) {
                timerController.startTimer();
              }
            },
            child: Obx(
              () {
                if (timerController.buttonStatus == 0) {
                  // status가 0일 때
                  return AnimatedContainer(
                    duration: const Duration(seconds: 2),
                    curve: Curves.easeInOut,
                    width:
                        timerController.animationStatus.value ? 350.0 : 300.0,
                    height:
                        timerController.animationStatus.value ? 350.0 : 300.0,
                    decoration: BoxDecoration(
                      color: timerController.animationStatus.value
                          ? Colors.blue
                          : Colors.amber,
                      borderRadius: BorderRadius.circular(200.0),
                    ),
                    child: const Center(
                      child: Text(
                        "배변을 시작하면 나를 눌러주세요!",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                } else {
                  // status가 1일때 타이머를 보여줌
                  return Container(
                    width: 350.0,
                    height: 350.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(200.0),
                      color: Colors.green, // 다른 Container의 색상 등 설정
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            timerController.formattedTime(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 30,),
                          const Text(
                            "배변이 끝나면 나를 눌러주세요!",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }
}
