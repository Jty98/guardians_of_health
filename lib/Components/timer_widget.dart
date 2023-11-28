import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guardians_of_health_project/Components/insert_buttomsheet.dart';
import 'package:guardians_of_health_project/VM/timer_ctrl.dart';
import 'package:guardians_of_health_project/View/mainpage_view.dart';
import 'package:guardians_of_health_project/home.dart';

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
              print("buttonStatus: ${timerController.buttonStatus}");
              // status가 1이 되는 시점에 시작
              if (timerController.buttonStatus == 1) {
                timerController.startTimer();
              } else if (timerController.buttonStatus == 2) {
                Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MainPageView()))
                    .then((value) {});
              }
              print("new buttonStatus: ${timerController.buttonStatus}");
            },
            child: Obx(
              () {
                switch (timerController.buttonStatus) {
                  case 0:
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
                          "볼일을 시작하면 나를 눌러주세요!",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  case 1:
                    return Container(
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
                            Text(
                              timerController.formattedTime(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            const Text(
                              "볼일이 끝나면 나를 눌러주세요!",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  case 2:
                    return Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                              child: AnimatedOpacity(
                                opacity:
                                    timerController.opacityUpdateFunction1(),
                                duration: const Duration(milliseconds: 600),
                                child: SizedBox(
                                  width: 70,
                                  height: 70,
                                  child: Image.asset(
                                    "assets/images/firecracker1.png",
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 350,
                          height: 350,
                          child: Stack(
                            children: [
                              AnimatedOpacity(
                                opacity:
                                    timerController.opacityUpdateFunction3(),
                                duration: const Duration(milliseconds: 1800),
                                child: Image.asset(
                                  "assets/images/firecracker3.png",
                                ),
                              ),
                              Center(
                                child: AnimatedOpacity(
                                  duration: const Duration(milliseconds: 2400),
                                  opacity:
                                      timerController.opacityUpdateFunction4(),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "총 ${timerController.formattedTime()}이 걸렸습니다!",
                                        style: const TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "",
                                        style: const TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 40, 0),
                              child: AnimatedOpacity(
                                opacity:
                                    timerController.opacityUpdateFunction2(),
                                duration: const Duration(milliseconds: 1200),
                                child: SizedBox(
                                  width: 70,
                                  height: 70,
                                  child: Image.asset(
                                    "assets/images/firecracker2.png",
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {
                            insertBottomSheet(context);
                          },
                          child: const Text("기록 남기러가기"),
                        ),
                        timerController.buttonStatus == 2
                            ? TextButton(
                                onPressed: () {
                                  timerController.buttonStatus = 0;
                                  Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const MainPageView()))
                                      .then((value) {});
                                },
                                child: const Column(
                                  children: [
                                    Icon(Icons.refresh),
                                    Text(
                                      "다시하기",
                                      style: TextStyle(
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox(),
                      ],
                    );
                  default:
                    return Container(
                        color: Colors.black, width: 300, height: 300);
                }
              },
            ),
          ),
        );
      },
    );
  }

  // --- Functions ---
} // End
