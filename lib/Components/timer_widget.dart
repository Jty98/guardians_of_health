import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:guardians_of_health_project/Model/result_model.dart';
import 'package:guardians_of_health_project/VM/timer_ctrl.dart';
import 'package:guardians_of_health_project/View/mainpage_view.dart';

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
                // timerController.buttonStatus -= 2;
                // MainPageView 내부에서 사용자의 액션에 따라 호출되는 부분
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
                          "배변을 시작하면 나를 눌러주세요!",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
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
                  case 2:
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                                  child: Text(
                                    "축하합니다!\n${timerController.formattedTime()}의 ",
                                    style: const TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),
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
                            showButtomSheet(context);
                          },
                          child: const Text("기록 남기러가기"),
                        ),
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
showButtomSheet(context) {
  TimerController timerController = Get.find();

  Get.bottomSheet(
    SingleChildScrollView(
      child: GestureDetector(
        onTap: () {
          // iOS에서만 키보드 강제로 내리기
          if (Platform.isIOS) {
            SystemChannels.textInput.invokeMethod('TextInput.hide');
          }
          // FocusScope.of(context).unfocus();
        },
        child: Container(
          padding: const EdgeInsets.all(20.0),
          color: Colors.pink,
          height: 600,
          width: 400,
          child: Column(
            children: [
              const Text(
                "배변기록",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(15.0),
                child: Text("사진 남기기"),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    color: Colors.blue,
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.add_a_photo),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.add_photo_alternate_rounded),
                  ),
                ],
              ),
              const Text("만족도"),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  starRatingbar(),
                ],
              ),
              const Text("기록"),
              SizedBox(
                height: 150,
                width: 300,
                child: TextField(
                  controller: timerController.resultTextController,
                  maxLines: null, // 여러 줄을 쓰기위해 null
                  decoration: const InputDecoration(
                    hintText: "배변 중 특이사항을 기록해주세요.",
                    border: OutlineInputBorder(),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ),
  );
}

  // ratingbar
  Widget starRatingbar() {
    return RatingBar.builder(
      initialRating: ResultModel.resultRating,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: (rating) {
        ResultModel.resultRating = rating;
        // timerController.resultRating.value = rating;
        print(rating);
        print(ResultModel.resultRating);
      },
    );
  }
} // End
