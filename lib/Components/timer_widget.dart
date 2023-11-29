import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guardians_of_health_project/Components/insert_buttomsheet.dart';
import 'package:guardians_of_health_project/Model/database_handler.dart';
import 'package:guardians_of_health_project/VM/timer_ctrl.dart';
import 'package:guardians_of_health_project/View/mainpage_view.dart';
import 'package:guardians_of_health_project/main.dart';
import 'package:intl/intl.dart'; // 시간 계산하기위한 라이브러리

class TimerWidget extends StatelessWidget {
  const TimerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TimerController timerController = Get.put(TimerController());
    final DatabaseHandler handler = DatabaseHandler();
    List timeList = [];
    String averageTimeResult = "";
    String timeDifference = ""; // 평균과의 차이를 저장할 전역 변수
    String result = ""; // 결과를 저장할 전역 변수

    return FutureBuilder<List<dynamic>>(
      future: (() async {
        List result = [];
        result.add(await timerController.startAnimation());
        result.add(await handler.queryRecord());
        return result;
      })(), // 함수를 직접 호출하는 부분 제거
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            List? timerRecord = snapshot.data?[1];
            for (int i = 0; i < timerRecord!.length; i++) {
              timeList.add(timerRecord[i].takenTime);
              print("timerRecord: ${timerRecord[i].takenTime}");
            }
            // 문자열 형태의 시간을 Duration으로 변환
            List<Duration> durations = timeList.map((time) {
              List<String> timeParts = time.split(':'); // :를 기준으로 split
              return Duration(
                hours: int.parse(timeParts[0]),
                minutes: int.parse(timeParts[1]),
                seconds: int.parse(timeParts[2]),
              );
            }).toList();

            /*
          List<int> numbers = [1, 2, 3, 4, 5];
          int sum = numbers.reduce((value, element) => value + element);
          print(sum); // 출력: 15 (1+2 + 1+2된거에+3) 이런식으로 누적되게 합해주는게 reduce
          */

            // Duration 합산하기
            Duration timeSum =
                durations.reduce((value, element) => value + element);

            // 평균 계산하기
            Duration average = Duration(
                hours: timeSum.inHours ~/
                    durations
                        .length, // ~/는 정수 나눗셈으로 timeSum안에 속한 시간값 전부인 inHours를 정수로 나눈다.
                minutes: (timeSum.inMinutes % 60) ~/ durations.length,
                seconds: (timeSum.inSeconds % 60) ~/ durations.length);

            // averageTime
            averageTimeResult = average.toString();

            // String 형식의 시간을 Duration으로 변환하는 함수
            durationFromString(String timeString) {
              List<String> parts = timeString.split(':');
              print(parts);
              int hours = int.parse(parts[0]);
              int minutes = int.parse(parts[1]);
              int seconds = int.parse(parts[2]);

              return Duration(hours: hours, minutes: minutes, seconds: seconds);
            }

            // formattedTime을 Duration으로 변환
            Duration formattedDuration =
                durationFromString(timerController.formattedTime());

            // averageTime을 Duration으로 변환
            Duration averageDuration = durationFromString(
                averageTimeResult.toString().split(".").first);

            result = (averageDuration - formattedDuration).toString();

            // 평균과의 차이 계산
            int differenceInSeconds =
                (formattedDuration - averageDuration).inSeconds;
            int absoluteDifference = differenceInSeconds.abs();

            // 차이를 시간, 분, 초로 변환
            int hours = absoluteDifference ~/ 3600;
            int minutes = (absoluteDifference % 3600) ~/ 60;
            int seconds = absoluteDifference % 60;

            // 차이를 문자열로 표시
            timeDifference =
                '${hours > 0 ? '$hours시간 ' : ''}${minutes > 0 ? '$minutes분 ' : ''}${seconds > 0 ? '$seconds초' : ''}';

            // 두 Duration을 비교
            int resultTime = formattedDuration.compareTo(averageDuration);

            // 결과 출력
            if (resultTime < 0) {
              result = '약 $timeDifference 빠릅니다.';
            } else if (resultTime > 0) {
              result = '약 $timeDifference 오래걸렸습니다.';
            } else {
              print('두 시간은 같습니다.');
            }
          }
        } else {
          result = "기록을 남겨서 매번 비교해보세요!";
        }

        return Center(
          child: GestureDetector(
            onTap: () {
              timerController.buttonStatus++;
              print("buttonStatus: ${timerController.buttonStatus}");
              // status가 1이 되는 시점에 시작
              if (timerController.buttonStatus.value == 1) {
                timerController.startTimer();
              }
              print("new buttonStatus: ${timerController.buttonStatus.value}");
            },
            child: Obx(
              () {
                switch (timerController.buttonStatus.value) {
                  case 0:
                    return AnimatedContainer(
                      duration: const Duration(seconds: 2),
                      curve: Curves.easeInOut,
                      width:
                          timerController.animationStatus.value ? 370.0 : 320.0,
                      height:
                          timerController.animationStatus.value ? 370.0 : 320.0,
                      decoration: BoxDecoration(
                        color: timerController.animationStatus.value
                            ? Colors.blue
                            : Colors.amber,
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
                                        "총 ${timerController.resultFormattedTime()} 걸렸습니다!",
                                        style: const TextStyle(
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      snapshot.hasData
                                          ? const Text(
                                              "이번에는 평균보다",
                                              style: TextStyle(
                                                fontSize: 26,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                          : const Text(
                                              "아직 기록이 없습니다.",
                                              style: TextStyle(
                                                fontSize: 26,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                      Text(
                                        result,
                                        style: const TextStyle(
                                          fontSize: 26,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 50,
                                      ),
                                      const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            "한국인 평균 소요시간 : 약 6분",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [Text("- 대한 항문협회 -")],
                                      )
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
                        const SizedBox(
                          height: 30,
                        ),
                        TextButton(
                          onPressed: () {
                            timerController.buttonStatus.value = 0;
                            timerController.startAnimation();
                            // Navigator.pushReplacement(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => const MyApp(),
                            //   ),
                            // );
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) =>
                            //             const MainPageView())).then((value) {});
                          },
                          child: const Column(
                            children: [
                              Icon(Icons.refresh),
                              Text(
                                "다시하기",
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        )
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
