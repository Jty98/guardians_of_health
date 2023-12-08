/*
  기능: 타이머가 끝났을 때의 화면, 기록을 보여주고 저장하는 뷰
*/

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guardians_of_health_project/Components/insert_buttomsheet.dart';
import 'package:guardians_of_health_project/Model/database_handler.dart';
import 'package:guardians_of_health_project/VM/timer_ctrl.dart';
import 'package:guardians_of_health_project/home.dart';

class TimerResultView extends StatelessWidget {
  const TimerResultView({super.key});

  @override
  Widget build(BuildContext context) {
    TimerController timerController = Get.find();
    DatabaseHandler handler = DatabaseHandler();
    List timeList = []; // 사용자의 그동안의 시간 기록을 담을 변수
    String averageTimeResult = "";
    String timeDifference = ""; // 평균과의 차이를 저장할 전역 변수
    String result = ""; // 결과를 저장할 전역 변수
    timerController.resetOpacityValues(); // 빌드할 때 초기화

    return Scaffold(
      appBar: AppBar(
        title: const Text("골든타임"),
        automaticallyImplyLeading: false, // 왼쪽 뒤로가기 버튼 없애기
      ),
      body: FutureBuilder<List<dynamic>>(future: () async {
        List? result = [];
        result.add(await handler.queryRecord());
        return result;
      }(), // 함수를 직접 호출하는 부분 제거
          builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            List<dynamic>? timerRecord = snapshot.data?[0];
            for (int i = 0; i < timerRecord!.length; i++) {
              timeList.add(timerRecord[i].takenTime);
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
              int hours = int.parse(parts[0]);
              int minutes = int.parse(parts[1]);
              int seconds = int.parse(parts[2]);
    
              return Duration(
                  hours: hours, minutes: minutes, seconds: seconds);
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
                '${hours > 0 ? '$hours시간 ' : ''}${minutes > 0 ? '$minutes분 ' : ''}${seconds >= 0 ? '$seconds초' : ''}';
    
            // 두 Duration을 비교
            int resultTime = formattedDuration.compareTo(averageDuration);
    
            // 결과 출력
            if (resultTime < 0) {
              result = '약 $timeDifference 빨리 끝났습니다..';
            } else if (resultTime > 0) {
              result = '약 $timeDifference 오래걸렸습니다.';
            } else {
              result = '평균적인 시간에 끝났습니다.';
            }
          }
        } else {
          result = "기록을 남겨서 매번 비교해보세요!";
        }
    
        return Obx(() {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                      child: AnimatedOpacity(
                        opacity: timerController.opacityUpdateFunction(
                            600, timerController.opacityUpdate1),
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
                        opacity: timerController.opacityUpdateFunction(
                            1800, timerController.opacityUpdate3),
                        duration: const Duration(milliseconds: 1800),
                        child: Image.asset(
                          "assets/images/firecracker3.png",
                        ),
                      ),
                      Center(
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 2400),
                          opacity: timerController.opacityUpdateFunction(
                              2400, timerController.opacityUpdate4),
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
                                      "당신의 평균시간과 비교해보면",
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
                                mainAxisAlignment: MainAxisAlignment.end,
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
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [Text("- 대한대장항문협회 -")],
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
                        opacity: timerController.opacityUpdateFunction(
                            1200, timerController.opacityUpdate2),
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
                  onPressed: () => insertBottomSheet(context),
                  child: const Text("기록 남기러가기"),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextButton(
                  onPressed: () {
                    timerController.resetBottomSheetValues(); // 바텀시트 선택들 초기화
                    Get.offAll(() => const Home(),
                    transition: Transition.noTransition,
                    );
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
            ),
          );
        });
      }),
    );
  }
}